import 'package:daff_app/models/story.dart';
import 'package:daff_app/providers/story_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NewCommentScreen extends StatefulWidget {
  NewCommentScreen();
  _NewCommentScreenState createState() => _NewCommentScreenState();
}

class _NewCommentScreenState extends State<NewCommentScreen>{
  String commentContent;

  @override
  Widget build(BuildContext context) {
     return Consumer<StoryProvider>(
      builder: (BuildContext context,  StoryProvider model, Widget child) {
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
            onPressed: () {
              model.addComment(commentContent);
              Navigator.of(context).pop();
            } ,
            child: Row(children: <Widget>[
              Text('לפרסם' ,
                style: TextStyle(fontSize: 20.0, color: Colors.grey[700], 
                fontWeight: commentContent != null ? FontWeight.bold : FontWeight.normal)
              ),
              // SizedBox(width: 5.0,),
              // Icon(Icons.send, size: 15.0, color: Colors.grey[700]),

            ],)
            )
          
        ],
        
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 10.0,),
              //_buildTitle(model.story),
              TextField(
                onChanged: (String value) {
                  setState(() {
                    commentContent = value;
                    
                  });
                },
                style: TextStyle(fontSize: 20.0),
                decoration: InputDecoration(
                  hintText: 'תגובה חדשה על "${model.story.title}" של ${model.story.author.name}...',
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
    );});
  }

  Widget _buildTitle(Story story){
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      child: Text('תגובה חדשה על "${story.title}" של ${story.author.name}:',
        style: TextStyle(fontWeight: FontWeight.bold)
      
      )
    );

  }

}