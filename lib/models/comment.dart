import 'author.dart';

class Comment {
  Author author;
  String content;
  DateTime createdAt;
  String niceCreatedAt;

  Comment({this.author, this.content, this.createdAt, this.niceCreatedAt});
}

Comment parseCommentFromJson(Map<String, dynamic> comment) {
  return Comment(
      author:
          comment['user'] != null ? parseAuthorFromJson(comment['user']) : null,
      content: comment['content'],
      createdAt: DateTime.parse(comment['created_at']),
      niceCreatedAt: comment['nice_created_at']);
}
