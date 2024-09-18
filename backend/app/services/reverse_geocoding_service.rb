require 'net/http'
require 'json'
# Sometimes latitude and longitude is present but not city and state.
# This service fetches the city and state from the coordinates.

class ReverseGeocodingService
  REVERSE_GEOCODING_URL = "https://api.openweathermap.org/geo/1.0/reverse"

  def initialize(lat, lon)
    @lat = lat
    @lon = lon
  end

  def fetch_location
    response = make_request
    raise "Failed to fetch location" unless response.is_a?(Net::HTTPSuccess)

    data = JSON.parse(response.body).first

    # if it were more complex I would add a serializer.
    {
      city: data['name'],
      state: data['state']
    }
  end

  private

  def make_request
    uri = URI(REVERSE_GEOCODING_URL)
    params = {
      lat: @lat,
      lon: @lon,
      appid: ENV['OPENWEATHERMAP_API_KEY'],
      limit: 1
    }
    uri.query = URI.encode_www_form(params)

    Net::HTTP.get_response(uri)
  end
end
