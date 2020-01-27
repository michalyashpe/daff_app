import 'package:flutter/material.dart';

Widget buildStoryTagsWidget(List<String> tags){
  List<Widget> tagsList = List<Widget>();
  tags.forEach((String tagName) {
    Widget tag = Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(5.0)),
      color: Colors.grey[300],
    ),
    padding: EdgeInsets.symmetric(horizontal: 5.0),
    child: Text(tagName)
  );
  tagsList.add(tag);
  });
  return Wrap(
    spacing: 5.0,
    runSpacing: 5.0,
    children: tagsList
  );
}
