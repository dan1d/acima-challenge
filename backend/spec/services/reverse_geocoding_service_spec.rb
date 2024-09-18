require 'rails_helper'

RSpec.describe ReverseGeocodingService, type: :service do
  let(:latitude) { 40.7128 }
  let(:longitude) { -74.0060 }

  describe '#fetch_location' do
    context 'when the request is successful', vcr: { cassette_name: 'reverse_geocoding_success' } do
      it 'returns the city and state' do
        service = ReverseGeocodingService.new(latitude, longitude)
        location = service.fetch_location

        expect(location[:city]).to eq('New York County')
        expect(location[:state]).to eq('New York')
      end
    end

    context 'when the request fails', vcr: { cassette_name: 'reverse_geocoding_failure' } do
      it 'raises an error' do
        stub_request(:get, /api.openweathermap.org/)
          .to_return(status: 500, body: '')

        service = ReverseGeocodingService.new(latitude, longitude)

        expect { service.fetch_location }.to raise_error('Failed to fetch location')
      end
    end
  end
end
