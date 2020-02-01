//  https://daff.dev/stories.json?tag=%D7%9B%D7%90%D7%91

import 'dart:convert';
import 'package:daff_app/helpers/daff_api.dart';
import 'package:daff_app/models/story.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class StoriesModel extends ChangeNotifier{
  List<Story> stories;
  int storiesCount;
  int pagesCount;
  int storiesPerPage;
  int currentPage;
  String _tag;
  bool isLoading = false;
  
  String get getTag {
    return _tag;
  }
  void initialize({String tag = ''}){
    stories = List<Story>();
    if (tag != null) _tag = tag;
    fetchStoriesData();
  }

  void fetchStoriesData(){
    String tagQuery = (_tag != null && _tag != '') ? 'tag=$_tag' : '';
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
      Map<String, dynamic> storiesData = json.decode(response.body);
      storiesCount = storiesData['total_count'];
      pagesCount = storiesData['total_pages'];
      storiesPerPage = storiesData['per_page'];
      currentPage = storiesData['page'];
      storiesData['stories'].forEach((storyData) {
        Story story = parseStoryFromJson(storyData);
        stories.add(story);
      });
      isLoading = false;
      notifyListeners();
    });
  }
}