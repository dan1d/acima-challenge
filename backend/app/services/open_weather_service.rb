require 'net/http'
require 'json'

# This service fetches the weather data from the OpenWeather API.
# It returns the weather data in a format that can be used by the WeatherCacheService.
class OpenWeatherService
  BASE_URL = "https://api.openweathermap.org/data/2.5/weather"

  def initialize(city, state, lat, lon)
    @city = city
    @state = state
    @lat = lat
    @lon = lon
  end

  def get_weather
    response = make_request

    raise "Failed to fetch weather data" unless response.is_a?(Net::HTTPSuccess)

    parsed_json = JSON.parse(response.body)
    OpenWeatherDeserializer.new(parsed_json, @city, @state).to_weather
  end

  private

  def make_request
    uri = URI(BASE_URL)
    params = {
      lat: @lat,
      lon: @lon,
      appid: ENV['OPENWEATHERMAP_API_KEY'],
      units: 'metric',
      exclude: 'minutely,hourly,daily,alerts'
    }
    uri.query = URI.encode_www_form(params)

    Net::HTTP.get_response(uri)
  end
end
