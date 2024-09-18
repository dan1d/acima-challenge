class WeatherCacheService
  def initialize(params)
    @city = params[:city]
    @state = params[:state]
    @latitude = params[:latitude]
    @longitude = params[:longitude]
  end

  def get_weather
    fetch_location if @latitude && @longitude

    weather = find_cached_weather

    if weather && !weather.stale?
      return weather
    end

    fetch_and_cache_weather
  end

  private

  def find_cached_weather
    Weather.find_by(city: @city, state: @state) if @city && @state
  end

  def fetch_and_cache_weather
    weather_data = OpenWeatherService.new(
      @city,
      @state,
      latitute,
      longitude
    ).get_weather

    weather = Weather.find_or_initialize_by(city: @city, state: @state)
    weather.update(weather_data)

    weather
  end

  def coordinates
    @coordinates ||= GeocodingService.new(@city, @state).fetch_coordinates
  end

  def latitute
    @latitude || coordinates[:lat]
  end

  def longitude
    @longitude || coordinates[:lon]
  end

  def fetch_location
    location = ReverseGeocodingService.new(@latitude, @longitude).fetch_location
    @city = location[:city]
    @state = location[:state]
  end
end
