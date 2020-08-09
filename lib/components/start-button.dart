import 'dart:ui';
import 'package:flame/sprite.dart';
import 'package:langaw/langaw-game.dart';
import 'package:langaw/view.dart';

class StartButton {
  final LangawGame game;
  Rect rect;
  Sprite sprite;

  StartButton(this.game) {
    // The Start button image is 6x3 tiles
    rect = Rect.fromLTWH(
      game.tileSize * 1.5, // (screen width - image width) / 2 = (9 - 6) / 2
      // = 1.5
      (game.screenSize.height * .75) - (game.tileSize * 1.5), // Top of image
      // is 3/4 down the screen
      game.tileSize * 6,
      game.tileSize * 3,
    );
    sprite = Sprite('ui/start-button.png');
  }

  void render(Canvas c) {
    sprite.renderRect(c, rect);
  }

  void update(double t) {}

  void onTapDown() {
    game.score = 0;

    game.activeView = View.playing;
    game.spawner.start();
//    game.playPlayingBGM();
  }
}
