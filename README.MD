
# Acima Weather App Challenge

This is a full-stack weather application that fetches weather data based on the user's location using **Ruby on Rails** for the backend and **React** for the frontend. The weather data is retrieved from the OpenWeatherMap API and cached in a PostgreSQL database. This project uses Docker and supports a full development and test environment.

## Table of Contents
- [Setup](#setup)
- [Usage](#usage)
- [Testing](#testing)
- [Services](#services)
- [API](#api)
- [Environment Variables](#environment-variables)

## Setup

1. **Clone the repository**:

    ```bash
    git clone git@github.com:dan1d/acima-challenge.git
    cd acima-challenge
    ```

2. **Create an `.env` file** by copying the provided `.env.example`:

    ```bash
    cp .env.example .env
    ```

3. **Add your OpenWeatherMap API key** to the `.env` file:

    ```dotenv
    OPENWEATHERMAP_API_KEY=your_openweathermap_api_key_here
    ```

4. **Build and run the project** using the provided `Makefile`:

    ```bash
    make setup
    ```

   This will:
   - Build and start the Docker containers for the app and PostgreSQL.
   - Create and migrate the database for development.

5. **Access the application**:
   - Backend (Rails API): `http://localhost:3001`
   - Frontend (React): `http://localhost:3000`

## Usage

- The application automatically fetches the user's current location and displays the weather data.
- You can search for weather by entering a city and state as well.

## Testing

This project uses **RSpec** for testing along with **VCR** for mocking API requests to OpenWeatherMap.

1. **Running tests**:
    - To run the tests, use the following command:

      ```bash
      make test
      ```

    - This will spin up the test environment inside Docker, create the test database, and run the test suite using RSpec.

2. **Using VCR**:
    - VCR is used to record the API requests to OpenWeatherMap to avoid hitting the API repeatedly during testing. The cassettes are stored in the `spec/cassettes` directory.

## Services

### Backend

- **Ruby on Rails API**: The backend is built with Rails and serves weather data fetched from OpenWeatherMap. It uses PostgreSQL for caching the weather data to reduce the number of API requests.
- **Geocoding Service**: Converts city and state to coordinates (latitude/longitude) using the OpenWeatherMap API.
- **Reverse Geocoding Service**: Converts coordinates back to city and state, when only latitude and longitude are provided.

### Frontend

- **React App**: The frontend is built with React and uses **Axios** to communicate with the backend. The UI is styled using **Ant Design (Antd)**.

## API

- The backend API has one endpoint:
    - `GET /weather`: Fetches the weather data by either:
      - Providing a city and state (`city` and `state` parameters)
      - Providing latitude and longitude (`latitude` and `longitude` parameters)

    Example request:

    ```bash
    curl http://localhost:3001/weather?city=New%20York&state=NY
    ```

## Environment Variables

The following environment variables need to be configured:

| Variable                | Description                                           |
|-------------------------|-------------------------------------------------------|
| `OPENWEATHERMAP_API_KEY` | Your OpenWeatherMap API key                           |
| `DATABASE_URL`           | The PostgreSQL connection URL                         |

Make sure you have the correct `.env` setup with your own `OPENWEATHERMAP_API_KEY` before running the project.
