require 'rails_helper'

RSpec.describe User, type: :model do
  
  let(:new_user){ build(:user) }

  it 'is valid with email address and location' do
    expect(new_user).to be_valid
  end

  it 'is invalid with no email address' do
    no_email_user = build(:user, email:"")
    expect(no_email_user.valid?).to eq(false)
  end

  it 'is invalid with no location' do
    no_city_user = build(:user, city:"")
    expect(no_city_user.valid?).to eq(false)
  end

  it 'is invalid with a location not in the top 100 cities' do
    outside_city_user = build(:user, city:"Lexington, MA")
    expect(outside_city_user.valid?).to eq(false)
  end

  it 'saves with valid email address and location' do
    expect{new_user.save!}.to_not raise_error
  end

  it 'persists in the database upon saving' do
    expect{new_user.save!}.to change(User, :count).by(1)
  end



  context 'creating multiple users' do
    before do
      new_user.save!
    end
    it 'is invalid with duplicate email address' do
      second_user = build(:user, email: new_user.email)
      expect(second_user.valid?).to eq(false)
    end
  end

  context '.send_weather_mail' do
    let(:conditions){{
        description: "Partly Cloudy",
        temp: "90",
        icon: "http://icons.wxug.com/i/c/k/mostlycloudy.gif"
      }}
    before do
      new_user.save!
    end
    it 'creates specific subject line for nice weather and sends email' do
      conditions[:internal_desc] = "Nice"
      expect(User.send_weather_email(new_user, conditions)).to eq("It's nice out! Enjoy a discount on us.")
      expect{User.send_weather_email(new_user, conditions)}.to change(ActionMailer::Base.deliveries, :count).by(1)
    end

    it 'creates specific subject line for not nice weather and sends email' do
      conditions[:internal_desc] =  "Not Nice"
      expect(User.send_weather_email(new_user, conditions)).to eq("Not so nice out? That's okay, enjoy a discount on us.")
      expect{User.send_weather_email(new_user, conditions)}.to change(ActionMailer::Base.deliveries, :count).by(1)
    end

    it 'creates specific subject line for average weather and sends email' do
      conditions[:internal_desc] =  "Normal"
      expect(User.send_weather_email(new_user, conditions)).to eq("Enjoy a discount on us.")
      expect{User.send_weather_email(new_user, conditions)}.to change(ActionMailer::Base.deliveries, :count).by(1)
    end
  end


end
