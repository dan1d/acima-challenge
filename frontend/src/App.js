import React, { useEffect, useState } from 'react';
import { Input, Button, Card, Spin, message } from 'antd';
import weatherService from './services/weatherService';

const { Search } = Input;

function App() {
  const [weather, setWeather] = useState(null);
  const [loading, setLoading] = useState(false);

  useEffect(() => {
    if (navigator.geolocation) {
      navigator.geolocation.getCurrentPosition(async (position) => {
        const { latitude, longitude } = position.coords;
        fetchWeatherByCoordinates(latitude, longitude);
      }, () => {
        message.error('Geolocation is not supported or permission denied.');
      });
    } else {
      message.error('Geolocation is not supported by this browser.');
    }
  }, []);

  // Fetch weather using coordinates
  const fetchWeatherByCoordinates = async (lat, lon) => {
    try {
      setLoading(true);
      const data = await weatherService.getWeatherByCoordinates(lat, lon);
      setWeather(data);
      message.success('Weather data fetched for your current location!');
    } catch (error) {
      message.error('Failed to fetch weather for your location.');
    } finally {
      setLoading(false);
    }
  };

  // Fetch weather using City/State
  const handleSearch = async (value) => {
    const [city, state] = value.split(',');

    if (!city || !state) {
      message.error('Please enter City and State in the format: City,State');
      return;
    }

    try {
      setLoading(true);
      const data = await weatherService.getWeatherByCityState(city.trim(), state.trim());
      setWeather(data);
      message.success('Weather data fetched successfully!');
    } catch (error) {
      message.error('Error fetching weather data.');
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="app">
      <Card title="Weather Search" style={{ width: 400, margin: 'auto', marginTop: 50 }}>
        <Search
          placeholder="Enter City,State (e.g., New York,NY)"
          enterButton="Search"
          size="large"
          onSearch={handleSearch}
        />

        {loading ? (
          <Spin style={{ marginTop: 20 }} />
        ) : weather ? (
          <Card style={{ marginTop: 20 }}>
            <p><strong>City:</strong> {weather.city}</p>
            <p><strong>Temperature:</strong> {weather.temperature}°C</p>
            <p><strong>Description:</strong> {weather.description}</p>
          </Card>
        ) : null}
      </Card>
    </div>
  );
}

export default App;
