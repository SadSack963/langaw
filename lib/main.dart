import 'package:flutter/material.dart';
import 'package:flame/util.dart'; // Access to forcing using Flame's util class
// portrait mode
import 'package:flutter/services.dart'; // Access to DeviceOrientation class
import 'package:langaw/langaw-game.dart';
import 'package:flutter/gestures.dart'; // Access to user gestures
import 'package:flame/flame.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  // This prevents Flutter error which occur using Util() before runApp()
  // Alternatively, we could move the offending lines to the top of main():
  //   LangawGame game = LangawGame();
  //   runApp(game.widget);
  WidgetsFlutterBinding.ensureInitialized();

  Util flameUtil = Util();
  await flameUtil.fullScreen();
  await flameUtil.setOrientation(DeviceOrientation.portraitUp);

  Flame.images.loadAll(<String>[
    'bg/backyard.png',
    'flies/agile-fly-1.png',
    'flies/agile-fly-2.png',
    'flies/agile-fly-dead.png',
    'flies/drooler-fly-1.png',
    'flies/drooler-fly-2.png',
    'flies/drooler-fly-dead.png',
    'flies/house-fly-1.png',
    'flies/house-fly-2.png',
    'flies/house-fly-dead.png',
    'flies/hungry-fly-1.png',
    'flies/hungry-fly-2.png',
    'flies/hungry-fly-dead.png',
    'flies/macho-fly-1.png',
    'flies/macho-fly-2.png',
    'flies/macho-fly-dead.png',
    'bg/lose-splash.png',
    'branding/title.png',
    'ui/dialog-credits.png',
    'ui/dialog-help.png',
    'ui/icon-credits.png',
    'ui/icon-help.png',
    'ui/start-button.png',
    'ui/callout.png',
    'ui/icon-music-disabled.png',
    'ui/icon-music-enabled.png',
    'ui/icon-sound-disabled.png',
    'ui/icon-sound-enabled.png',
  ]);

  // Disable extra debug logging so that it does not write too much log
  // information into the debug console
  Flame.audio.disableLog();
  Flame.audio.loadAll(<String>[
    'sfx/haha1.ogg',
    'sfx/haha2.ogg',
    'sfx/haha3.ogg',
    'sfx/haha4.ogg',
    'sfx/haha5.ogg',
    'sfx/ouch1.ogg',
    'sfx/ouch2.ogg',
    'sfx/ouch3.ogg',
    'sfx/ouch4.ogg',
    'sfx/ouch5.ogg',
    'sfx/ouch6.ogg',
    'sfx/ouch7.ogg',
    'sfx/ouch8.ogg',
    'sfx/ouch9.ogg',
    'sfx/ouch10.ogg',
    'sfx/ouch11.ogg',
    'bgm/home.mp3',
    'bgm/playing.mp3',
  ]);

  // The .getInstance factory returns a Future so we must use the await keyword
  // to pause the execution and wait for whatever the Future returns
  SharedPreferences storage = await SharedPreferences.getInstance();

  LangawGame game = LangawGame(storage);
  runApp(game.widget);

  // Create a gesture recognizer, link its onTapDown property to the game
  // class’ onTapDown handler, and register the recognizer using Flame
  // utility’s addGestureRecognizer method

  // TODO: 'addGestureRecognizer' is deprecated
  // 'addGestureRecognizer' is deprecated and shouldn't be used.
  // This method can lead to confuse behaviour, use the gestures methods
  // provided by the Game class.

  TapGestureRecognizer tapper = TapGestureRecognizer();
  tapper.onTapDown = game.onTapDown;
  flameUtil.addGestureRecognizer(tapper);
}
