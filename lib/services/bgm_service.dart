import 'package:audioplayers/audioplayers.dart';

class BgmService {
  BgmService._();

  static final BgmService instance = BgmService._();

  final AudioPlayer player = AudioPlayer();
  bool isStarted = false;

  Future<void> start() async {
    if (isStarted) {
      return;
    }
    await player.setReleaseMode(ReleaseMode.loop);
    await player.setVolume(0.10);
    await player.play(AssetSource('audio/bgm.mp3'));
    isStarted = true; 
  }

  Future<void> stop() async {
    await player.stop();
    isStarted = false;
  }

  Future<void> dispose() async {
    await player.dispose();
    isStarted = false;
  }
}