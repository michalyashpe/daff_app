import 'package:flutter/material.dart';

class NewCommentScreen extends StatefulWidget {
  NewCommentScreen();
  _NewCommentScreenState createState() => _NewCommentScreenState();
}

class _NewCommentScreenState extends State<NewCommentScreen>{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).backgroundColor,
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(Icons.close),
        ),
        actions: <Widget>[
          FlatButton(
            onPressed: () => print('send form'),
            child: Text('לפרסם' ,style: TextStyle(fontSize: 20.0, color: Colors.grey[700], fontWeight: FontWeight.bold))
            )
          
        ],
        
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                style: TextStyle(fontSize: 20.0),
                decoration: InputDecoration(
                  hintText: "התגובה שלי...",
                  contentPadding: EdgeInsets.all(10.0)
                ),
                scrollPadding: EdgeInsets.all(20.0),
                keyboardType: TextInputType.multiline,
                maxLines: 99999,
                autofocus: true,)
            ],
          ),
        ),
      ),
      resizeToAvoidBottomPadding: true,
    );
  }
}