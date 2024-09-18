# if this object were a bit more complex
# it would be a good idea to use a deserializer
# to handle the data transformation
# either way, i'm going to use a deserializer
class OpenWeatherDeserializer
  def initialize(data, city, state)
    @data = data
    @city = city
    @state = state
  end

  def to_weather
    {
      city: @city,
      state: @state,
      temperature: @data['main']['temp'],
      description: @data['weather'][0]['description'],
      fetched_at: Time.current
    }
  end
end
