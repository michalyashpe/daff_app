import 'package:audio_service/audio_service.dart';
import 'package:daff_app/helpers/database_helper.dart';
import 'package:daff_app/widgets/audio_player/audio_player_task.dart';
import 'package:flutter/material.dart';

class AudioPlayerProvider extends ChangeNotifier{
  final dbHelper = DatabaseHelper.instance;
  bool loading = false;
  List<MediaItem> _queue = List<MediaItem>();
  // bool _showPlayer = false;


  void connect() async {
    print('connecting');
    await AudioService.connect();
  }

  void disconnect(String fromWhere) {
    print('disconnecting $fromWhere');
    AudioService.disconnect();
  }


  bool get isPlaying {
    return AudioServiceBackground.state.basicState == BasicPlaybackState.playing;
  }



void _audioPlayerTaskEntrypoint() async {
  AudioServiceBackground.run(() => AudioPlayerTask());
}

Function startAndAddToQueue(MediaItem mediaItem){
  return (){
    print('hi');
    if (AudioService.connected) return;
    print('starting player...');
    AudioService.start(
      backgroundTaskEntrypoint: _audioPlayerTaskEntrypoint,
      androidNotificationChannelName: 'הדף',
      notificationColor: 0xFF2196f3,
      // androidNotificationIcon: 'mipmap/ic_launcher',
      androidNotificationIcon: 'mipmap/launcher_icon',
      enableQueue: true,
    );
    AudioService.addQueueItem(mediaItem);
  };
}

  // bool get showPlayer {
  //   // print("_________________$_showPlayer");
  //   return _showPlayer;
  // }

  // void togglePlayer() {
  //   _showPlayer = !_showPlayer;
  //   notifyListeners();
  // }


// sql database related stuff


  Future<void> fetchQueue(String whereFrom) async {
    print('fetching queue...');
    loading = true;
    notifyListeners();
    _queue.removeRange(0, _queue.length);
    List<Map<String, dynamic>> allMediaItemsData = await dbHelper.queryAllRows(); 
    allMediaItemsData.forEach((mediaItemData) {
      MediaItem newMediaItem = MediaItem(
        id: mediaItemData['audioUri'],
        album: mediaItemData['album'],
        title: mediaItemData['title'],
        artist: mediaItemData['artist'],
        duration: mediaItemData['duration'],
        artUri: mediaItemData['artUri'],
      );
      _queue.add(newMediaItem);
    }); 

    loading = false;
    notifyListeners();
    String queueTitles = "";
    queue.forEach((q) => queueTitles += "${q.title} //");
    print('updated queueHelper queue: $queueTitles -- $whereFrom' );
    return;
  }

  List<MediaItem> get queue {
    return _queue;
  }

  void insert(MediaItem mediaItem) async {
    print('adding to queue: ${mediaItem.title}');
    final id = await dbHelper.insert(getRow(mediaItem));
    // await fetchQueue('insert');
  }

  void replace(MediaItem mediaItem) async{
    deleteAll();
    insert(mediaItem);
    await fetchQueue('replace');
  }


  void query() async {
    final allRows = await dbHelper.queryAllRows();
    print('query all rows:');
    allRows.forEach((row) => print(row));
  }

  void update(MediaItem mediaItem) async {
    final rowsAffected = await dbHelper.update(getRow(mediaItem));
    print('updated $rowsAffected row(s)');
  }

  // void delete() async {
  //   // Assuming that the number of rows is the id for the last row.
  //   final id = await dbHelper.queryRowCount();
  //   final rowsDeleted = await dbHelper.delete(id);
  //   print('deleted $rowsDeleted row(s): row $id');
  // }

  void deleteAll() async {
    final allRows = await dbHelper.queryAllRows();
    print('db rows length: ${allRows.length}');
    allRows.forEach((row) {
      print('deleting ${row["_id"]}');
      dbHelper.delete(row['_id']);
    });
  }



  Map<String, dynamic> getRow(MediaItem mediaItem){
    Map<String, dynamic> row = {
      DatabaseHelper.columnAudioUri  : mediaItem.id,
      DatabaseHelper.columnAlbum : mediaItem.album,
      DatabaseHelper.columnTitle  : mediaItem.title,
      DatabaseHelper.columnArtist : mediaItem.artist,
      DatabaseHelper.columnDuration  : mediaItem.duration,
      DatabaseHelper.columnArtUri  : mediaItem.artUri,
    };
    return row;
  }


}