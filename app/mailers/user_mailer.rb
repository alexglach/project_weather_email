class UserMailer < ApplicationMailer

  default from: "alexglach@gmail.com"

  def discount(user, conditions, subject)
    @user = user
    @temp = conditions[:temp]
    @desc = conditions[:description]
    mail(to: @user.email, subject: subject)
  end

end
