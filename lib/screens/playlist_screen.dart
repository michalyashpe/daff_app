
import 'package:daff_app/helpers/queue_helper.dart';
import 'package:flutter/material.dart';

class PlaylistScreen extends StatefulWidget {
  _PlaylistScreenState createState() => _PlaylistScreenState();
}

class _PlaylistScreenState extends State<PlaylistScreen>{
  QueueHelper queueHelper = QueueHelper();

  @override
  void initState() {
    super.initState();
    queueHelper.initalize();
    print('-------audio player init state-----');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 50.0),
        color: Colors.black87,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          // mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.close, color: Colors.white)
              )
            ),
            SizedBox(height: 30.0,),
            Text('הסתיים:', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20.0)),
            Text('מנגן עכשיו:', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20.0)),
            Text('הקטעים הבאים:', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20.0))
        ],)
      )

    );
  }
}