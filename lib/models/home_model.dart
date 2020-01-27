import 'dart:convert';
import 'package:daff_app/helpers/daff_api.dart';
import 'package:daff_app/models/story.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomeModel extends ChangeNotifier{

  List<Story> mostReadStoriesThisWeek = List<Story>();
  List<Story> mostCheeredStoriesThisMonth = List<Story>();
  List<Story> thisWeekStories = List<Story>();
  int thisWeekAuthorsCount;

  void initialize(){
    fetchHomeData();
  }

  void fetchHomeData(){
    print('fetching home data...');
    http.get(
      daffServerUrl + '/homepage.json',
      headers: <String, String>{
        'Content-type': 'application/json',
        'authorization': basicAuth,
      },
    ).then((http.Response response){
      Map<String, dynamic> homeData = json.decode(response.body);

      homeData['last_month_most_cheered'].forEach((dynamic story){
        Story s = parseStoryFromJson(story);
        mostCheeredStoriesThisMonth.add(s);
      });
      notifyListeners();

      homeData['last_week_hits'].forEach((dynamic story){
        Story s = parseStoryFromJson(story);
        mostReadStoriesThisWeek.add(s);
      });
      notifyListeners();

      homeData['stories'].forEach((dynamic story){
        Story s = parseStoryFromJson(story);
        thisWeekStories.add(s);
      });

      thisWeekAuthorsCount = homeData['this_week_authors_count'];
      notifyListeners();

      print('mostCheeredStoriesThisMonth: ' + mostCheeredStoriesThisMonth.length.toString());
      print('mostReadStoriesThisWeek: ' + mostReadStoriesThisWeek.length.toString());
      print('thisWeekStories: ' + thisWeekStories.length.toString());


    });
  }




  Story parseStoryFromJson(Map<String, dynamic> story){
    List<String> sTags = List<String>();
    story['tags'].forEach((tag) => sTags.add(tag.toString()));
    return Story(
      id: story['id'],
      slug: story['slug'],
      tags: sTags,
      editorPick: story['editor_vote'] == 2,
      imageUrl: story['image'],
      date: DateTime.parse(story['publication_date']),
      title: story['header'],
      formattedDate: story['nice_publication_date'],
      readCount: story['reads'],
      readingDuration: story['min_read'],
      author: parseAuthorfromJson(story['user'])
    );
  }

  Author parseAuthorfromJson(Map<String, dynamic> user){
    return Author(
      id: user['id'],
      name: user['name'],
      imageUrl: user['avatar']
    );
  }



}