import 'dart:convert';

import 'package:daff_app/helpers/daff_api.dart';
import 'package:daff_app/models/story.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class StoriesModel extends ChangeNotifier{
  List<Story> stories = List<Story>();
  
  void initialize(){
    fetchStoriesData();
  }

  void fetchStoriesData(){
    // stories = List<Story>();
     print('fetching all stories...');
    http.get(
      daffServerUrl + '/stories.json',
      headers: <String, String>{
        'Content-type': 'application/json',
        'authorization': basicAuth,
      },
    ).then((http.Response response){
      List<dynamic> storiesData = json.decode(response.body);
      print(storiesData);
      storiesData.forEach((storyData) {
        Story story = parseStoryFromJson(storyData);
        stories.add(story);
        print(stories.length);
      });
        notifyListeners();

    });
  }
}