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

  def send_mail(user, conditions)
    subject = ""
    if conditions[:internal_desc] == "Nice"
      subject = "It's nice out! Enjoy a discount on us."
      pre_image_texts = get_pre_image_texts(0)
      gif = "https://media.giphy.com/media/xTiTnyijMsXgn6Bzzy/giphy.gif"
    elsif conditions[:internal_desc] == "Not Nice"
      subject = "Not so nice out? That's okay, enjoy a discount on us."
      pre_image_texts = get_pre_image_texts(1)
      gif = "https://media.giphy.com/media/l2JefZqHH238j3U5i/giphy.gif"
    else
      subject = "Enjoy a discount on us."
      pre_image_texts = get_pre_image_texts(2)
      gif = "https://media.giphy.com/media/l0K3ZRJ1IXfxgmMQU/giphy.gif"
    end
    UserMailer.discount(user, conditions, subject, pre_image_texts, gif).deliver!
  end

  def get_pre_image_texts(num)
    if num == 0
      return ["Don't even look out the window. Here's what it looks like: ", "We want to you to get out there and enjoy the day, so we're sending you a discount. Get excited!",  "Enjoy the "]
    elsif num == 1
      return ["If you've looked outside, you probably have one goal for the day: ", "But we don't want that to happen, so we're sending you a discount. Hooray!" "Sorry again about the "]
    else 
      return ["The weather is what is. Neither good or bad. We know what you're thinking:", "So to add a little excitement to your day, we're sending you a discount. Yeah!",  "Don't be too mad at the"]
    end
  end



end
