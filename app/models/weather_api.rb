class WeatherAPI

  include HTTParty
  BASE_URI = 'http://api.wunderground.com/api/'
  KEY = ENV['wunderground_key']
  CONDITIONS = '/conditions/q/'
  ALMANAC = '/almanac/q/'

  attr_reader :city, :state

  def initialize(user_city)
    city_state_array = user_city.split(', ')
    @city = city_state_array[0].gsub(' ', '_')
    @state = city_state_array[1]
    get_comparison_result
  end

  def get_comparison_result
    current = get_current_weather
    average_temp = get_average_temp
    internal_desc = ""
    if current[:temp].to_f - 5 >= average_temp.to_f || 
       current[:description] == "Sunny"
      internal_desc = "Nice"
    elsif current[:temp].to_f + 5 <= average_temp.to_f || current[:precip] > 0
      internal_desc = "Not Nice"
    else
      internal_desc = "Normal"
    end
    return {
      internal_desc: internal_desc,
      description: current[:description],
      temp: current[:temp]
    }
  end

  def get_current_weather
    full_url = build_url(CONDITIONS)
    # current_observation = HTTParty.get(full_url)["current_observation"]
    current_observation = {
      "temp_f" => "68",
      "weather" => "Partly Cloudy",
      "precip_today_in" => "0.01"
    }
    return {temp: current_observation["temp_f"], 
            description: current_observation["weather"],
            precip: current_observation["precip_today_in"].to_f}
  end

  def get_average_temp
    full_url = build_url(ALMANAC)
    # average = HTTParty.get(full_url)["almanac"]["temp_high"]["normal"]["F"]
    average = "64"
    return average
  end

  def build_url(table)
    return BASE_URI + KEY + table + @state + "/" + @city + ".json"   
  end


end