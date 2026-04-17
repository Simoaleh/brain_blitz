import 'package:audioplayers/audioplayers.dart';

class BgmService {
  BgmService._();

  static final BgmService instance = BgmService._();

  final AudioPlayer player = AudioPlayer();
  bool isStarted = false;
  bool listenersAttached = false;
  double currentVolume = 0.10;

  void attachListeners() {
    if (listenersAttached) return;
    listenersAttached = true;

    player.onPlayerStateChanged.listen((state) {
      isStarted = state == PlayerState.playing;
    });
  }

  Future<void> start() async {
    attachListeners();
    if (isStarted && player.state == PlayerState.playing) {
      return;
    }

    if (player.state == PlayerState.paused) {
      await player.resume();
      isStarted = true;
      return;
    }

    if (isStarted) {
      return;
    }

    await player.setReleaseMode(ReleaseMode.loop);
    await player.setVolume(currentVolume);
    await player.play(AssetSource('audio/bgm.mp3'));
    isStarted = true; 
  }

  Future<void> pause() async {
    await player.pause();
    isStarted = false;
  }

  Future<void> resume() async {
    if (player.state == PlayerState.paused) {
      await player.resume();
      isStarted = true;
    }
  }

  Future<void> stop() async {
    await player.stop();
    isStarted = false;
  }

  Future<void> dispose() async {
    await player.dispose();
    isStarted = false;
  }

  Future<void> setVolume(double volume) async {
    currentVolume = volume.clamp(0.0, 1.0);
    await player.setVolume(currentVolume);
  }
}