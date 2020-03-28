import 'package:audio_service/audio_service.dart';
import 'package:daff_app/helpers/database_helper.dart';

class QueueHelper{
  final dbHelper = DatabaseHelper.instance;
  List<String> columnNames = ['album', 'title', 'artist', 'duration', 'artUri' ]; //MediaItem Properties

  List<MediaItem> queue = <MediaItem>[ //change to fetch from db
    MediaItem(
      id: "https://s3.amazonaws.com/scifri-episodes/scifri20181123-episode.mp3",
      album: "test audio track 1 album",
      title: "test audio track 1",
      artist: "Ohad Bikovsky",
      duration: 5739820,
      artUri:
          "https://media.wnyc.org/i/1400/1400/l/80/1/ScienceFriday_WNYCStudios_1400.jpg",
    ),
    MediaItem(
      id: "https://s3.amazonaws.com/scifri-segments/scifri201711241.mp3",
      album: "album name",
      title: "test audio track 2",
      artist: "Dor Kalev",
      duration: 2856950,
      artUri:
          "https://media.wnyc.org/i/1400/1400/l/80/1/ScienceFriday_WNYCStudios_1400.jpg",
    ),
  ];


  void fetchQueue() async {
    final allRows = await dbHelper.queryAllRows();
    print('fetching queue...');
    allRows.forEach((row) {
      print(row);
    });
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



  Map<String, dynamic> getRow(MediaItem mediaItem){
    Map<String, dynamic> row = {
      DatabaseHelper.columnAlbum : mediaItem.album,
      DatabaseHelper.columnTitle  : mediaItem.title,
      DatabaseHelper.columnArtist : mediaItem.artist,
      DatabaseHelper.columnDuration  : mediaItem.duration,
      DatabaseHelper.columnArtUri  : mediaItem.artUri
    };
    return row;
  }


}