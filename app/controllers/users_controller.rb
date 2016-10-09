class UsersController < ApplicationController

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      weather = WeatherAPI.new(@user.city)
      @conditions = weather.get_comparison_result
      User.send_signup_mail(@user, @conditions)
      flash[:success] = "You've subscribed to the Weather Email List!"
      redirect_to @user
    else
      flash.now[:danger] = "Sorry! There's an error in the information you entered. Please try again."
      render :new
    end
  end


  def show
    @user = User.find(params[:id])
    @image = GiphyAPI.getRandomGIF("celebrate")
  end


  private

  def user_params
    params.require(:user).permit(:email, :city)
  end



end
