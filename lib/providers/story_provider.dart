import 'dart:convert';
import 'package:daff_app/helpers/.daff_api.dart';
import 'package:daff_app/models/story.dart';
import 'package:daff_app/models/user.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class StoryProvider extends ChangeNotifier {
  User user;
  StoryProvider(this.user);

  bool isLoading = false;

  Story story;

  // void initialize(int id){
  //   fetchStoryData(id);

  // }

  Future<Story> fetchStoryData(int id) async {
    print('fetching story data...');
    isLoading = true;
    // notifyListeners();
    http.Response response = await http.get(
      daffServerUrl + '/stories/$id.json',
      headers: <String, String>{
        'Content-type': 'application/json',
        'authorization': basicAuth,
      },
    );
    Map<String, dynamic> storyData = json.decode(response.body);
    Story _story = parseStoryFromJson(storyData);
    reportReading(id);
    isLoading = false;
    notifyListeners();
    story = _story;
    return _story;
  }

  void reportContent(int storyId) {
    http.post(daffServerUrl + '/offensive_content_reports.json',
        headers: <String, String>{
          'authorization': basicAuth,
        },
        body: {
          'mobile_randi': user.deviceId,
          'params[user_email]': user.connected ? user.email : '',
          'params[user_token]': user.connected ? user.authenticationToken : '',
          'offensive_content_report[story_id]': storyId.toString(),
          // 'offensive_content_report[email]' : 'dor@dorkalev.com', //TODO: ask user for email
          // 'offensive_content_report[content]' : '',
        }).then((http.Response response) {
      Map<String, dynamic> data = json.decode(response.body);
      print('reporting offensive content $storyId on ${user.deviceId}');
      print(data);
    });
  }

  void reportReading(int storyId) {
    http.post(daffServerUrl + '/stories/$storyId/reading',
        headers: <String, String>{
          'authorization': basicAuth,
        },
        body: {
          'mobile_randi': user.deviceId,
          'params[user_email]': user.connected ? user.email : '',
          'params[user_token]': user.connected ? user.authenticationToken : '',
          'status':
              'started', // TODO: report 'done' reading status & calculate reading time when done if it's more than story estimated reading time
        }).then((http.Response response) {
      Map<String, dynamic> data = json.decode(response.body);
      print('reporting started reading for story $storyId on ${user.deviceId}');
      print(data);
    });
  }

  void reportAudioListening(Story story) {
    http.post(daffServerUrl + '/story_audio_playing/${story.audioID}',
        headers: <String, String>{
          'authorization': basicAuth,
        },
        body: {
          'mobile_randi': user.deviceId,
          'params[user_email]': user.connected ? user.email : '',
          'params[user_token]': user.connected ? user.authenticationToken : '',
        }).then((http.Response response) {
      Map<String, dynamic> data = json.decode(response.body);
      print(
          'reporting started listening to audio for story ${story.id} on ${user.deviceId}');
      print(data);
    });
  }

  void cheer(Story story) {
    bool cheered = story.cheer(user.author);
    if (!cheered) return;
    http.put(
        daffServerUrl +
            '/stories/${story.id}/cheer.json?user_email=${user.email}&user_token=${user.authenticationToken}',
        headers: <String, String>{
          'authorization': basicAuth,
        }).then((http.Response response) {
      // Map<String, dynamic> data = json.decode(response.body);
      print(
          'cheering ${story.id} on ${user.deviceId}'); //TODO: handle exceptions
      story.cheersCount++;
      notifyListeners();
    });
  }

  void addComment(String content, int storyId) {
    isLoading = true;
    notifyListeners();
    if (content == null) return;
    http.post(
        '$daffServerUrl/stories/$storyId/comments.json?user_email=${user.email}&user_token=${user.authenticationToken}',
        headers: <String, String>{
          'authorization': basicAuth,
        },
        body: {
          'comment[story_id]': storyId.toString(),
          'comment[content]': content,
        }).then((http.Response response) {
      print(
          'adding a comment to $storyId on ${user.deviceId}: \"$content\" -- statusCode: ${response.statusCode}');
      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        if (data['success'] == true && data['errors'] == null) {
          //TODO: handle exceptions
          fetchStoryData(storyId);
        }
      }
    });
  }
}
