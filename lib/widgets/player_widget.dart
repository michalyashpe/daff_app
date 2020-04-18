import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:daff_app/models/story.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

enum PlayerState { stopped, playing, paused, buffering }
enum PlayingRouteState { speakers, earpiece }

class PlayerWidget extends StatefulWidget {
  final PlayerMode mode;
  final Story story;

  PlayerWidget(
      {Key key, @required this.story, this.mode = PlayerMode.MEDIA_PLAYER})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _PlayerWidgetState(story.audioUrl, mode);
  }
}

class _PlayerWidgetState extends State<PlayerWidget> {
  String url;
  PlayerMode mode;

  AudioPlayer _audioPlayer;
  AudioPlayerState _audioPlayerState;
  Duration _duration;
  Duration _position;

  PlayerState _playerState = PlayerState.stopped;
  PlayingRouteState _playingRouteState = PlayingRouteState.speakers;
  StreamSubscription _durationSubscription;
  StreamSubscription _positionSubscription;
  StreamSubscription _playerCompleteSubscription;
  StreamSubscription _playerErrorSubscription;
  StreamSubscription _playerStateSubscription;

  get _isPlaying => _playerState == PlayerState.playing;
  get _isPaused => _playerState == PlayerState.paused;
  get _durationText => _duration?.toString()?.split('.')?.first ?? '';
  get _positionText => _position?.toString()?.split('.')?.first ?? '';

  get _isPlayingThroughEarpiece =>
      _playingRouteState == PlayingRouteState.earpiece;

  _PlayerWidgetState(this.url, this.mode);

  @override
  void initState() {
    super.initState();
    _initAudioPlayer();
  }

  @override
  void dispose() {
    print('disposing player_widget');
    _audioPlayer.stop();
    _durationSubscription?.cancel();
    _positionSubscription?.cancel();
    _playerCompleteSubscription?.cancel();
    _playerErrorSubscription?.cancel();
    _playerStateSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    double height = 60.0;
    double sliderHeight = 4.0;

    return     MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child:
    
    Container(
    color: Colors.black,
    height: height + sliderHeight,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      
      children: <Widget>[
        buildSlider(sliderHeight),
      Container( 
        height: height,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
          widget.story.imageUrl != null && widget.story.imageUrl != '' ? 
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(7.0),
              child: Image.network(widget.story.imageUrl) //buildAvatarImage(story)
            ): null,
            Expanded( child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
              Text(widget.story.title, style: TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold)),
              Text(widget.story.author.name , style: TextStyle(color: Colors.white)),  
            ],)),
            
            !_isPlaying ?
              IconButton(
                key: Key('play_button'),
                onPressed: _isPlaying ? null : () => _play(),
                icon: Icon(Icons.play_circle_outline),
                color: Colors.white,
              )
              : _isPlaying && _duration == null ? 
                Container(
                  margin: EdgeInsets.only(left: 16.0),
                  width: 16.0,
                  height: 16.0, 
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.white,
                    strokeWidth: 2.0,
                  )
                ) 
                : IconButton(
                  key: Key('pause_button'),
                  onPressed: _isPlaying ? () => _pause() : null,
                  icon: Icon(Icons.pause_circle_outline),
                  color: Colors.white,
                ),
          ],)
        ),
        
    ],)
  ));

  }

  Widget buildSlider(double height){
    Color activeTrackColor = Colors.grey[700];
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Container( 
        color: activeTrackColor,
        child: SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: activeTrackColor,
            inactiveTrackColor: Colors.grey[300],
            trackShape: RectangularSliderTrackShape(),
            trackHeight: height,
            thumbColor: Colors.grey,
            thumbShape: RoundSliderThumbShape(enabledThumbRadius: 0.0),
            overlayColor: Colors.grey,
            overlayShape: RoundSliderOverlayShape(overlayRadius: 0.0),
          ),
          child: Slider(
            onChanged: (v) {
              final Position = v * _duration.inMilliseconds;
              _audioPlayer
                  .seek(Duration(milliseconds: Position.round()));
            },
            value: (_position != null &&
                    _duration != null &&
                    _position.inMilliseconds > 0 &&
                    _position.inMilliseconds < _duration.inMilliseconds)
                ? _position.inMilliseconds / _duration.inMilliseconds
                : 0.0,
          ),
        )
    ));

  }
  void _initAudioPlayer() {
    _audioPlayer = AudioPlayer(mode: mode);

    _durationSubscription = _audioPlayer.onDurationChanged.listen((duration) {
      setState(() => _duration = duration);

      // TODO implemented for iOS, waiting for android impl
      if (Theme.of(context).platform == TargetPlatform.iOS) {
        // (Optional) listen for notification updates in the background
        _audioPlayer.startHeadlessService();

        // set at least title to see the notification bar on ios.
        _audioPlayer.setNotification(
            title: 'App Name',
            artist: 'Artist or blank',
            albumTitle: 'Name or blank',
            imageUrl: 'url or blank',
            forwardSkipInterval: const Duration(seconds: 30), // default is 30s
            backwardSkipInterval: const Duration(seconds: 30), // default is 30s
            duration: duration,
            elapsedTime: Duration(seconds: 0));
      }
    });

    _positionSubscription =
        _audioPlayer.onAudioPositionChanged.listen((p) => setState(() {
              _position = p;
            }));

    _playerCompleteSubscription =
        _audioPlayer.onPlayerCompletion.listen((event) {
      _onComplete();
      setState(() {
        _position = _duration;
      });
    });

    _playerErrorSubscription = _audioPlayer.onPlayerError.listen((msg) {
      print('audioPlayer error : $msg');
      setState(() {
        _playerState = PlayerState.stopped;
        _duration = Duration(seconds: 0);
        _position = Duration(seconds: 0);
      });
    });

    _audioPlayer.onPlayerStateChanged.listen((state) {
      print(state);
      if (!mounted) return;
      setState(() {
        _audioPlayerState = state;
      });
    });

    _audioPlayer.onNotificationPlayerStateChanged.listen((state) {
      if (!mounted) return;
      setState(() => _audioPlayerState = state);
    });

    _playingRouteState = PlayingRouteState.speakers;
  }

  Future<int> _play() async {
    setState(() => _playerState = PlayerState.buffering);
    print(_playerState);

    final playPosition = (_position != null &&
            _duration != null &&
            _position.inMilliseconds > 0 &&
            _position.inMilliseconds < _duration.inMilliseconds)
        ? _position
        : null;
    final result = await _audioPlayer.play(url, position: playPosition);
    if (result == 1) setState(() => _playerState = PlayerState.playing);

    // default playback rate is 1.0
    // this should be called after _audioPlayer.play() or _audioPlayer.resume()
    // this can also be called everytime the user wants to change playback rate in the UI
    _audioPlayer.setPlaybackRate(playbackRate: 1.0);

    return result;
  }

  Future<int> _pause() async {
    final result = await _audioPlayer.pause();
    if (result == 1) setState(() => _playerState = PlayerState.paused);
    return result;
  }

  Future<int> _earpieceOrSpeakersToggle() async {
    final result = await _audioPlayer.earpieceOrSpeakersToggle();
    if (result == 1)
      setState(() => _playingRouteState =
          _playingRouteState == PlayingRouteState.speakers
              ? PlayingRouteState.earpiece
              : PlayingRouteState.speakers);
    return result;
  }

  Future<int> _stop() async {
    final result = await _audioPlayer.stop();
    if (result == 1) {
      setState(() {
        _playerState = PlayerState.stopped;
        _position = Duration();
      });
    }
    return result;
  }

  void _onComplete() {
    setState(() => _playerState = PlayerState.stopped);
  }
}



