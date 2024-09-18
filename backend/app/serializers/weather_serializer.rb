class WeatherSerializer < ActiveModel::Serializer
  attributes :city, :state, :temperature, :description, :fetched_at
end
