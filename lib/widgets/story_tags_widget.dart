import 'package:daff_app/providers/stories_screen_provider.dart';
import 'package:daff_app/screens/stories_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Widget buildStoryTagsWidget(List<String> tags, BuildContext context, {bool tagView = false}){
  List<Widget> tagsList = List<Widget>();
  tags.forEach((String tagName) {
    Widget tag = GestureDetector(
      onTap: () {
        Provider.of<StoriesModel>(context, listen: false).initialize(tag: tagName);
        if (!tagView) Navigator.of(context).pushNamed(StoriesScreen.routeName);
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          color: Colors.grey[300],
        ),
        padding: EdgeInsets.symmetric(horizontal: 5.0),
        child: Text(tagName, style: TextStyle(fontSize: 13.5))
      )
    )
  ;
  tagsList.add(tag);
  });
  return Wrap(
    spacing: 5.0,
    runSpacing: 5.0,
    children: tagsList
  );
}
