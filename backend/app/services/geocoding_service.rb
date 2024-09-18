require 'net/http'
require 'json'
# This service fetches the coordinates from the city and state.
class GeocodingService
  GEOCODING_URL = "https://api.openweathermap.org/geo/1.0/direct"

  def initialize(city, state)
    @city = city
    @state = state
  end

  def fetch_coordinates
    response = make_request
    raise "Failed to fetch coordinates" unless response.is_a?(Net::HTTPSuccess)

    data = JSON.parse(response.body).first

    raise "Failed to fetch coordinates" unless data

    {
      lat: data['lat'],
      lon: data['lon']
    }
  end

  private

  def make_request
    uri = URI(GEOCODING_URL)
    params = {
      q: "#{@city},#{@state},US",
      appid: ENV['OPENWEATHERMAP_API_KEY'],
      limit: 1
    }
    uri.query = URI.encode_www_form(params)

    Net::HTTP.get_response(uri)
  end
end
