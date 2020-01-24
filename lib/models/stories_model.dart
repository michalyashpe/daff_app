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
    Story story1 = Story(
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
      mefargenim: [dorKalev, shaniGold],

    );



    Story story2 = Story(
      author: dorKalev,
      title: 'פלוטוניום', 
      authorPick: true,
      date: DateTime(2019, 12, 30),
      readingDuration: 2,
      readCount: 70,
      imageUrl: 'https://images.unsplash.com/photo-1544427182-ecaee9a40564?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1000&q=80',
      tags: ['מדע בדיוני', 'זורן', 'כסף', 'זוגיות','נישואים','סיפורת'],
      contents: """
        <div class="content_without_header">
          <p>המכרה נטוש. מצאנו פה שתי מכונות כרייה אוטונומיות וארבעה קרונות משא. אני לא חושב שמישהו מודע למקום הזה. אם השלטון המרכזי היה יודע, היה משתלט עליו בטוח, מפעיל אותו או סוגר אותו אבל המקום פשוט נטוש כמו סוד שנשכח.</p><p>כשנכנסתי קודם, הרגשתי כאילו מישהו היה פה רק לפני רגע, יצא לבדוק משהו ומעולם לא חזר. כמו בסרטים הישנים על חטיפות ממפתן הדלת. שם לחם במצנם, דפיקה בדלת וזהו. הצנים קופץ כשהבנאדם כבר לא שם. מישהו לקח אותו. החתול מחפש אותו. רוח שנכנסת מהחלון. אחרי כמה ימים כבר גשם נכנס מהחלון ויש שכבה קטנה של אבק ובוץ. הואזה נופלת. עד שהמשטרה מגיעה החתול כבר ברח ותיבת הדואר מפוצצת.</p><p>הגענו לפה במקרה, בטעות. יצאנו לטראק קטן בהרים של זורן. החשיך וחיפשנו מחסה. לא רציתי להזמין את הרחפת לקחת אותנו וגם לא יכלתי. כיבינו אותה לפני הנסיעה כדי שלא נצא שמנים ועצלנים. רציתי שנסיים את הטראק בכוחותינו. היתה לנו קליטה, יכלתי להזמין מונית אוטונומית אבל המחיר מבאס לאללה אז כל עוד לא מוכרחים... חיפשנו מחסה והגענו איכשהו למערה הזו.</p><p>ואז המקום הזה. כריית ומסחר בפלוטונוים באופן פרטי היא עבירה מטורפת על החוק. מאידך, אפילו כמות קטנה יכולה להפוך אותך לעשיר יותר מחלומותייך הוורודים ביותר. אמרו לי שדווקא להבריח פלוטוניום לא כל כך קשה היום. כל רחפת סוג זין יכולה לצאת מהאטמוספירה של זורן. אחר כך צריך להיות בקשר עם סוחרי פלוטוניום שיכולים בקלות לגמור אותך... אבל דיה לצרה בשעתה.</p><p>והנה אנחנו פה. אני וזאתי. זאתי שפגשתי בטינדר. לא חשבתי שיכולים לצאת משם קשרים משמעותיים אבל יצא לא רע. לא רע בכלל. והיא - היא מבינה היטב איפה אנחנו. אני לא יכול לבלף אותה. אפילו אם אצליח לגרד כמה גרמים של פלוטוניום היא תדע. אם אני נכנס להרפתקאה המטורפת הזו - זה תכלס אומר שהיא ואני בבונד לכל החיים. פאקינג סוגשל חתונה. לא יודע אם אני בשל לזה בכלל או איתה. אבל פאק נו, אולי נהייה מיליארדרים. זה לא יגשר על כל הבעיות?</p><p>נהייה מאוחר. בטוח נחנה פה ללילה. דגנו כמה אמנונים בנחל למטה. יש לי מלח רפואי לפזר עליהם ושמן זית מיובא מארץ. נעשה מדורה ונעשה חיים קצת אולדסקול. אבא שלי היה מספר לי איך היה קוטף מרווה בג׳בלאות במילואים ומכין תה לצעירים ההלומים ואני מרגיש קצת ככה עכשיו. קרוקודייל דנדי דה-זורן.</p><p>הירח של זורן עולה. זאתי מוציאה את הגיטרה מהקייס ואני בוחן את קימורי האגן שלה ונושך את שפתיי. אני בר-מזל. פאקינג מקנא בעצמי. אולי כן נלך על הפלוטוניום.</p><figure class="image"><img src="https://images.unsplash.com/photo-1544427182-ecaee9a40564?ixlib=rb-1.2.1&amp;ixid=eyJhcHBfaWQiOjEyMDd9&amp;auto=format&amp;fit=crop&amp;w=1000&amp;q=80"></figure>
          <br style="clear: both">
          <div class="tags_box "><a title="תגית" href="https://daff.co.il/stories?tag=%D7%9E%D7%93%D7%A2+%D7%91%D7%93%D7%99%D7%95%D7%A0%D7%99">מדע&nbsp;בדיוני</a> <a title="תגית" href="https://daff.co.il/stories?tag=%D7%96%D7%95%D7%A8%D7%9F">זורן</a> <a title="תגית" href="https://daff.co.il/stories?tag=%D7%9B%D7%A1%D7%A3">כסף</a> <a title="תגית" href="https://daff.co.il/stories?tag=%D7%96%D7%95%D7%92%D7%99%D7%95%D7%AA">זוגיות</a> <a title="תגית" href="https://daff.co.il/stories?tag=%D7%A0%D7%99%D7%A9%D7%95%D7%90%D7%99%D7%9D">נישואים</a> <a title="תגית" href="https://daff.co.il/stories?tag=%D7%A1%D7%99%D7%A4%D7%95%D7%A8%D7%AA">סיפורת</a></div>
        </div>
        """,
      firgunCount: 23,
      mefargenim: [ozFrankel, shaniGold],
      moreStories: [story1, story1, story1]

    );
    story1.moreStories = [story2,story2,story2 ];









    allStories.add(story1);
    allStories.add(story1);
    allStories.add(story1);
    allStories.add(story1);
    allStories.add(story2);
    allStories.add(story2);
    allStories.add(story2);
    allStories.add(story2);
    
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
  List<Story> moreStories = List<Story>();

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