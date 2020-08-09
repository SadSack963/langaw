import 'package:flame/sprite.dart';
import 'package:langaw/components/fly.dart';
import 'package:langaw/langaw-game.dart';
import 'dart:ui';

// Create a sub-class of the super-class Fly
// The constructor calls super which tells the program to run the constructor
// of the superclass before executing the code inside the constructor’s body.
// The constructor just mirrors the parameters required by the constructor of
// the superclass and forwards them during the call to super.
class AgileFly extends Fly {
  double get speed => game.tileSize * 5;

  AgileFly(LangawGame game, double x, double y) : super(game) {
    /// ######### WHY do we use a get above when this seems to work? #########
//    double speed = game.tileSize * 5;

    flyingSprite = List<Sprite>();
    flyingSprite.add(Sprite('flies/agile-fly-1.png'));
    flyingSprite.add(Sprite('flies/agile-fly-2.png'));
    deadSprite = Sprite('flies/agile-fly-dead.png');
    flyRect = Rect.fromLTWH(x, y, kAgileFlySize, kAgileFlySize);
  }
}
