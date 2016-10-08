class UserMailer < ApplicationMailer

  default from: "alexglach@gmail.com"

  def discount(user, conditions, subject, pre_image_text)
    @user = user
    @temp = conditions[:temp]
    @desc = conditions[:description].downcase
    @icon = conditions[:icon]
    @pre_image_text = pre_image_text
    mail(to: @user.email, subject: subject)
  end

end
