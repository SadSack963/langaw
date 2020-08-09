import 'dart:ui';
import 'package:flame/sprite.dart';
import 'package:langaw/langaw-game.dart';

class HomeView {
  final LangawGame game;
  Rect titleRect;
  Sprite titleSprite;

  HomeView(this.game) {
    // The title image is 7x4 tiles
    titleRect = Rect.fromLTWH(
      game.tileSize, // (screen width - image width) / 2 = (9 - 7) / 2 = 1
      (game.screenSize.height / 2) - (game.tileSize * 4), // bottom of the
      // image is at the center line
      game.tileSize * 7,
      game.tileSize * 4,
    );
    titleSprite = Sprite('branding/title.png');
  }

  void render(Canvas c) {
    titleSprite.renderRect(c, titleRect);
  }

  void update(double t) {}
}
