class WeatherAPI

  include HTTParty
  BASE_URI = 'http://api.wunderground.com/api/'
  KEY = ENV['WUNDERGROUND_KEY'] || ENV['wunderground_key']
  CONDITIONS = '/conditions/q/'
  ALMANAC = '/almanac/q/'


  # initialize API wrapper and get city and state into correct format
  def initialize(user_city)
    city_state_array = user_city.split(', ')
    @city = city_state_array[0].gsub(' ', '_')
    @state = city_state_array[1]
  end
 
  # compare current weather to average historical high and low temps for this day and return necessary results to customize email
  def get_comparison_result(current, average_temps)
    internal_desc = ""
    if current[:temp].to_f - 5 >= average_temps[:high].to_f || 
       current[:description] == "Sunny"
      internal_desc = "Nice"
    elsif current[:temp].to_f + 5 <= average_temps[:low].to_f || current[:precip] > 0
      internal_desc = "Not Nice"
    else
      internal_desc = "Normal"
    end
    return {
      internal_desc: internal_desc,
      description: current[:description],
      temp: current[:temp],
      icon: current[:icon]
    }
  end

  # get current weather information from Wunderground API
  def get_current_weather
    full_url = build_url(CONDITIONS)
    current_observation = HTTParty.get(full_url)["current_observation"]
    # uncomment the next object and comment the line above in order to test app functionality without making API cals
    # current_observation = {
    #   "temp_f" => "90",
    #   "weather" => "Partly Cloudy",
    #   "precip_today_in" => "0.00",
    #   "icon_url" => "http://icons.wxug.com/i/c/k/mostlycloudy.gif"
    # }
    return {temp: current_observation["temp_f"], 
            description: current_observation["weather"],
            precip: current_observation["precip_today_in"].to_f,
            icon: current_observation["icon_url"]
            }
  end

  # get average temperature for this day from Wunderground API
  def get_average_temp
    full_url = build_url(ALMANAC)
    history = HTTParty.get(full_url)["almanac"]
    high = history["temp_high"]["normal"]["F"]
    low = history["temp_low"]["normal"]["F"]
    # uncomment the two lines below and comment the two above to test app functionality without making API calls
    # high = "64"
    # low = "50"
    return {
      high: high,
      low: low
    }
  end

  # build full API request based on which table is being targeted
  def build_url(table)
    return BASE_URI + KEY + table + @state + "/" + @city + ".json"   
  end


end