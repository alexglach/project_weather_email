require 'rails_helper'

describe WeatherAPI do
  
  context '.get_comparison_result' do

    let(:current){{
      icon: "http://icons.wxug.com/i/c/k/mostlycloudy.gif",
      precip: 0.00,
      temp: '70',
      description: 'Mostly Cloudy'
      }}

    let(:average){{
        high: "70",
        low: "50"
      }}
    let(:weather){WeatherAPI.new("Boston, MA")}

    it 'returns nice for sunny' do
      current[:description] = "Sunny" 
      expect(weather.get_comparison_result(current, average)[:internal_desc]).to eq('Nice') 
    end

    it 'returns nice for clear' do
      current[:description] = 'Clear' 
      expect(weather.get_comparison_result(current, average)[:internal_desc]).to eq('Nice') 
    end

    it 'returns nice for 5 degrees over average' do
      current[:temp] = '75.1'
      expect(weather.get_comparison_result(current, average)[:internal_desc]).to eq('Nice') 
    end

    it 'returns not nice for 5 degrees below average' do
      current[:temp] = '44.9' 
      expect(weather.get_comparison_result(current, average)[:internal_desc]).to eq('Not Nice') 
    end

    it 'returns not nice for any precipitation' do
      current[:temp] = '54.9' 
      current[:precip] = 0.01 
      expect(weather.get_comparison_result(current, average)[:internal_desc]).to eq('Not Nice') 
    end

    it 'returns normal for no nice or not nice conditions' do 
      expect(weather.get_comparison_result(current, average)[:internal_desc]).to eq('Normal') 
    end


  end
end
