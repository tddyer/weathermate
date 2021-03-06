import 'package:http/http.dart' as http;
import 'dart:convert';

// takes a url for retrieving api data
class Networking {

  Networking({this.url});

  final String url;

  Future getData() async {
    http.Response response = await http.get(url);
    
    if (response.statusCode == 200) {
      String data = response.body;
      return jsonDecode(data);
    } else {
      print('Unable to retrieve data: ${response.statusCode}');
    }
  }
}