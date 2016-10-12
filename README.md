# README

Weather Powered Email allows a user to sign up with an email address and a location, which they choose from a list of the 100 most populated cities in the United States. Upon sign-up, the user will receive an email to their submitted email address which contains a personalized message based on the weather at that location. The weather data is pulled from the Wunderground API.

The live version of the app is available at https://weather-based-email.herokuapp.com/.

# Instructions

To run the app locally, clone the repo to your local machine, run 'rake db:migrate', and then start a local Rails server and go to localhost:3000 in your browser of choice. Once the page loads, enter your email address and choose a city from the dropdown list. You can do this as many times as you want, but only once per email address.


When you want to send an email to all subscribed users, open up the Rails console and enter "User.send_all_weather_emails". This will send an email to each email address with custom content based on the weather at that user's location. If you're in a development environment, the email sends will not send an actual email, but instead will display the emails in a new browser tab by using the Letter Opener gem. In order to avoid hitting a rate limit on the Wunderground API, the emails are sent once every 30 seconds.



# Technical Highlights

# Email validation:
Emails are validated for uniqueness at two levels. The first is at the model level, where, in user.rb, uniqueness for the email is set to true. The second is at the database level, where a unique index is set on the email attribute of user.

#Weather API: 
The weather_api.rb file contains the methods for making API calls based on a user's selected location. This class receives a "city, STATE" string upon initialization, parses it into the correct components, and builds url strings for current and historical data available in the Wunderground API. The class then builds return objects necessary to build custom emails.

Since Wunderground has limits on the number of calls available per day on their free tier, the file has lines that can be uncommented in order to set hard-coded responses for testing purposes. 

#Giphy API: 
The giphy_api.rb file contains the methods for making API calls to the Giphy API. This is used upon user sign-up to produce a random GIF with tag "celebrate", along with including GIFs in the email sends. 

#Test Suite:
user_spec.rb and weather_api_spec.rb provide test coverage for user creation and the logic to determine what content is sent in an email. 


