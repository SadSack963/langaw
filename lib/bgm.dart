import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/widgets.dart'; // Access to WidgetsBinding

class BGM {
  static List<AudioCache> _tracks = List<AudioCache>();
  static int _currentTrack = -1;
  static bool _isPlaying = false;

  static Future _update() async {
    if (_currentTrack == -1) {
      return;
    }

    if (_isPlaying) {
      await _tracks[_currentTrack].fixedPlayer.resume();
    } else {
      await _tracks[_currentTrack].fixedPlayer.pause();
    }
  }

  static Future<void> add(String filename) async {
    AudioCache newTrack =
        AudioCache(prefix: 'audio/', fixedPlayer: AudioPlayer());
    await newTrack.load(filename);
    await newTrack.fixedPlayer.setReleaseMode(ReleaseMode.LOOP);
    _tracks.add(newTrack);
  }

  static void remove(int trackIndex) async {
    if (trackIndex >= _tracks.length) {
      return;
    }
    if (_isPlaying) {
      if (_currentTrack == trackIndex) {
        await stop();
      }
      if (_currentTrack > trackIndex) {
        _currentTrack -= 1;
      }
    }
    _tracks.removeAt(trackIndex);
  }

  static void removeAll() {
    if (_isPlaying) {
      stop();
    }
    _tracks.clear();
  }

  static Future play(int trackIndex, {double volume}) async {
    if (_currentTrack == trackIndex) {
      if (_isPlaying) {
        return;
      }
      _isPlaying = true;
      _update();
      return;
    }

    if (_isPlaying) {
      await stop();
    }

    // When we call the add method above, it adds a new track (AudioCache
    // object) to the list. Each track holds a cache of loaded music files
    // in a Map named loadedFiles where the keys are stored as Strings.
    // For each cached music file, the key is set to the filename you supply
    // to it. In this class, one track only holds/caches one music file so
    // we can get the original filename passed by accessing .keys.first of
    // the loadedFiles property.
    _currentTrack = trackIndex;
    _isPlaying = true;
    AudioCache t = _tracks[_currentTrack];
    await t.loop(t.loadedFiles.keys.first);
    _update();
  }

  static Future stop() async {
    await _tracks[_currentTrack].fixedPlayer.stop();
    _currentTrack = -1;
    _isPlaying = false;
  }

  static void pause() {
    _isPlaying = false;
    _update();
  }

  static void resume() {
    _isPlaying = true;
    _update();
  }

  static _BGMWidgetsBindingObserver _bgmwbo;

  static _BGMWidgetsBindingObserver get widgetsBindingObserver {
    if (_bgmwbo == null) {
      _bgmwbo = _BGMWidgetsBindingObserver();
    }
    return _bgmwbo;
  }

  static void attachWidgetBindingListener() {
    WidgetsBinding.instance.addObserver(BGM.widgetsBindingObserver);
  }
}

class _BGMWidgetsBindingObserver extends WidgetsBindingObserver {
  // Called when the system puts the app in the background or returns the app to the foreground
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      BGM.resume();
    } else {
      BGM.pause();
    }
  }
}
