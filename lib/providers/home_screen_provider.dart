import 'dart:convert';
import 'package:daff_app/helpers/daff_api.dart';
import 'package:daff_app/models/story.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomeModel extends ChangeNotifier{

  // List<Story> mostReadStoriesThisWeek = List<Story>();
  // List<Story> mostCheeredStoriesThisMonth = List<Story>();
  // List<Story> thisWeekStories = List<Story>();
  // int thisWeekAuthorsCount;
  // List<Story> editorVotes = List<Story>();
  // List<Story> recentStories = List<Story>();

  List<Story> hits = List<Story>();
  bool isLoading = false;

  void initialize(){
    fetchHomeData();
  }

  void fetchHomeData(){
    isLoading = true;
    notifyListeners();
    print('fetching home data...');
    http.get(
      daffServerUrl + '/stories.json?hits=true',
      headers: <String, String>{
        'Content-type': 'application/json',
        'authorization': basicAuth,
      },
    ).then((http.Response response){
      Map<String, dynamic> homeData = json.decode(response.body);

      homeData['stories'].forEach((dynamic story){
        Story s = parseStoryFromJson(story);
        hits.add(s);
      });
      isLoading = false;
      notifyListeners();
     
     
      // homeData['editor_votes'].forEach((dynamic story){
      //   Story s = parseStoryFromJson(story);
      //   editorVotes.add(s);
      //   notifyListeners();

      // });

      // thisWeekAuthorsCount = homeData['this_week_authors_count'];
      // notifyListeners();

      // homeData['stories'].forEach((dynamic story){
      //   Story s = parseStoryFromJson(story);
      //   recentStories.add(s);
      //   notifyListeners();

      // });



    });
  }








}
