import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:myapp/database/database.dart';
import 'package:myapp/models/post_model.dart';

class APIServices {
  mypost() async {
    Hive.box<PostModel>(DatabaseHelper.apidata).clear();
    try {
      String url = "https://jsonplaceholder.typicode.com/posts";
      final response = await http.get(Uri.parse(url));

      List<PostModel> _response = [];
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        data.forEach((e) {
          _response.add(PostModel.fromJson(e));
          Hive.box<PostModel>(DatabaseHelper.apidata)
              .add(PostModel.fromJson(e));
        });
        print(_response);
        return _response;
      } else {
        print(response.statusCode.toString());
      }
    } catch (e) {
      print(e);
    }
  }
}
