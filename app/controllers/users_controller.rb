class UsersController < ApplicationController

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      weather = WeatherAPI.new(@user.city)
      @conditions = weather.get_comparison_result
      send_mail(@user, @conditions)
      flash[:success] = "You've subscribed to the Weather Email List!"
      redirect_to @user
    else
      flash.now[:danger] = "Sorry! There's an error in your sign-up"
      render :new
    end
  end


  def show
    @user = User.find(params[:id])
    @image = GiphyAPI.getRandomGIF("beach")
  end


  private

  def user_params
    params.require(:user).permit(:email, :city)
  end

  def send_mail(user, conditions)
    subject = ""
    if conditions[:internal_desc] == "Nice"
      subject = "It's nice out! Enjoy a discount on us."
      pre_image_text = "Enjoy the "
    elsif conditions[:internal_desc] == "Not Nice"
      subject = "Not so nice out? That's okay, enjoy a discount on us."
      pre_image_text = "Sorry about the "
    else
      subject = "Enjoy a discount on us."
      pre_image_text = "Just your average day of "
    end
    UserMailer.discount(user, conditions, subject, pre_image_text).deliver!
  end


end
