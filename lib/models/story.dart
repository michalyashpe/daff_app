import 'package:daff_app/helpers/style.dart';
import 'package:daff_app/models/author.dart';
import 'package:daff_app/models/comment.dart';

class Story {
  int maxCheersByUser = 11;

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
  int audioID;
  bool editorPick = false;
  List<String> tags = List<String>();
  List<Story> moreStories = List<Story>();
  Map<Author, int> cheerers = Map<Author, int>();
  List<Story> recommended = List<Story>();
  String url;
  bool ltr;
  List<Comment> comments;

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
    this.cheerers,
    this.recommended,
    this.url,
    this.ltr,
    this.audioID,
    this.comments
  });
  bool get isSytemUpdate {
    return tags.contains('עדכון');// && tags.contains('מערכת');
  }

  bool get isNew {
    Duration difference = DateTime.now().difference(date);
    return difference.inHours <= 24;
  }
  String get readingDurationString {
     return (readingDuration == 1) ? 'דקת קריאה' : '$readingDuration דקות קריאה';
  }
  String get shareText {
    return 'כדאי לך לקרוא 👀 $productionUrl @ $fullAppSlogen';
  }

  String get productionUrl {
    String newURL = url.replaceAll('.json', '').replaceAll('//daff.dev', '//daff.co.il');
    return Uri.decodeFull("https:$newURL");

  }


  String get dateFormatted {
    List<String> hebrewMonthNames = ['ינואר', 'פברואר', 'מרץ','אפריל','מאי','יוני','יולי','אוגוסט','ספטמבר','אוקטובר','נובמבר','דצמבר'];
    return date.year == DateTime.now().year ? 
       '${date.day} ל${hebrewMonthNames[date.month-1]}'
       :
       '${date.day} ל${hebrewMonthNames[date.month-1]} ${date.year}';
  }
  
  // String get cheersSummary {
  //   if (cheersCount == 0) return 'היה הראשון לפרגן';
  //   String summary = '';
  //   String names = '';
  //   if (cheerers.length > 1 ) {
  //     names = cheerers.sublist(0,cheerers.length-1).map((author) => author.name).join(', ');
  //     summary = '$cheersCount פירגונים מ$names ו${cheerers.last.name}';
  //   } else 
  //     summary = '$cheersCount פירגונים';
    
  //   return summary;
  // }

  String get readCountString {
    return 'הדף נקרא $readCount פעמים';
  }
  String get ratingSummary {
    return 'הדף נקרא $readCount פעמים וקיבל $cheersCount פירגונים' ;
      // "$readCountString וקיבל $cheersSummary" : readCountString;
  }

  bool cheer(Author user){
    if (cheerers.keys.contains(user)) {
      if (cheerers[user] < maxCheersByUser) {
        cheerers[user] ++;
      } else return false;
    } else {
      cheerers[user] = 1;
    }
    // print('userId: ${user.id} cheerers IDs: ${cheerers.keys.map((a) => a.id)} cheers by user: ${cheerers[user]} ');
    print('cheers by user: ${cheerers[user]}');
    return true;
  }
}






Story parseStoryFromJson(Map<String, dynamic> story){
  List<String> sTags = List<String>();
  story['tags'].forEach((tag) => sTags.add(tag.toString()));


  List<Comment> comments = List<Comment>();
  if (story['comments'] != null)
    story['comments'].forEach((comment) => comments.add(parseCommentFromJson(comment)));


  List<Story> recommendedList = List<Story>();
  if (story['recommended'] != null) {
    story['recommended'].forEach((dynamic storyData) {
      Story story = parseStoryFromJson(storyData);
      recommendedList.add(story);
    });
  }
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
    hasAudio: story['has_published_audio'] != null ? story['has_published_audio'] : false,
    recommended: recommendedList,
    url: story['url'],
    ltr: story['ltr'],
    audioID: story['published_audio_id'],
    comments: comments,
  );
}


