
import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:daff_app/widgets/audio_player/controls.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class AudioPlayerTask extends BackgroundAudioTask {
  // final QueueHelper queueHelper = QueueHelper();

  // List<MediaItem> _queue = List<MediaItem>();

  List<MediaItem> _queue =  <MediaItem>[
    MediaItem(
      id: "https://s3.amazonaws.com/scifri-episodes/scifri20181123-episode.mp3",
      album: "Science Friday",
      title: "A Salute To Head-Scratching Science",
      artist: "Science Friday and WNYC Studios",
      duration: 5739820,
      artUri:
          "https://media.wnyc.org/i/1400/1400/l/80/1/ScienceFriday_WNYCStudios_1400.jpg",
    )];

  // Future<void> _initializeQueue() async {
  //   print('BackgroundAudioTask _initializeQueue *********');
    
  //   await queueHelper.fetchQueue('backgrdoung task _initializeQueue');
  //   if (_queue != queueHelper.queue) {
  //     _queue = List<MediaItem>();
  //     _queue = queueHelper.queue;
  //   }
  //   String queueTitles = "";
  //   _queue.forEach((i) => queueTitles += "${i.title} //");
  //   print('BackgroundAudioTask new queue: $queueTitles');

  //   await AudioServiceBackground.setQueue(_queue);

  // } 

  int _queueIndex = -1;
  AudioPlayer _audioPlayer = new AudioPlayer();
  Completer _completer = Completer();
  BasicPlaybackState _skipState;
  bool _playing;

  bool get hasNext => _queueIndex + 1 < _queue.length;

  bool get hasPrevious => _queueIndex > 0;

  MediaItem get mediaItem => _queue[_queueIndex];

  BasicPlaybackState _stateToBasicState(AudioPlaybackState state) {
    switch (state) {
      case AudioPlaybackState.none:
        return BasicPlaybackState.none;
      case AudioPlaybackState.stopped:
        return BasicPlaybackState.stopped;
      case AudioPlaybackState.paused:
        return BasicPlaybackState.paused;
      case AudioPlaybackState.playing:
        return BasicPlaybackState.playing;
      case AudioPlaybackState.buffering:
        return BasicPlaybackState.buffering;
      case AudioPlaybackState.connecting:
        return _skipState ?? BasicPlaybackState.connecting;
      case AudioPlaybackState.completed:
        return BasicPlaybackState.stopped;
      default:
        throw Exception("Illegal state");
    }
  }

  @override
  Future<void> onStart() async {
    var playerStateSubscription = _audioPlayer.playbackStateStream
        .where((state) => state == AudioPlaybackState.completed)
        .listen((state) {
      _handlePlaybackCompleted();
    });
    var eventSubscription = _audioPlayer.playbackEventStream.listen((event) {
      final state = _stateToBasicState(event.state);
      if (state != BasicPlaybackState.stopped) {
        _setState(
          state: state,
          position: event.position.inMilliseconds,
        );
      }
    });
    // await _initializeQueue();

    // String backgroundQueue = "";
    // _queue.forEach(((q)=> backgroundQueue += "${q.title} //"));

    // print('AudioServiceBackground new queue: $backgroundQueue');
    // await onSkipToNext();
    await _completer.future;
    playerStateSubscription.cancel();
    eventSubscription.cancel();
  }

  void _handlePlaybackCompleted() {
    if (hasNext) {
      onSkipToNext();
    } else {
      onStop();
    }
  }

  void playPause() {
    if (AudioServiceBackground.state.basicState == BasicPlaybackState.playing)
      onPause();
    else
      onPlay();
  }


  @override
  void onAddQueueItem(MediaItem mediaItem) {
    super.onAddQueueItem(mediaItem);
    print("i'm on onAddQueueItem");
    _queue.add(mediaItem);
    AudioServiceBackground.setQueue(_queue);
    String titles = "";
    _queue.forEach((q) => titles += "${q.title} //");
    print('background queueL: $titles');
  }

 @override
  void onCustomAction(String action, var parameter) async {
    print('aa');
    print(action);
    print(parameter);

    // if condition to play current media
    if (action == "playMedia") {
      // setting the current mediaItem
      print(parameter);
      await AudioServiceBackground.setMediaItem(MediaItem(
        id: parameter['mediaID'],
        album: "OpenBeats Free Music",
        title: parameter['mediaTitle'],
        artist: parameter['channelID'],
        duration: parameter['duration'],
        artUri: parameter['thumbnailURI'],
      ));
      print('bb');
      // setting URL for audio player
      await _audioPlayer.setUrl(parameter['mediaID']);
      print('cc');
      // playing audio
      onPlay();
      print('aa');
    }
  }
  @override
  Future<void> onSkipToNext() => _skip(1);

  @override
  Future<void> onSkipToPrevious() => _skip(-1);

  Future<void> _skip(int offset) async {
    final newPos = _queueIndex + offset;
    if (!(newPos >= 0 && newPos < _queue.length)) return;
    if (_playing == null) {
      // First time, we want to start playing
      _playing = true;
    } else if (_playing) {
      // Stop current item
      await _audioPlayer.stop();
    }
    // Load next item
    _queueIndex = newPos;
    AudioServiceBackground.setMediaItem(mediaItem);
    _skipState = offset > 0
        ? BasicPlaybackState.skippingToNext
        : BasicPlaybackState.skippingToPrevious;
    Duration duration = await _audioPlayer.setUrl(mediaItem.id);
    print('duration: $duration');
    _skipState = null;
    // Resume playback if we were playing
    if (_playing) {
      onPlay();
    } else {
      _setState(state: BasicPlaybackState.paused);
    }
  }

  @override
  void onPlay() {
    if (_skipState == null) {
      _playing = true;
      _audioPlayer.play();
    }
  }

  @override
  void onPause() {
    if (_skipState == null) {
      _playing = false;
      _audioPlayer.pause();
    }
  }

  @override
  void onSeekTo(int position) {
    _audioPlayer.seek(Duration(milliseconds: position));
  }

  @override
  void onClick(MediaButton button) {
    playPause();
  }

  @override
  Future<void> onStop() async {
    _audioPlayer.stop();
    _setState(state: BasicPlaybackState.stopped);
    _completer.complete();
    // await _initializeQueue();
  }

  void _setState({@required BasicPlaybackState state, int position}) {
    if (position == null) {
      position = _audioPlayer.playbackEvent.position.inMilliseconds;
    }
    AudioServiceBackground.setState(
      controls: getControls(state),
      systemActions: [MediaAction.seekTo],
      basicState: state,
      position: position,
    );
  }

  List<MediaControl> getControls(BasicPlaybackState state) {
    if (_playing) {
      return [
        // skipToPreviousControl,
        // pauseControl,
        stopControl,
        // skipToNextControl
      ];
    } else {
      return [
        // skipToPreviousControl,
        playControl,
        // stopControl,
        // skipToNextControl
      ];
    }
  }
}

