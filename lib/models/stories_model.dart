import 'package:flutter/material.dart';

class StoriesModel extends ChangeNotifier{
  List<Story> allStories = List<Story>();

  void buildDummyData(){
    print('building dummy data...');

    Author ozFrankel = Author(
      authorId: 408,
      name: 'עוז פרנקל',
      imageUrl: 'https://ik.imagekit.io/g3jrzlo0a/tr:w-200,h-200,fo-face//rails/active_storage/blobs/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBaE1HIiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--81f37516eec04e29b3f41b3b44eb06b62c76707c/userimage',
    );

    Author dorKalev = Author(
      authorId: 1,
      name: 'דור כלב',
      imageUrl: 'https://ik.imagekit.io/g3jrzlo0a/tr:w-200,h-200,fo-face//rails/active_storage/blobs/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBPZz09IiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--917fd216e51063da72c3ea1b17f817024bc894d6/dorke.jpg'
    );

    Author shaniGold = Author(
      authorId: 73,
      name: 'שני גולד',
      imageUrl: 'https://ik.imagekit.io/g3jrzlo0a/tr:w-200,h-200,fo-face//rails/active_storage/blobs/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBbkFGIiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--dfec26e7b765c28d09e7596ef1af297335d3c50e/IMG-20191117-WA0037.jpg'
    );
    Story story = Story(
      author: ozFrankel,
      title: 'הָעִנְיָן עִם גַּעְגּוּעַ',
      authorPick: true,
      date: DateTime(2019, 01, 22),
      readingDuration: 1,
      readCount: 7,
      imageUrl: 'https://ik.imagekit.io/g3jrzlo0a/tr:w-800,h-/rails/active_storage/blobs/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBcVFIIiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--d0bcc7a6455d7df2a120c33f3b593f38362619b3/RackMultipart20200122-7455-q0pjra.png',
      tags: ['שירה'],
      contents: """
        <div class="content_without_header">
        <figure class="image"><img src="https://ik.imagekit.io/g3jrzlo0a/tr:w-800,h-/rails/active_storage/blobs/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBcVFIIiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--d0bcc7a6455d7df2a120c33f3b593f38362619b3/RackMultipart20200122-7455-q0pjra.png"></figure><p>הָעִנְיָן עִם גַּעְגּוּעַ<br>שֶׁאֵין לוֹ כַּפְתּוֹר<br>הוּא יוֹשֵׁב לוֹ קָבוּעַ<br>בְּתוֹךְ מִין מִסְתּוֹר<br>נִצְמָד לְרֵיחוֹת, מְקוֹמוֹת, חֲפָצִים<br>אִי אֶפְשָׁר לְכַבּוֹת אוֹתוֹ<br>גַּם אִם רוֹצִים</p><p>הָעִנְיָן עִם גַּעְגּוּעַ<br>שֶׁאֵין לוֹ כַּפְתּוֹר<br>הוּא כְּמוֹ קַעֲקוּעַ<br>חָרוּט עַל הָעוֹר<br>מַצִּית זִכְרוֹנוֹת<br>כְּמוֹ אֵשׁ בְּקוֹצִים<br>אִי אֶפְשָׁר לְכַבּוֹת אוֹתוֹ<br>גַּם אִם רוֹצִים</p><p>הָעִנְיָן עִם גַּעְגּוּעַ<br>שֶׁאֵין לוֹ כַּפְתּוֹר<br>הוּא כְּמוֹ תַּעְתּוּעַ<br>עִם לַהַב לִדְקֹר<br>מֵגִיחַ בְּשֶׁקֶט<br>יוֹרֶה קְצָת חִצִּים<br>אִי אֶפְשָׁר לְכַבּוֹת אוֹתוֹ<br>גַּם אִם רוֹצִים</p>
        <br style="clear: both">
        </div>
        """,
      firgunCount: 20,
      mefargenim: [dorKalev, shaniGold]

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
  
  String get firgunSummary {
    String names = mefargenim.map((author) => author.name).join(', ');
    return '$firgunCount פירגונים מ$names';
  }
  String get readCountString {
    return 'הדף נקרא $readCount פעמים';
  }
}

class Author {
  String name;
  int authorId;
  String imageUrl;
  List<Story> stories = List<Story>();

  Author({
    this.name,
    this.authorId,
    this.stories,
    this.imageUrl
  });
}