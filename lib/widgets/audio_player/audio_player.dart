import 'dart:math';

import 'package:daff_app/helpers/queue_helper.dart';
import 'package:daff_app/widgets/audio_player/audio_player_task.dart';
import 'package:daff_app/widgets/audio_player/screen_state.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:audio_service/audio_service.dart';
import 'package:rxdart/rxdart.dart';

import 'controls.dart';



class AudioPlayerApp extends StatefulWidget {
  final MediaItem mediaItem;
  AudioPlayerApp(this.mediaItem);
  @override
  _AudioPlayerAppState createState() => new _AudioPlayerAppState();
}

class _AudioPlayerAppState extends State<AudioPlayerApp> with WidgetsBindingObserver {
  final BehaviorSubject<double> _dragPositionSubject = BehaviorSubject.seeded(null);
  QueueHelper queueHelper = QueueHelper();

  @override
  void initState() {
    super.initState();
    queueHelper.initalize();
    WidgetsBinding.instance.addObserver(this);

    queueHelper.replace(widget.mediaItem);
    queueHelper.refreshQueue();



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
      child: Container(
        color: Colors.black87,
        height: 50.0,
        child: StreamBuilder<ScreenState>(
          stream: Rx.combineLatest3<List<MediaItem>, MediaItem, PlaybackState, ScreenState>(
              AudioService.queueStream,
              AudioService.currentMediaItemStream,
              AudioService.playbackStateStream,
              (queue, mediaItem, playbackState) => ScreenState(queue, mediaItem, playbackState)),
          
          builder: (context, snapshot) {
            final screenState = snapshot.data;
            final queue = screenState?.queue;
            final mediaItem = screenState?.mediaItem;
            final state = screenState?.playbackState;
            final basicState = state?.basicState ?? BasicPlaybackState.none;
            return Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                widget.mediaItem.artUri != null && widget.mediaItem.artUri != '' ? 
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.all(7.0),
                    child: Image.network(widget.mediaItem.artUri)
                  ) : null,
                Expanded( child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                  Text(widget.mediaItem.title, style: TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold)),
                  Text(widget.mediaItem.artist, style: TextStyle(color: Colors.white)),  
                ],)),
                
                basicState == BasicPlaybackState.playing && mediaItem.title != widget.mediaItem.title ?
                  stopButton()
                  : basicState == BasicPlaybackState.paused && mediaItem.title != widget.mediaItem.title ?
                    firstPlayButton(widget.mediaItem, stop: true) 
                    : (basicState == BasicPlaybackState.none || basicState == BasicPlaybackState.stopped) ?  
                      firstPlayButton(widget.mediaItem) 
                      : basicState == BasicPlaybackState.buffering ||
                        basicState == BasicPlaybackState.skippingToNext ||
                        basicState == BasicPlaybackState.skippingToPrevious ?
                        playerLoader()
                        : (basicState == BasicPlaybackState.playing) ?
                          pauseButton() 
                          : (basicState == BasicPlaybackState.paused) ?
                          playButton() : Text('?')
                  
              ],
              );
            })
          )
          
    );
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
              Slider(
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
              ),
            Text("${(state.currentPosition / 1000).toStringAsFixed(3)}"),
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


IconButton firstPlayButton(MediaItem mediaItem, {bool stop = false}) {
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









