import 'package:flame/sprite.dart';
import 'package:langaw/components/fly.dart';
import 'package:langaw/langaw-game.dart';
import 'dart:ui';

// Create a sub-class of the super-class Fly
// The constructor calls super which tells the program to run the constructor
// of the superclass before executing the code inside the constructor’s body.
// The constructor just mirrors the parameters required by the constructor of
// the superclass and forwards them during the call to super.
class MachoFly extends Fly {
  double get speed => game.tileSize * 2.5;

  MachoFly(LangawGame game, double x, double y) : super(game) {
    flyingSprite = List<Sprite>();
    flyingSprite.add(Sprite('flies/macho-fly-1.png'));
    flyingSprite.add(Sprite('flies/macho-fly-2.png'));
    deadSprite = Sprite('flies/macho-fly-dead.png');
    flyRect = Rect.fromLTWH(x, y, kMachoFlySize, kMachoFlySize);
  }
}
