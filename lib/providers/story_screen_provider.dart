
import 'dart:convert';
import 'package:daff_app/helpers/.daff_api.dart';
import 'package:daff_app/models/story.dart';
import 'package:daff_app/models/user.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class StoryModel extends ChangeNotifier{
  User user;
  StoryModel(this.user);
  Story story;

  bool isLoading = false;

  void initialize(int id){
    fetchStoryData(id);

  }

  void fetchStoryData(int id){
    print('fetching story data...');
    isLoading = true;
    notifyListeners();
    http.get(
      daffServerUrl + '/stories/$id.json',
      headers: <String, String>{
        'Content-type': 'application/json',
        'authorization': basicAuth,
      },
    ).then((http.Response response){
      Map<String, dynamic> storyData = json.decode(response.body);
      story = parseStoryFromJson(storyData);
      reportReading();
      isLoading = false;
      notifyListeners();

    });
  }

  void reportContent(){
    http.post(
      daffServerUrl + '/offensive_content_reports.json',
      headers: <String, String>{
        'authorization': basicAuth,
      },
      body: {
        'mobile_randi': user.deviceId,
        'offensive_content_report[story_id]' : story.id.toString(),
        // 'offensive_content_report[email]' : 'dor@dorkalev.com', //TODO: ask user for email
        // 'offensive_content_report[content]' : '',
      }).then((http.Response response) {
        Map<String, dynamic> data = json.decode(response.body);
        print('reporting offensive content ${story.id} on ${user.deviceId}');
        print(data);
      });
  }

  void reportReading(){ 
    http.post(
      daffServerUrl + '/stories/${story.id}/reading',
      headers: <String, String>{
        'authorization': basicAuth,
      },
      body: {
        'mobile_randi': user.deviceId,
        'status': 'started', // TODO: report 'done' reading status & calculate reading time when done if it's more than story estimated reading time
      }).then((http.Response response) {
        Map<String, dynamic> data = json.decode(response.body);
        print('reporting started reading for story ${story.id} on ${user.deviceId}');
        print(data);
    });
  }


  void reportAudioListening(){
    print(story.id);
    http.post(
      daffServerUrl + '/story_audio_playing/${story.audioID}',
      headers: <String, String>{
        'authorization': basicAuth,
      },
      body: {
        'mobile_randi': user.deviceId,
      }).then((http.Response response) {
        Map<String, dynamic> data = json.decode(response.body);
        print('reporting started listening to audio for story ${story.id} on ${user.deviceId}');
        print(data);
    });
  }
}