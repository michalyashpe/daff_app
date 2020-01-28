
//  https://daff.dev/authors/1.json

import 'dart:convert';
import 'package:daff_app/helpers/daff_api.dart';
import 'package:daff_app/models/story.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class StoryModel extends ChangeNotifier{
  Story story;

  bool storyLoaded(int id) {
    return story != null && story.id == id;
  }

  void initialize(int id){
    fetchStoryData(id);

  }

  void fetchStoryData(int id){
     print('fetching story data...');
    http.get(
      daffServerUrl + '/stories/$id.json',
      headers: <String, String>{
        'Content-type': 'application/json',
        'authorization': basicAuth,
      },
    ).then((http.Response response){
      Map<String, dynamic> storyData = json.decode(response.body);
      story = parseStoryFromJson(storyData);
      notifyListeners();

    });
  }







}