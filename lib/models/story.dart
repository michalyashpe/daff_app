

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
  int firgunCount = 0;
  String imageUrl;
  List<Author> mefargenim = List<Author>();
  bool editorPick = false;
  List<String> tags = List<String>();
  List<Story> moreStories = List<Story>();

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
    this.firgunCount,
    this.mefargenim,
    this.editorPick,
    this.imageUrl,
    this.tags,
    this.moreStories,
  });


  String get readingDurationString {
     return (readingDuration == 1) ? 'דקת קריאה' : '$readingDuration דקות קריאה';
  }

  String get dateFormatted {
    List<String> hebrewMonthNames = ['ינואר', 'פברואר', 'מרץ','אפריל','מאי','יוני','יולי','אוגוסט','ספטמבר','אוקטובר','נובמבר','דצמבר'];
    return date.year == DateTime.now().year ? 
       '${date.day} ל${hebrewMonthNames[date.month]}'
       :
       '${date.day} ל${hebrewMonthNames[date.month-1]} ${date.year}';
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
  int id;
  String imageUrl;
  List<Story> stories = List<Story>();

  Author({
    this.name,
    this.id,
    this.stories,
    this.imageUrl
  });
}