import 'package:daff_app/models/user.dart';
import 'package:daff_app/providers/auth_provider.dart';
import 'package:daff_app/screens/author_screen.dart';
import 'package:daff_app/screens/connect_screen.dart';
import 'package:daff_app/widgets/avatar_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

Widget buildUserAvatar(BuildContext context) {
  User user = Provider.of<AuthModel>(context).user;
  return !user.connected
      ? IconButton(
          onPressed: () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => ConnectScreen())),
          icon: FaIcon(
            FontAwesomeIcons.user,
          ))
      : _buildUserProfileButton(context, user);
}

Widget _buildUserProfileButton(BuildContext context, User user) {
  return GestureDetector(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => AuthorScreen(user.author.name, user.id))),
      child: Padding(
          padding: EdgeInsets.all(10.0),
          child: buildAvatarImage(user.author.imageUrl)));
}
