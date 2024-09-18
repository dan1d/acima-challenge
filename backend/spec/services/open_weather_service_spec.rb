require 'rails_helper'

RSpec.describe OpenWeatherService, type: :service do
  let(:city) { 'New York' }
  let(:state) { 'NY' }
  let(:lat) { 40.7128 }  # New York
  let(:lon) { -74.0060 } # New York

  describe '#get_weather', vcr: { cassette_name: 'openweather_api' } do
    context 'when the request is successful' do
      it 'returns the weather data' do
        VCR.use_cassette('openweather_api_success') do
          service = OpenWeatherService.new(city, state, lat, lon)
          result = service.get_weather

          expect(result[:temperature]).to be_a(Numeric)
          expect(result[:description]).to be_a(String)
        end
      end
    end

    context 'when the request fails' do
      it 'raises an error' do
        VCR.use_cassette('openweather_api_error') do
          stub_request(:get, /api.openweathermap.org/).to_return(status: 500, body: '')

          service = OpenWeatherService.new(city, state, lat, lon)

          expect { service.get_weather }.to raise_error('Failed to fetch weather data')
        end
      end
    end
  end
end
