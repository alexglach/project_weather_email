class User < ApplicationRecord

  validates :email, 
           uniqueness: true, 
           presence: true
  validates :city, presence: true, inclusion: {in: CITIES}

  def self.send_all_weather_emails
    User.all.each do |user|
      weather = WeatherAPI.new(user.city)
      conditions = weather.get_comparison_result(weather.get_current_weather, weather.get_average_temp)
      User.send_weather_email(user, conditions)
      # delay calls to not go over API rate limits and get shut down
      sleep 30
    end
  end


  def self.send_weather_email(user, conditions)
    subject = ""
    # set GIF and email text based on weather conditions
    if conditions[:internal_desc] == "Nice"
      subject = "It's nice out! Enjoy a discount on us."
      pre_image_texts = User.get_pre_image_texts(0)
      gif = "https://media.giphy.com/media/xTiTnyijMsXgn6Bzzy/giphy.gif"
    elsif conditions[:internal_desc] == "Not Nice"
      subject = "Not so nice out? That's okay, enjoy a discount on us."
      pre_image_texts = User.get_pre_image_texts(1)
      gif = "https://media.giphy.com/media/l2JefZqHH238j3U5i/giphy.gif"
    else
      subject = "Enjoy a discount on us."
      pre_image_texts = User.get_pre_image_texts(2)
      gif = "https://media.giphy.com/media/l0K3ZRJ1IXfxgmMQU/giphy.gif"
    end
    # send email out
    UserMailer.discount(user, conditions, subject, pre_image_texts, gif).deliver!
    return subject
  end

  def self.get_pre_image_texts(num)
    # set email text based on weather conditions
    if num == 0
      return ["Don't even look out the window. Here's what it looks like: ", "We want to you to get out there and enjoy the day, so we're sending you a discount. Get excited!"]
    elsif num == 1
      return ["If you've looked outside, you probably have one goal for the day: ", "But we don't want that to happen, so we're sending you a discount. Hooray!"]
    else 
      return ["The weather is what it is. Neither good or bad. We know what you're thinking:", "So to add a little excitement to your day, we're sending you a discount. Hooray!"]
    end
  end


end
