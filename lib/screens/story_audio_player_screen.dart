import 'dart:math';
import 'package:daff_app/helpers/queue_helper.dart';
import 'package:daff_app/screens/playlist_screen.dart';
import 'package:daff_app/widgets/audio_player/audio_player_task.dart';
import 'package:daff_app/widgets/audio_player/controls.dart';
import 'package:daff_app/widgets/audio_player/screen_state.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:audio_service/audio_service.dart';
import 'package:rxdart/rxdart.dart';




class StoryAudioPlayerScreen extends StatefulWidget {
  final MediaItem newMediaItem;
  StoryAudioPlayerScreen(this.newMediaItem);
  @override
  _StoryAudioPlayerScreenState createState() => new _StoryAudioPlayerScreenState();
}

class _StoryAudioPlayerScreenState extends State<StoryAudioPlayerScreen> with WidgetsBindingObserver {
  final BehaviorSubject<double> _dragPositionSubject = BehaviorSubject.seeded(null);
  QueueHelper queueHelper = QueueHelper();

  @override
  void initState() {
    super.initState();
    queueHelper.initalize();
    WidgetsBinding.instance.addObserver(this);
    if (widget.newMediaItem != null && widget.newMediaItem != AudioService.currentMediaItem)
      
      // AudioService.addQueueItem(widget.newMediaItem);
      queueHelper.replace(widget.newMediaItem);
    queueHelper.refreshQueue();
    print('-------audio player init state-----');



    connect();
  }

  @override
  void dispose() {
    disconnect();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        connect();
        break;
      case AppLifecycleState.paused:
        disconnect();
        break;
      default:
        break;
    }
  }

  void connect() async {
    await AudioService.connect();
  }

  void disconnect() {
    print('disconnecting');
    AudioService.disconnect();
  }



  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        disconnect();
        return Future.value(true);
      },
      child: Scaffold(
        body: StreamBuilder<ScreenState>(
            stream: Rx.combineLatest3<List<MediaItem>, MediaItem, PlaybackState, ScreenState>(
                AudioService.queueStream,
                AudioService.currentMediaItemStream,
                AudioService.playbackStateStream,
                (queue, mediaItem, playbackState) => ScreenState(queue, mediaItem, playbackState)),
            
            builder: (context, snapshot) {
              final screenState = snapshot.data;
              final queue = screenState?.queue;
              final mediaItem = screenState?.mediaItem != null ? screenState?.mediaItem : widget.newMediaItem;
              final state = screenState?.playbackState;
              final basicState = state?.basicState ?? BasicPlaybackState.none;
              if (screenState != null ) screenState.printScreenState();
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                color: Colors.black87,
                height: MediaQuery.of(context).size.height,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => PlaylistScreen())),
                        icon: Icon(Icons.playlist_play, color: Colors.white, size: 30.0)
                      )
                    ),
                    Container(
                      constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height*0.5),
                      padding: EdgeInsets.all(30.0),
                      child: Image.network(mediaItem.artUri)
                    ),
                     
                    Column(
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      // mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                      Text(mediaItem.title, style: TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold)),
                      Text(mediaItem.artist, style: TextStyle(color: Colors.white)),  
                    ],),
                    
                    positionIndicator(mediaItem, state),
                    buildPlayerControls(),


                  
                      
                        // Text('hi', style: TextStyle(color: Colors.white))
                  
                      
                  ],
                ));
              })
            )
            
      
    );
  }

  Widget buildPlayerControls(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Icon(Icons.skip_next, color: Colors.white, size: 50.0),
        Icon(Icons.play_circle_filled, color: Colors.white, size: 70.0),
        Icon(Icons.skip_previous, color: Colors.white, size: 50.0),
    ],);

  //     (basicState == BasicPlaybackState.none || basicState == BasicPlaybackState.stopped) ?  
  //                     firstPlayButton() 
  //                       : (basicState == BasicPlaybackState.playing || basicState == BasicPlaybackState.paused) && widget.newMediaItem == null ?
  //                         firstPlayButton(stop: true) 
  //                         : basicState == BasicPlaybackState.buffering ||
  //                           basicState == BasicPlaybackState.skippingToNext ||
  //                           basicState == BasicPlaybackState.skippingToPrevious ?
  //                           playerLoader()
  //                           : (basicState == BasicPlaybackState.playing) && widget.newMediaItem != null ?
  //                             stopButton()
  //                             // pauseButton() 
  //                             : (basicState == BasicPlaybackState.paused)  && widget.newMediaItem != null ?
  //                             firstPlayButton(stop: true)
  //                             // playButton() 
  //                               : Text('?')
}




Widget positionIndicator(MediaItem mediaItem, PlaybackState state) {
    double seekPos;
    return StreamBuilder(
      stream: Rx.combineLatest2<double, double, double>(
          _dragPositionSubject.stream,
          Stream.periodic(Duration(milliseconds: 200)),
          (dragPosition, _) => dragPosition),
      builder: (context, snapshot) {
        double position = snapshot.data ?? state.currentPosition.toDouble();
        double duration = mediaItem?.duration?.toDouble();
        return Column(
          children: [
            if (duration != null)
            Directionality( 
              textDirection: TextDirection.ltr,
              child: Slider(
                
                min: 0.0,
                max: duration,
                value: seekPos ?? max(0.0, min(position, duration)),
                onChanged: (value) {
                  _dragPositionSubject.add(value);
                },
                onChangeEnd: (value) {
                  AudioService.seekTo(value.toInt());
                  // Due to a delay in platform channel communication, there is
                  // a brief moment after releasing the Slider thumb before the
                  // new position is broadcast from the platform side. This
                  // hack is to hold onto seekPos until the next state update
                  // comes through.
                  // TODO: Improve this code.
                  seekPos = value;
                  _dragPositionSubject.add(null);
                },
              )),
            // Text("${(stat/e.currentPosition / 1000).toStringAsFixed(3)}", style: TextStyle(color: Colors.white)),
          ],
        );
      },
    );
  }




// Widget originalAudioPlayer(){
//   return new Scaffold(
//       appBar: new AppBar(
//         title: const Text('Audio Service Demo'),
//       ),
//       body: new Center(
//         child: StreamBuilder<ScreenState>(
//           stream: Rx.combineLatest3<List<MediaItem>, MediaItem,
//                   PlaybackState, ScreenState>(
//               AudioService.queueStream,
//               AudioService.currentMediaItemStream,
//               AudioService.playbackStateStream,
//               (queue, mediaItem, playbackState) =>
//                   ScreenState(queue, mediaItem, playbackState)),
//           builder: (context, snapshot) {
//             final screenState = snapshot.data;
//             final queue = screenState?.queue;
//             final mediaItem = screenState?.mediaItem;
//             final state = screenState?.playbackState;
//             final basicState = state?.basicState ?? BasicPlaybackState.none;
//             // print("---------------");
//             // print('screenState: $screenState');
//             // print('queue: $queue');
//             // print('mediaItem: $mediaItem');
//             // print('state: $state');
//             // print('basicState: $basicState');
//             return Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 if (queue != null && queue.isNotEmpty)
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Text('1'),

//                       IconButton(
//                         icon: Icon(Icons.skip_previous),
//                         iconSize: 64.0,
//                         onPressed: mediaItem == queue.first
//                             ? null
//                             : AudioService.skipToPrevious,
//                       ),
//                       IconButton(
//                         icon: Icon(Icons.skip_next),
//                         iconSize: 64.0,
//                         onPressed: mediaItem == queue.last
//                             ? null
//                             : AudioService.skipToNext,
//                       ),
//                     ],
//                   ),
//                 if (mediaItem?.title != null) Text(mediaItem.title),
//                 if (basicState == BasicPlaybackState.none || basicState == BasicPlaybackState.stopped) ...[
//                   // audioPlayerButton(widget.mediaItem)
//                 ] else
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Text('2'),
//                       if (basicState == BasicPlaybackState.playing)
//                         pauseButton()
//                       else if (basicState == BasicPlaybackState.paused)
//                         playButton()
//                       else if (basicState == BasicPlaybackState.buffering ||
//                           basicState == BasicPlaybackState.skippingToNext ||
//                           basicState == BasicPlaybackState.skippingToPrevious)
//                         Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: SizedBox(
//                             width: 64.0,
//                             height: 64.0,
//                             child: CircularProgressIndicator(),
//                           ),
//                         ),
//                       stopButton(),
//                     ],
//                   ),
//                 if (basicState != BasicPlaybackState.none &&
//                     basicState != BasicPlaybackState.stopped) ...[
//                   positionIndicator(mediaItem, state),
//                   Text("State: " +
//                       "$basicState".replaceAll(RegExp(r'^.*\.'), '')),
//                 ]
//               ],
//             );
//           },
//         ),
//       ),
//     );
//   }

  



}




void _audioPlayerTaskEntrypoint() async {
  AudioServiceBackground.run(() => AudioPlayerTask());
}


IconButton firstPlayButton({bool stop = false}) {
    return startButton(
      () {
        print('starting player...');
        if(stop)
          AudioService.stop();
        AudioService.start(
          backgroundTaskEntrypoint: _audioPlayerTaskEntrypoint,
          androidNotificationChannelName: 'הדף',
          notificationColor: 0xFF2196f3,
          // androidNotificationIcon: 'mipmap/ic_launcher',
          androidNotificationIcon: 'mipmap/launcher_icon',
          enableQueue: true,
        );
      }
    );

}










