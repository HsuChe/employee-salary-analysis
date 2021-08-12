<h3 align="center">Employee Salary SQL Challenge</h3>

<p align="center">
     Using SQL and python to pass a interview.
    <br />
    <a href="https://github.com/HsuChe/sql-challenge"><strong>Project Github URL »</strong></a>
    <br />
    <br />
  </p>
</p>

<!-- ABOUT THE PROJECT -->

## About The Project

![hero image](https://github.com/HsuChe/sql-challenge/blob/066cf19bf3c139bb6051b43ccaf67d9ed1b1f578/images/hero_image.jpg)

We are going to prove the correlation between the distance from the equator and the rising max temperature. To do this, we will need to create a dataset through API.

Features of the dataset:

* The Dataset will need the following for the proof.

  * city: **The name of the city**
  * Lat: **Latitude of the city**
  * Lng: **Longitude of the city**
  * Max Temp: **The maximum temperature of the city**
  * Humidity: **Humidity level of the city on the date API was called**
  * Cloudiness: **The cloudiness of the city the date API was called**
  * Wind Speed: **Speed of the wind the date API was called**
  * Date: **The date the API was called**
* The dataset is in the csv file format with delimiter of comma.
* Download Dataset click [HERE](https://github.com/HsuChe/pandas-challenge/blob/0f628f032da5f551f4000b80c5b4ccd4dd77c3ab/HeroesOfPymoli/Resources/purchase_data.csv)

## Generating the cities

We first need to generate a list of cities to be processed

* create list of random coordinates given a range.

  ```sh
  city_df = pd.DataFrame()
  city_df['city'] = ''

  lat_range = np.random.uniform(low=-90.000, high=90.000, size=1500)
  long_range = np.random.uniform(low=-180.000, high=180.000, size=1500)
  ```

We then generate a dataframe with the name of the city.

* create list of random coordinates given a range.

  ```sh
  for index in range(len(lat_range)):
      city_df.loc[index, 'city'] = citipy.nearest_city(lat_range[index],long_range[index]).city_name

  city_df = city_df.drop_duplicates('city',keep='last').reset_index(drop=True)

  city_df['Lat'] = 'NaN'
  city_df['Lng'] = 'NaN'
  city_df['Max Temp']	= 'NaN'
  city_df['Humidity']	= 'NaN'
  city_df['Cloudiness'] = 'NaN'
  city_df['Wind Speed']= 'NaN'
  city_df['Date']= 'NaN'

  city_df
  ```

### Performing the API calls

After generating the list of cities, generate the remaining needed data through API calls.

* finding the total unique players in the dataset.

  ```sh
  def query_url(city):
      weather_key = api_keys.weather_api_key
      url = 'http://api.openweathermap.org/data/2.5/weather?'
      units = 'imperial'
      query_url = f'{url}appid={weather_key}&units={units}&q={city}'

      return query_url
  ```

Then we can generate the columns for the city DataFrame and use a for loop for the API calls. 

* a function to populate rows in the DataFrame

  ```sh
  def generate_df(df,index,response):
      df.loc[index, 'Lat'] = response['coord']['lat']
      df.loc[index, 'Lng'] = response['coord']['lon']
      df.loc[index,'Country'] = response["sys"]["country"]
      df.loc[index,'Max Temp']= response['main']['temp_max']
      df.loc[index, 'Humidity'] = response['main']['humidity']
      df.loc[index, 'Cloudiness'] = response['clouds']['all']
      df.loc[index, 'Wind Speed'] = response['wind']['speed']
      df.loc[index, 'Date'] = response['dt']
  ```
* we will generate a dictionary for formatting into a summary table DataFrame:

  ```sh
  set_index = 0
  set_num = 1
  for index, row in city_df.iterrows():
      city_name = row['city']
      query = query_url(city_name)
      try:
          response = requests.get(query).json()
          generate_df(city_df,index,response)
          if set_index == 50:
              set_num += 1
              set_index = 0
          else:
              set_index += 1
          print(f'Processing Record {set_index} of Set {set_num} : {city_name}')
      except(KeyError,IndexError):
          city_df.drop([index])
          print('City not Found. Skipping...')
  ```

### Plotting the Data

After we generate the city DataFrame, we can now plot data to prove the relationship between distance from the equator and temperature.

* Generating data using the groupby method
  ```sh
  df.plot.scatter(x = 'Max Temp', y = 'Lat', figsize = (8,6))
  plt.title('Temperature vs Latitude')

  df.plot.scatter(x = 'Humidity', y = 'Lat', figsize = (8,6))
  plt.title('Humidity vs Latitude')

  df.plot.scatter(x = 'Cloudiness', y = 'Lat', figsize = (8,6))
  plt.title('Cloudiness vs Latitude')

  df.plot.scatter(x = 'Wind Speed', y = 'Lat', figsize = (8,6))
  plt.title('WInd Speed vs Latitude')
  ```

Next we can generate Linear Regressions for the Dataset as well. 

* using scipy.stat, we can calculate the linear regression.
  ```sh
  from scipy.stats import linregress

  # Define the hemispheres

  north_hem_df = df.loc[df['Lat'] > 0 ]
  south_hem_df = df.loc[df['Lat'] < 0 ]

  def linear_regression_hemisphere(hemisphere,x_column,y_column):
      hemisphere.plot.scatter(x=x_column, y = y_column, figsize = (8,6))
      x_value = hemisphere[x_column]
      y_value = hemisphere[y_column]
      (slope, intercept, rvalue, pvalue, stderr) = linregress(x_value,y_value)
      regress_value = x_value * slope + intercept
      line_eq = f"y = {slope.round(2)} * x_value + {intercept.round(2)}"
      print(line_eq)
      plt.plot(x_value, regress_value, 'r', color = 'blue')
      plt.title('Regression: temperature vs. latitude (north hemisphere)')
      plt.show()
  ```

Next we will input all the calculations into a summary table.

* create the linear regressions.
  ```sh
  linear_regression_hemisphere(north_hem_df, 'Lat', 'Max Temp')
  linear_regression_hemisphere(south_hem_df, 'Lat', 'Max Temp')
  linear_regression_hemisphere(north_hem_df, 'Lat', 'Humidity')
  linear_regression_hemisphere(south_hem_df, 'Lat', 'Humidity')
  near_regression_hemisphere(north_hem_df, 'Lat', 'Cloudiness')
  linear_regression_hemisphere(south_hem_df, 'Lat', 'Cloudiness')
  linear_regression_hemisphere(north_hem_df, 'Lat', 'Wind Speed')
  linear_regression_hemisphere(north_hem_df, 'Lat', 'Wind Speed')
  ```

### Analyze vacation information

We can use the Dataset that was generated in the weather data to draw maps and find hotels. 

* Get the Dataset for import
  ```sh
  df_raw  = pd.read_csv('Data/Cities_clean.csv')
  ```

Next, generate the heatmap with the Dataset.

* use gmps.configure to put in the API key
  ```sh
  test_data  = df_raw[['Lat','Lng','Humidity','Country']]
  gmaps.configure(api_key = g_key)

  fig = gmaps.figure()
  locations = test_data[["Lat", "Lng"]]
  rating = test_data["Humidity"].astype(float)
  max_humidity = test_data['Humidity'].max()

  # Create heat layer
  heat_layer = gmaps.heatmap_layer(locations, weights=rating, 
                                   dissipating=False, max_intensity=max_humidity,
                                   point_radius=1)
  # Add layer
  fig.add_layer(heat_layer)

  # Display figure
  fig
  ```

Next, lets narrow the Dataset down with specific parameters that we are looking for on our vacation. 

* reduce the range of cities with these parameters
  ```sh
  # max temperature lower than 80 but higher than 70
  df_temp = df_raw.loc[df_raw['Max Temp'] < 80 ]
  df_temp = df_temp.loc[df_raw['Max Temp'] > 70 ]
  # # wind speed less than 10mph
  df_wind = df_temp.loc[df_temp['Wind Speed'] < 10]
  # # zero cloudiness
  df_cloud = df_wind.loc[df_wind['Cloudiness'] == 0]
  df_clean = df_cloud.reset_index(drop=True)
  df_clean
  ```

### Find the hotels

Generate a new DataFrame for the hotels. 

* We will be using city, country, lat, lng, and hotel name in the API call.
  ```sh
  hotel_df = df_clean.loc[:,['city','Country','Lat','Lng']]
  hotel_df['Hotel Name'] = ''
  hotel_df

  import time
  import requests

  base_url = "https://maps.googleapis.com/maps/api/place/nearbysearch/json"

  params = {"type" : "hotel",
            "keyword" : "hotel",
            "radius" : 5000,
            "key" : g_key}

  for index, row in hotel_df.iterrows():
      city_name = row.loc['city']
      lat = row["Lat"]
      lng = row["Lng"]
      params["location"] = f"{lat},{lng}"
      print(f'Retriving Reulst for Index {index}: {city_name}')
      try:
          response = requests.get(base_url, params = params).json()
          hotel_df.loc[index,'Hotel Name'] = response['results'][0]['name']

      except (KeyError,IndexError):
          print("Missing field/result... skipping.")
      print('----------------------------------------------------------------')

      time.sleep(1)

  print('Finished Searching')
  ```

This will give us a DataFrame with the names of all the hotels near the cities that matches the criterias we want. Lastly, we generate the name markers of our hotels on the city locations in google maps.

* create the markers for google maps. 
  ```sh
  # Add marker layer ontop of heat map
  markers = gmaps.marker_layer(locations, info_box_content = hotel_info)

  # Add the layer to the map
  fig.add_layer(markers)

  # Display Map
  fig
  ```
