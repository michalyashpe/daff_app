//  https://daff.dev/stories.json?tag=%D7%9B%D7%90%D7%91

import 'dart:convert';
import 'package:daff_app/helpers/daff_api.dart';
import 'package:daff_app/models/story.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class StoriesModel extends ChangeNotifier{

  List<Story> stories;
  int storiesCount ;
  int pagesCount ;
  int storiesPerPage;
  String storiesUrl;

  Map<String, dynamic> storiesUrlData = {
    'tag': '',
    'editorVotes': false,
    'hits': false,
  };

  bool isLoading = false;
  
  String get getTag {
    return storiesUrlData['tag'];
  }

  bool get editorVotes {
    return storiesUrlData['editorVotes'];
  }
  void initialize({String tag = '', bool editorVotes = false, bool hits = false}){
    storiesCount = null;
    stories = List<Story>();
    storiesUrlData['tag'] = tag;
    storiesUrlData['editorVotes'] = editorVotes;
    storiesUrlData['hits'] = hits;
    setStoriesUrl();
    fetchStoriesData(1);

  }

  // Future<List<Story>> fetchNextPage(int pageIndex){
  //   // currentPage ++;
  //   return fetchStoriesData(pageIndex);
  // }

  void setStoriesUrl(){
    String editorVotesQuery = storiesUrlData['editorVotes']  ? 'editor_votes=true' : '';
    String tagQuery = (storiesUrlData['tag'] != null && storiesUrlData['tag'] != '') ? 'tag=$storiesUrlData["tag"]' : '';
    String hitsQuery = storiesUrlData['hits']  ? 'hits=true' : '';
    storiesUrl = '$daffServerUrl/stories.json?$tagQuery&$editorVotesQuery$hitsQuery';

    print('fetching all stories...');
    print('     from $storiesUrl');
  }
  Future<List<Story>> fetchStoriesData(int page) async {
    print('fetchStoriesData.... from page $page');
    stories = List<Story>();
    isLoading = true;
    var response = await http.get(
      '$storiesUrl&page=$page',
      headers: <String, String>{
        'Content-type': 'application/json',
        'authorization': basicAuth,
      },
    );

    Map<String, dynamic> storiesData = json.decode(response.body);
    storiesCount = storiesData['total_count'];
    pagesCount = storiesData['total_pages'];
    storiesPerPage = storiesData['per_page'];
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