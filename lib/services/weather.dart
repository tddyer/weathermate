import 'package:weathermate/services/location.dart';
import 'package:weathermate/services/networking.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

String apiKey = DotEnv().env['WEATHER_API'].toString();
const openWeatherMapURLStart = 'https://api.openweathermap.org/data/2.5/weather';

class WeatherModel {

  // TODO: consider having background image change based upon weather conditions

  // obtains weather for user specified city
  Future<dynamic> getCityWeather(String city) async {
    Networking network = Networking(url: '$openWeatherMapURLStart?q=$city&appid=$apiKey&units=imperial');
    var weatherData = await network.getData();
    return weatherData;
  }

  Future<dynamic> getLocationWeather() async {
    // get device location
    Location location = Location();
    await location.getCurrentLocation();

    // tap into OWM api + retrieve weather data
    Networking weatherNetwork = Networking(
      url: '$openWeatherMapURLStart?lat=${location.latitude}&lon=${location.longitude}'
      '&appid=$apiKey&units=imperial');

    var weatherData = await weatherNetwork.getData();

    return weatherData;
  }

  String getWeatherIcon(int condition) {
    if (condition < 300) {
      // background = rainBackground
      return '🌩';
    } else if (condition < 400) {
      // background = rainBackground
      return '🌧';
    } else if (condition < 600) {
      // background = rainBackground
      return '☔️';
    } else if (condition < 700) {
      // background = snowBackground
      return '☃️';
    } else if (condition < 800) {
      // background = foggyBackground
      return '🌫';
    } else if (condition == 800) {
      // background = sunnyBackground
      return '☀️';
    } else if (condition <= 804) {
      // background = cloudyBackground
      return '☁️';
    } else {
      return '🤷‍';
    }
  }

  String getMessage(int temp) {
    if (temp > 85) {
      return 'It\'s 🍦 time';
    } else if (temp > 65) {
      return 'Time for shorts and 👕';
    } else if (temp < 35) {
      return 'You\'ll need 🧣 and 🧤';
    } else {
      return 'Bring a 🧥';
    }
  }
}
