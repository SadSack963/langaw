import 'dart:ui'; // Access to Canvas class
import 'package:flame/sprite.dart'; // Access to Flame's Sprite class
import 'package:langaw/langaw-game.dart'; // Access to LangawGame class

// Sizing:
// The image is 1080x2760 pixels
// The game uses a 9x9 tile, (defined in LangawGame.resize)
//   so 1080 / 9 = 120 pixels per tile and
//   2760 / 120 = 23 tiles
// The picture is therefore 9 x 23 tiles

class Backyard {
  final LangawGame game;
  Sprite bgSprite;
  Rect bgRect;

  Backyard(this.game) {
    bgSprite = Sprite('bg/backyard.png');
    // Rect.fromLTWH(x,y,width,height)
    // Draw the background in full width:
    //   x = 0,
    //   picture width = 9 tiles (could also use game.screenSize.width)
    // We need to anchor the picture at the bottom of the screen:
    //   picture height = 23 tiles
    //   y = screen height - picture height (which will be negative)
    bgRect = Rect.fromLTWH(
      0,
      game.screenSize.height - (game.tileSize * 23),
      game.tileSize * 9,
      game.tileSize * 23,
    );
  }

  void render(Canvas c) {
    // Use Flame's Sprite method renderRect to draw the background
    bgSprite.renderRect(c, bgRect);
  }

  void update(double t) {}
}
