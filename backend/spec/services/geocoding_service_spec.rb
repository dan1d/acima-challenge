require 'rails_helper'

RSpec.describe GeocodingService, type: :service do
  let(:city) { 'New York' }
  let(:state) { 'NY' }

  describe '#fetch_coordinates', :vcr do
    context 'when the request is successful' do
      it 'returns the correct latitude and longitude' do
        service = GeocodingService.new(city, state)
        coordinates = service.fetch_coordinates

        expect(coordinates[:lat]).to be_within(0.1).of(40.7128) # NYapprox
        expect(coordinates[:lon]).to be_within(0.1).of(-74.0060) # NYapprox
      end
    end

    context 'when the request fails' do
      it 'raises an error' do
        stub_request(:get, /api.openweathermap.org/)
          .to_return(status: 500, body: '')

        service = GeocodingService.new(city, state)

        expect { service.fetch_coordinates }.to raise_error('Failed to fetch coordinates')
      end
    end
  end
end
