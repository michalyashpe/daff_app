import 'package:daff_app/providers/auth_provider.dart';
import 'package:daff_app/models/user.dart';
import 'package:daff_app/providers/user_provider.dart';
import 'package:daff_app/widgets/avatar_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserProfileScreen extends StatefulWidget {
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
        builder: (BuildContext context, UserProvider model, Widget child) {
      return Scaffold(
          body: CustomScrollView(slivers: <Widget>[
        SliverAppBar(
          automaticallyImplyLeading: false,
          iconTheme: IconThemeData(color: Colors.grey),
          floating: true,
          pinned: false,
          snap: true,
          backgroundColor: Theme.of(context).backgroundColor,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context, false),
          ),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                Provider.of<AuthModel>(context, listen: false).logOut();
                Navigator.of(context).pop();
              },
              child: Text('ניתוק'),
            )
          ],
        ),
        SliverList(
            delegate: SliverChildListDelegate(
          [
            SizedBox(
              height: 15.0,
            ),
            buildProfileTop(model.user),
          ],
        ))
      ]));
    });
  }

  Widget buildProfileTop(User user) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Center(child: buildAvatarImage(user.author.imageUrl)),
        Text(user.author.name),
      ],
    );
  }
}
