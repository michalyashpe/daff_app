import 'author.dart';

class Comment{
  Author author;
  String content;
  DateTime createdAt;
  String timeSinceCreated; //TODO

  Comment({this.author, this.content, this.createdAt, this.timeSinceCreated});

  String get createdAtFormatted {
    return "${createdAt.day}/${createdAt.month}/${createdAt.year.toString().substring(2)}  ${createdAt.hour}:${createdAt.minute}";
  }
}
Comment parseCommentFromJson(Map<String, dynamic> comment){
  return Comment(
    author: comment['user'] != null ? parseAuthorFromJson(comment['user']) : null,
    content: comment['content'],
    createdAt: DateTime.parse(comment['created_at']),

  );
}