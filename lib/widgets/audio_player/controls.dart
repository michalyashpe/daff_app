

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';





  IconButton startButton(VoidCallback onPressed) =>
    IconButton(
      onPressed: onPressed,
      icon: Icon(Icons.play_circle_outline, color: Colors.white)
    );


  Widget playerLoader(){
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      child: SizedBox(
        height: 15.0, 
        width: 15.0 ,
        child: CircularProgressIndicator(
          backgroundColor: Colors.white,
          strokeWidth: 2.0,
        )
      )
    );
  }    

  IconButton playButton() => IconButton(
        icon: Icon(Icons.play_circle_outline, color: Colors.white),
        onPressed: AudioService.play,
      );

  IconButton pauseButton() => IconButton(
        icon: Icon(Icons.pause_circle_outline, color: Colors.white),
        onPressed: AudioService.pause,
      );

  IconButton stopButton() => IconButton(
        icon: Icon(Icons.stop, color: Colors.white),
        onPressed: AudioService.stop,
      );

  

  MediaControl playControl = MediaControl(
  androidIcon: 'drawable/ic_action_play_arrow',
  label: 'Play',
  action: MediaAction.play,
);
MediaControl pauseControl = MediaControl(
  androidIcon: 'drawable/ic_action_pause',
  label: 'Pause',
  action: MediaAction.pause,
);
MediaControl skipToNextControl = MediaControl(
  androidIcon: 'drawable/ic_action_skip_next',
  label: 'Next',
  action: MediaAction.skipToNext,
);
MediaControl skipToPreviousControl = MediaControl(
  androidIcon: 'drawable/ic_action_skip_previous',
  label: 'Previous',
  action: MediaAction.skipToPrevious,
);
MediaControl stopControl = MediaControl(
  androidIcon: 'drawable/ic_action_stop',
  label: 'Stop',
  action: MediaAction.stop,
);
