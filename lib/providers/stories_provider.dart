//  https://daff.dev/stories.json?tag=%D7%9B%D7%90%D7%91

import 'dart:convert';
import 'package:daff_app/helpers/.daff_api.dart';
import 'package:daff_app/models/story.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class StoriesModel extends ChangeNotifier{

  List<Story> stories;
  int storiesCount ;
  int pagesCount ;
  int storiesPerPage = 30;
  int currentPage;
  String urlQuery;


  bool isLoading = false;
  



  Future<List<Story>> fetchStoriesData(int page, String query) async {
    print(page);
    print('fetchStoriesData.... from  $daffServerUrl/stories.json?$query&page=$page');
    isLoading = true;
    var response = await http.get(
      '$daffServerUrl/stories.json?$query&page=$page',
      headers: <String, String>{
        'Content-type': 'application/json',
        'authorization': basicAuth,
      },
    );

    Map<String, dynamic> storiesData = json.decode(response.body);
    storiesCount = storiesData['total_count'];
    pagesCount = storiesData['total_pages'];
    // storiesPerPage = storiesData['per_page'];
    // currentPage = storiesData['page'];
    stories = List<Story>();
    storiesData['stories'].forEach((storyData) {
      Story story = parseStoryFromJson(storyData);
      stories.add(story);
    });
    isLoading = false;
    notifyListeners();
    print('storiesCount $storiesCount');
    print('pagesCount $pagesCount');
    print('storiesPerPage $storiesPerPage');
    print('currentPage storiesCount ${stories.length}');
    
    return stories;

  }
}