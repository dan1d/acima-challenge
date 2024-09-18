import axios from 'axios';

const API_URL = process.env.REACT_APP_API_URL;

const weatherService = {
  getWeatherByCoordinates: async (latitude, longitude) => {
    try {
      const response = await axios.get(`${API_URL}/weather`, {
        params: { latitude, longitude }
      });
      return response.data;
    } catch (error) {
      console.error('Error fetching weather by coordinates:', error);
      throw error;
    }
  },
  getWeatherByCityState: async (city, state) => {
    try {
      const response = await axios.get(`${API_URL}/weather`, {
        params: { city, state }
      });
      return response.data;
    } catch (error) {
      console.error('Error fetching weather by city/state:', error);
      throw error;
    }
  }
};

export default weatherService;
