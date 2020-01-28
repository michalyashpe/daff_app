//  https://daff.dev/stories.json?tag=%D7%9B%D7%90%D7%91

import 'dart:convert';
import 'package:daff_app/helpers/daff_api.dart';
import 'package:daff_app/models/story.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class StoriesModel extends ChangeNotifier{
  List<Story> stories;
  String _tag;
  bool isLoading = false;
  
  void initialize({String tag = ''}){
    stories = List<Story>();
    if (tag != null) _tag = tag;
    fetchStoriesData();
  }

  void fetchStoriesData(){
    String tagQuery = _tag != null || _tag != '' ? 'tag=$_tag' : '';
    print('fetching all stories...');
    isLoading = true;
    notifyListeners();
    http.get(
      daffServerUrl + '/stories.json?$tagQuery',
      headers: <String, String>{
        'Content-type': 'application/json',
        'authorization': basicAuth,
      },
    ).then((http.Response response){
      List<dynamic> storiesData = json.decode(response.body);
      storiesData.forEach((storyData) {
        Story story = parseStoryFromJson(storyData);
        stories.add(story);
      });
      isLoading = false;
      notifyListeners();
    });
  }
}