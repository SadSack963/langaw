import 'dart:ui'; // Access to Canvas class
import 'package:langaw/langaw-game.dart'; // Access to screenSize
import 'package:flame/sprite.dart'; // Access to Sprite class
import 'package:langaw/view.dart';
import 'package:langaw/components/callout.dart';
import 'package:flame/flame.dart'; // Access to Flame's audio

class Fly {
  final LangawGame game;

  /// Here we are using Rect simply to remember x, y, width, height values
  /// We could use 4 doubles, or Dart's Size/Offset, or math's Point or
  /// Flame's Position but these only hold two values so we would still need
  /// two variables.
  /// Rect instances are immutable, but we can use the shift and translate
  /// methods
  Rect flyRect; // The "hit" rectangle
  bool isDead = false;
  bool isOffScreen = false;
  Callout callout; // Timeout for fly

  // Fly sizes
  double get kAgileFlySize => game.tileSize;
  double get kDroolerlySize => game.tileSize;
  double get kHouseFlySize => game.tileSize;
  double get kHungryFlySize => game.tileSize * 1.1;
  double get kMachoFlySize => game.tileSize * 1.35;

  /// The sprite variables will not be initialized in this class as each sub-class
  /// will use a different sprite
  List<Sprite> flyingSprite; // The list of sprites for an active fly
  Sprite deadSprite; // The dead fly sprite
  double flyingSpriteIndex = 0; // Index to fly animation sprite list

  /// Add a property called speed. A property is just another name for an
  /// instance variable. We’ll be creating a property by defining a getter.
  double get speed => game.tileSize * 3; // Flight speed
  Offset targetLocation; // The flight direction

  /// Now that we have flies and that they’re animated, you’ll notice that the
  /// one fly per tile sizing is no longer feasible. That’s because that was a
  /// proof-of-concept rule to explain the screen dimensions, aspect ratios,
  /// sizing, and tiling system.
  ///
  /// We need to adjust the size so that the flies themselves have a consistent
  /// feel and sizes.

  Fly(this.game) {
    setTargetLocation();
    callout = Callout(this);
  }

  void render(Canvas c) {
//    c.drawRect(
//        flyRect.inflate(flyRect.width / 2), Paint()..color = Color(0x77ffffff));

    if (isDead) {
      deadSprite.renderRect(c, flyRect..inflate(flyRect.width / 2));
    } else {
      // The first item in flyingSprite List is rendered in a rectangle larger
      // the size of flyRect (inflate adds a value to each Rect dimension
      flyingSprite[flyingSpriteIndex.toInt()]
          .renderRect(c, flyRect.inflate(flyRect.width / 2));
      if (game.activeView == View.playing) {
        callout.render(c);
      }
    }
//    c.drawRect(flyRect, Paint()..color = Color(0x88000000));
  }

  /// The update method is for all the code that changes anything in the game
  /// that is not triggered by player input
  /// dT comes from Flame's Game Loop via the call from LangawGame.update
  void update(double t) {
    if (isDead) {
      flyRect = flyRect.translate(0, game.tileSize * 12 * t);

      /// When a fly drops, it keeps dropping (adding value to its Y
      /// coordinate) for all eternity
      // Check if this instance’s rectangle’s top is greater than the screen
      // height
      if (flyRect.top > game.screenSize.height) {
        isOffScreen = true;
      }
    } else {
      /// We are trying to achieve 15 flaps per second.
      /// At 30 fps dT will be approx 33.3 ms (dT has microsecond precision)
      /// flyingSpriteIndex will change by 30 * 33.3 = 1, so the index will
      /// change every frame.
      /// At 60 fps dT will be approx 16.7 ms (dT has microsecond precision)
      /// flyingSpriteIndex will change by 30 * 16.7 = 0.5, so the index will
      /// change every second frame... which results in the same flap rate.
      /// Once we reach a value of 2 we subtract 2 (since there are only 2
      /// sprites)
      /// flyingSpriteIndex is converted to an integer in the render method
      /// above so results in an integer 0 or 1 to index the sprite list
      /// flyingSprite.
      flyingSpriteIndex += 30 * t;
      // Skipped frames can cause large values of t.
      // Subtract 2 until it is valid again
      while (flyingSpriteIndex >= 2) {
        flyingSpriteIndex -= 2;
      }
      // Move the fly towards the target
      // If the target is reached, get a new target
      double stepDistance = speed * t;
      Offset toTarget = targetLocation - Offset(flyRect.left, flyRect.top);
      if (stepDistance < toTarget.distance) {
        /// To move the fly, we create a new Offset using the fromDirection
        /// factory
        Offset stepToTarget =
            Offset.fromDirection(toTarget.direction, stepDistance);
        flyRect = flyRect.shift(stepToTarget);
      } else {
        flyRect = flyRect.shift(toTarget);
        setTargetLocation();
      }
      callout.update(t);
    }
  }

  void onTapDown() {
    isDead = true;
    if (game.soundButton.isEnabled) {
      Flame.audio
          .play('sfx/ouch' + (game.rnd.nextInt(11) + 1).toString() + '.ogg');
    }

    if (game.activeView == View.playing) {
      game.score += 1;
      if (game.score > (game.storage.getInt('highscore') ?? 0)) {
        game.storage.setInt('highscore', game.score);
        game.highscoreDisplay.updateHighscore();
      }
    }
  }

  void setTargetLocation() {
    // Implement a no-fly zone at the top of the screen so that the sound
    // controls are always available
    // Subtract the largest fly (1.35 tiles) from the screen width
    // Do the same for the height but also account for the controls (1.5
    // tiles), then move the area down 1.5 tiles
    double x = game.rnd.nextDouble() *
        (game.screenSize.width - (game.tileSize * 1.35));
    double y = (game.rnd.nextDouble() *
            (game.screenSize.height - (game.tileSize * 2.85))) +
        (game.tileSize * 1.5);

    targetLocation = Offset(x, y);
  }
}
