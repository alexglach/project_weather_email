class WeatherAPI

  include HTTParty
  BASE_URI = 'http://api.wunderground.com/api/'
  KEY = ENV['wunderground_key']
  CONDITIONS = '/conditions/q/'
  ALMANAC = '/almanac/q/'


  def initialize(user_city)
    city_state_array = user_city.split(', ')
    @city = city_state_array[0].gsub(' ', '_')
    @state = city_state_array[1]
  end

  def get_comparison_result
    current = get_current_weather
    average_temps = get_average_temp
    internal_desc = ""
    if current[:temp].to_f - 5 >= average_temps[:high].to_f || 
       ["Sunny", "Clear"].include?(current[:description])
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

  def get_current_weather
    full_url = build_url(CONDITIONS)
    # current_observation = HTTParty.get(full_url)["current_observation"]
    current_observation = {
      "temp_f" => "30",
      "weather" => "Partly Cloudy",
      "precip_today_in" => "0.00",
      "icon_url" => "http://icons.wxug.com/i/c/k/mostlycloudy.gif"
    }
    return {temp: current_observation["temp_f"], 
            description: current_observation["weather"],
            precip: current_observation["precip_1hr_in"].to_f,
            icon: current_observation["icon_url"]
            }
  end

  def get_average_temp
    full_url = build_url(ALMANAC)
    # history = HTTParty.get(full_url)["almanac"]
    # high = history["temp_high"]["normal"]["F"]
    # low = history["temp_low"]["normal"]["F"]
    high = "64"
    low = "50"
    return {
      high: high,
      low: low
    }
  end

  def build_url(table)
    return BASE_URI + KEY + table + @state + "/" + @city + ".json"   
  end


end