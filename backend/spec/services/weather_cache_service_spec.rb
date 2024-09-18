require 'rails_helper'

RSpec.describe WeatherCacheService, type: :service do
  let(:city) { 'New York' }
  let(:state) { 'NY' }
  let(:latitude) { 40.7128 }
  let(:longitude) { -74.0060 }
  let(:cached_weather) {
    Weather.create!(
      city: city,
      state: state,
      temperature: 23.62,
      description: "Clear sky",
      fetched_at: 2.hours.ago
    )
  }

  describe '#get_weather' do
    context 'when cached weather data is available and valid' do
      before do
        cached_weather.update(fetched_at: 10.minutes.ago)
      end

      it 'returns cached weather data' do
        service = WeatherCacheService.new({city: city, state: state})
        weather = service.get_weather

        expect(weather.city).to eq(city)
        expect(weather.temperature).to be_within(1.0).of(23.62)
        expect(weather).to eq(cached_weather)
      end
    end

    context 'when cached weather data is outdated or unavailable' do
      it 'fetches new weather data and updates the cache', vcr: { cassette_name: 'new_weather_data' } do
        allow_any_instance_of(GeocodingService).to receive(:fetch_coordinates)
          .and_return({ lat: latitude, lon: longitude }) # NY coordinates

        VCR.use_cassette('openweather_api_success') do
          service = WeatherCacheService.new({city: city, state: state})
          weather = service.get_weather

          expect(weather.temperature).to be_a(Numeric)
          expect(weather.description).to be_a(String)
          expect(weather.fetched_at).to be_within(5.seconds).of(Time.current)
        end
      end
    end

    context 'when the geocoding service fails', vcr: { cassette_name: 'geocoding_api_failure' } do
      it 'raises an error' do
        VCR.use_cassette('geocoding_api_error') do
          stub_request(:get, /api.openweathermap.org\/geo\/1.0\/direct/)
            .to_return(status: 500, body: '')

          service = WeatherCacheService.new({city: city, state: state})

          expect { service.get_weather }.to raise_error('Failed to fetch coordinates')
        end
      end
    end

    context 'when the weather API request fails' do
      it 'raises an error' do
        allow_any_instance_of(GeocodingService).to receive(:fetch_coordinates)
          .and_return({ lat: latitude, lon: longitude }) # NY coordinates

        stub_request(:get, /api.openweathermap.org/)
          .to_return(status: 500, body: '')

        service = WeatherCacheService.new({city: city, state: state})

        expect { service.get_weather }.to raise_error('Failed to fetch weather data')
      end
    end

    context 'when latitude and longitude are provided' do
      it 'bypasses geocoding and fetches weather data', vcr: { cassette_name: 'weather_by_coordinates' } do
        VCR.use_cassette('openweather_api_success_lat_lon') do
          service = WeatherCacheService.new({latitude: latitude, longitude: longitude})
          weather = service.get_weather

          expect(weather.temperature).to be_a(Numeric)
          expect(weather.description).to be_a(String)
          expect(weather.fetched_at).to be_within(5.seconds).of(Time.current)
        end
      end
    end
  end
end
