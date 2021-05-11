import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;



//Get Requet
Future<Map<String, dynamic>> getMoviesList(String page) async {
  String baseUrl = 'https://api.themoviedb.org';

  var params = {'api_key': '34c902e6393dc8d970be5340928602a7', 'language': 'en-US', 'page' : page};

  Uri uri = Uri.parse("$baseUrl/3/movie/now_playing");

  final newUri = uri.replace(queryParameters: params);
  print(newUri);

  http.Response res = await http.get(newUri);
  return jsonDecode(res.body);
}