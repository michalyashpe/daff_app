import 'package:daff_app/models/author.dart';
import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:daff_app/helpers/.daff_api.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class AuthorModel extends ChangeNotifier{
  Author author;

  bool isLoading = false;

  void initialize(int id){
    author = null;
    fetchAuthorData(id);

  }

  void fetchAuthorData(int id){
    print('fetching author data...');
    isLoading = true;
    notifyListeners();
    http.get(
      daffServerUrl + '/authors/$id.json',
      headers: <String, String>{
        'Content-type': 'application/json',
        'authorization': basicAuth,
      },
    ).then((http.Response response){
      Map<String, dynamic> authorData = json.decode(response.body);
      author = parseAuthorFromJson(authorData);
      // print(author.name);
      // story = parseStoryFromJson(storyData);
      isLoading = false;
      notifyListeners();

    });
  }


}