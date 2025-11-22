import 'package:audioplayers/audioplayers.dart';

class AudioHelper {
  final AudioPlayer _audioPlayer = AudioPlayer();

  Future<void> playSound(String soundFile, {double volume = 1.0}) async {
    try {
      await _audioPlayer.setVolume(volume);
      await _audioPlayer.play(AssetSource('sounds/$soundFile'));
    } catch (e) {
      // Silently handle audio errors
    }
  }

  void dispose() {
    _audioPlayer.dispose();
  }
}
