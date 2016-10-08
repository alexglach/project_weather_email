class UserMailer < ApplicationMailer

  default from: "alexglach@gmail.com"

  def discount(user, conditions, subject, pre_image_texts, gif)
    @user = user
    @temp = conditions[:temp]
    @desc = conditions[:description].downcase
    @icon = conditions[:icon]
    @first_gif = gif
    @celeb_gif = GiphyAPI.getRandomGIF("celebrate")
    @pre_image_texts = pre_image_texts
    mail(to: @user.email, subject: subject)
  end

end
