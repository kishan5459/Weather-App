# Weather App 🌦️

A Flutter project to track the weather of my hometown city, Surat.  
Displays real-time weather info, hourly forecast, and additional weather metrics in a clean, modern UI.

## Features

- Fetches real-time weather data for Surat using OpenWeatherMap API
- Displays current temperature, weather condition, humidity, wind speed, and pressure
- Hourly weather forecast with icons and temperature
- Pull-to-refresh for updated weather data
- Elegant Material Design with dark theme
- Cleanly separated widgets for code clarity and reuse

## How It Works

- On launch, fetches and displays current weather and 5-day/3-hour forecast for Surat
- Shows a weather card with temperature (Kelvin), sky condition, and icon
- Horizontal scrollable hourly forecast with time, icon, and temperature
- Additional info section: humidity, wind speed, pressure

## Project Structure

- `lib/main.dart` – App entry point
- `lib/weather_screen.dart` – Main weather UI and logic
- `lib/weather_forecast_item.dart` – Widget for hourly forecast cards
- `lib/additional_info_item.dart` – Widget for additional weather info

## Technologies Used

- [Flutter](https://flutter.dev/)
- [Dart](https://dart.dev/)
- [OpenWeatherMap API](https://openweathermap.org/api)
- [intl](https://pub.dev/packages/intl) (Date formatting)
- [http](https://pub.dev/packages/http) (API requests)

<p align="left" style="font-size:small"><i>[public version of <code>flutter_projects/weather_app</code>]</i></p>