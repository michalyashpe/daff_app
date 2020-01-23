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
      title: 'העניין עם געגוע',
      authorPick: true,
      date: DateTime(2019, 01, 22),
      readingDuration: 1,
      imageUrl: 'https://ik.imagekit.io/g3jrzlo0a/tr:w-800,h-/rails/active_storage/blobs/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBcVFIIiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--d0bcc7a6455d7df2a120c33f3b593f38362619b3/RackMultipart20200122-7455-q0pjra.png',
      tags: ['שירה'],
    );
    allStories.add(story);
    print('stories count: ' + allStories.length.toString());
    notifyListeners();
  }




}

class Story {
  String title;
  Author author;
  DateTime date;
  String contents;
  int readingDuration = 1;
  int readCount = 0;
  int firgunCount = 0;
  String imageUrl;
  List<Author> mefargenim = List<Author>();
  bool authorPick = false;
  List<String> tags = List<String>();

  Story({
    this.title,
    this.author,
    this.date,
    this.readingDuration,
    this.contents,
    this.readCount,
    this.firgunCount,
    this.mefargenim,
    this.authorPick,
    this.imageUrl,
    this.tags,
  });

  String get readingDurationString {
     return (readingDuration == 1) ? 'דקת קריאה' : '$readingDuration דקות קריאה';
  }

  String get dateFormatted {
    List<String> hebrewMonthNames = ['ינואר', 'פברואר', 'מרץ','אפריל','מאי','יוני','יולי','אוגוסט','ספטמבר','אוקטובר','נובמבר','דצמבר'];
    return date.year == DateTime.now().year ? 
       '${date.day} ל${hebrewMonthNames[date.month]}'
       :
       '${date.day} ל${hebrewMonthNames[date.month]} ${date.year}';
  }
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