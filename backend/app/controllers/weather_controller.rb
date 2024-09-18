class WeatherController < ApplicationController
  before_action :validate_location_params, only: :show

  def show
    weather = WeatherCacheService.new(weather_params).get_weather
    render json: weather, serializer: WeatherSerializer, status: :ok
  rescue StandardError => e # this < should be a more specific error class
    Rails.logger.error "Error fetching weather data: #{e.message}"
    error_message = 'Unable to fetch weather data. Please try again later.'
    render json: { error: error_message }, status: :internal_server_error
  end

  private

  def weather_params
    params.permit(:city, :state, :latitude, :longitude)
  end

  def validate_location_params
    return if valid_params?([:city, :state]) || valid_params?([:latitude, :longitude])

    error_message = 'Either city/state or latitude/longitude must be provided.'
    render json: { error:  error_message }, status: :unprocessable_entity
  end

  def valid_params?(keys)
    keys.all? { |key| weather_params[key].present? }
  end
end
