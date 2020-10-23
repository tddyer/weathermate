import 'package:weathermate/services/location.dart';
import 'package:weathermate/services/networking.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:basic_utils/basic_utils.dart';
import 'package:geocoder/geocoder.dart';

String apiKey = DotEnv().env['WEATHER_API'].toString();
const openWeatherMapURLStart = 'https://api.openweathermap.org/data/2.5/onecall';

class WeatherModel {

  // obtains weather for user specified city
  Future<dynamic> getCityWeather(String city) async {
    var addresses = await Geocoder.local.findAddressesFromQuery(city);
    var firstMatch = addresses[0];
    Networking network = Networking(
      url: '$openWeatherMapURLStart?lat=${firstMatch.coordinates.latitude}&lon=${firstMatch.coordinates.longitude}'
      '&appid=$apiKey&units=imperial');
    var weatherData = await network.getData();
    weatherData['cityName'] = StringUtils.capitalize(city);
    print(weatherData['cityName']);
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
    
    // add cityName to weatherData
    var addresses = await Geocoder.local.findAddressesFromCoordinates(new Coordinates(location.latitude, location.longitude));
    List addrParts = addresses[0].addressLine.split(',');
    weatherData['cityName'] = addrParts[1];

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

}
