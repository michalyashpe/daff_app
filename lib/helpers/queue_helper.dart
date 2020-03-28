import 'package:audio_service/audio_service.dart';
import 'package:daff_app/helpers/database_helper.dart';

class QueueHelper{
  final dbHelper = DatabaseHelper.instance;

  List<MediaItem> _queue;

  Future<void> initalize() async {
    if (_queue != null) return;
    await fetchQueue();
  }

   Future<void> fetchQueue() async {
    print('fetching queue...');
    _queue = List<MediaItem>();
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
    return;
  }

  List<MediaItem> get queue {
    return _queue;
  }


  

  void insert(MediaItem mediaItem) async {
    print('inserting mediaItem');
    query();
    // print('queue.length: ${queue.length}');
    // row to insert
    
    final id = await dbHelper.insert(getRow(mediaItem));
    fetchQueue();
    print('inserted row id: $id');
    // print('queue.length: ${queue.length}');
    query();
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

  void delete() async {
    // Assuming that the number of rows is the id for the last row.
    final id = await dbHelper.queryRowCount();
    final rowsDeleted = await dbHelper.delete(id);
    print('deleted $rowsDeleted row(s): row $id');
  }

  void deleteAll() async {
    final allRows = await dbHelper.queryAllRows();
    allRows.forEach((row) => dbHelper.delete(row['_id']));
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