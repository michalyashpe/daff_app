import 'package:audio_service/audio_service.dart';

class ScreenState {
  final List<MediaItem> queue;
  final MediaItem mediaItem;
  final PlaybackState playbackState;

  ScreenState(this.queue, this.mediaItem, this.playbackState);

  void printScreenState(){
    print("----------------ScreenState--------------------");
    String queueItems = "";
    if (queue != null) {
      queue.forEach((i) => queueItems += i.title + "// ");
      print('Queue state: ${queue.length} items: $queueItems');
    }
    print('MediaItem: ${mediaItem?.title}');
    print('playbackState: $playbackState -- ${playbackState?.basicState}');
    print("------------------------------------------------");
    
  }
}
