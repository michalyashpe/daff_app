


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
  bool hasAudio;
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
    this.audioUrl,
    this.hasAudio,
    this.tags,
    this.moreStories,
    this.cheerers
  });


  String get readingDurationString {
     return (readingDuration == 1) ? 'דקת קריאה' : '$readingDuration דקות קריאה';
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
    String summary = '';
    String names = '';
    if (cheerers.length > 0 ) {
      names = cheerers.sublist(0,cheerers.length-1).map((author) => author.name).join(', ');
      summary = '$cheersCount פירגונים מ$names ו${cheerers.last.name}';
    } else 
      summary = '$cheersCount פירגונים';
    
    return summary;
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
    cheerers: story['cheerers'] != null ? parseCheerersFromJson(story['cheerers']) : null,
    audioUrl: story['published_audio'],
    hasAudio: story['has_published_audio']
    // comments: story['comments'],
    // recommended: story['recommended'],
  );
}
