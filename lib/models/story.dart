


import 'package:daff_app/models/author.dart';

class Story {
  int id;
  String slug;
  String title;
  Author author;
  DateTime date;
  String formattedDate;
  String contents;
  int readingDuration = 1;
  int readCount = 0;
  int cheersCount = 0;
  String imageUrl;
  String audioUrl;
  bool editorPick = false;
  List<String> tags = List<String>();
  List<Story> moreStories = List<Story>();
  List<Author> cheerers = List<Author>();

  Story({
    this.id,
    this.slug,
    this.title,
    this.author,
    this.date,
    this.formattedDate,
    this.readingDuration,
    this.contents,
    this.readCount,
    this.cheersCount,
    this.editorPick,
    this.imageUrl,
    this.audioUrl = 'https://ik.imagekit.io/g3jrzlo0a//rails/active_storage/blobs/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBclFJIiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--ac2f5e5842d68d2eb78a81accc06a4bb461645fe/blob.mp4', 
    this.tags,
    this.moreStories,
    this.cheerers
  });


  String get readingDurationString {
     return (readingDuration == 1) ? 'דקת קריאה' : '$readingDuration דקות קריאה';
  }

  bool get recorded {
    return audioUrl != null && audioUrl != '';
  }

  String get dateFormatted {
    List<String> hebrewMonthNames = ['ינואר', 'פברואר', 'מרץ','אפריל','מאי','יוני','יולי','אוגוסט','ספטמבר','אוקטובר','נובמבר','דצמבר'];
    return date.year == DateTime.now().year ? 
       '${date.day} ל${hebrewMonthNames[date.month-1]}'
       :
       '${date.day} ל${hebrewMonthNames[date.month-1]} ${date.year}';
  }
  
  String get cheersSummary {
    if (cheersCount == 0) return 'היה הראשון לפרגן';
    String names = cheerers.sublist(0,cheerers.length-1).map((author) => author.name).join(', ');
    return '$cheersCount פירגונים מ$names ו${cheerers.last.name}';
  }
  String get readCountString {
    return 'הדף נקרא $readCount פעמים';
  }
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
    author: parseAuthorFromJson(story['user']),
    contents: story['content_without_header'].toString(),
    cheersCount: story['cheers_count'],
    cheerers: story['cheerers'] != null ? parseCheerersFromJson(story['cheerers']) : null
    // comments: story['comments'],
    // recommended: story['recommended'],
  );
}
