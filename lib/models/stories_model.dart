import 'package:flutter/material.dart';

class StoriesModel extends ChangeNotifier{
  List<Story> allStories = List<Story>();

  void buildDummyData(){
    print('building dummy data...');

    Author ozFrankel = Author(
      authorId: 408,
      name: 'עוז פרנקל',
    );
    Story story = Story(
      author: ozFrankel,
      name: 'העניין עם געגוע',
      authorPick: true,
      date: DateTime(2020, 01, 22),
      readingDuration: 1,
    );
    allStories.add(story);
    print('stories count: ' + allStories.length.toString());
    notifyListeners();
  }




}

class Story {
  String name;
  Author author;
  DateTime date;
  String contents;
  int readingDuration = 1;
  int readCount = 0;
  int firgunCount = 0;
  String imageUrl;
  List<Author> mefargenim = List<Author>();
  bool authorPick = false;

  Story({
    this.name,
    this.author,
    this.date,
    this.readingDuration,
    this.contents,
    this.readCount,
    this.firgunCount,
    this.mefargenim,
    this.authorPick,
    this.imageUrl
  });
}

class Author {
  String name;
  int authorId;
  List<Story> stories = List<Story>();

  Author({
    this.name,
    this.authorId,
    this.stories
  });
}