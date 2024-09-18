require 'rails_helper'

RSpec.describe 'Weather API', type: :request do
  let(:city) { 'New York' }
  let(:state) { 'NY' }
  let(:latitude) { 40.7128 }
  let(:longitude) { -74.0060 }

  describe 'GET /weather' do
    context 'when the city and state are provided', vcr: { cassette_name: 'weather_api_success_city_state' } do
      it 'returns weather data from cache or API' do
        get '/weather', params: { city: city, state: state }

        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response['city']).to eq(city)
        expect(json_response['temperature']).to be_a(Numeric)
        expect(json_response['description']).to be_a(String)
      end
    end

    context 'when latitude and longitude are provided', vcr: { cassette_name: 'weather_api_success_lat_lon' } do
      it 'returns weather data from cache or API' do
        get '/weather', params: { latitude: latitude, longitude: longitude }

        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response['temperature']).to be_a(Numeric)
        expect(json_response['description']).to be_a(String)
      end
    end

    context 'when city or state is missing' do
      it 'returns an error' do
        get '/weather', params: { city: city }

        expect(response).to have_http_status(422)
        json_response = JSON.parse(response.body)
        expect(json_response['error']).to eq('Either city/state or latitude/longitude must be provided.')
      end
    end

    context 'when latitude or longitude is missing' do
      it 'returns an error' do
        get '/weather', params: { latitude: latitude }

        expect(response).to have_http_status(422)
        json_response = JSON.parse(response.body)
        expect(json_response['error']).to eq('Either city/state or latitude/longitude must be provided.')
      end
    end
  end
end
