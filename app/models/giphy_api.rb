class GiphyAPI

  include HTTParty

  def self.getRandomGIF(tag)
    response = HTTParty.get('http://api.giphy.com/v1/gifs/random?api_key=dc6zaTOxFJmzC&rating=pg&tag=' + tag)
    return response["data"]["image_url"]
  end


end