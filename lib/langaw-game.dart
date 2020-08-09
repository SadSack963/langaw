import 'dart:ui'; // Access to Canvas class
import 'package:flame/game.dart'; // Game Loop scaffolding
import 'package:flame/flame.dart'; //  Access to Flame util’s initialDimensions
import 'package:langaw/components/fly.dart';
import 'dart:math'; // Access to Random class
import 'package:flutter/gestures.dart'; // Access to user gestures
import 'package:langaw/components/backyard.dart'; // Access to Backyard class
import 'package:langaw/components/house-fly.dart';
import 'package:langaw/components/agile-fly.dart';
import 'package:langaw/components/drooler-fly.dart';
import 'package:langaw/components/hungry-fly.dart';
import 'package:langaw/components/macho-fly.dart';
import 'package:langaw/view.dart';
import 'package:langaw/views/home-view.dart';
import 'package:langaw/components/start-button.dart';
import 'package:langaw/views/lost-view.dart';
import 'package:langaw/controllers/spawner.dart';
import 'package:langaw/components/credits-button.dart';
import 'package:langaw/components/help-button.dart';
import 'package:langaw/views/help-view.dart';
import 'package:langaw/views/credits-view.dart';
import 'package:langaw/components/score-display.dart';
import 'package:shared_preferences/shared_preferences.dart'; // To save score
import 'package:langaw/components/highscore-display.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:langaw/components/music-button.dart';
import 'package:langaw/components/sound-button.dart';

class LangawGame extends Game {
  Size screenSize;
  double tileSize;
  List<Fly> flies;
  Random rnd;
  Backyard background;
  View activeView = View.home;
  HomeView homeView;
  StartButton startButton;
  LostView lostView;
  FlySpawner spawner;
  HelpButton helpButton;
  CreditsButton creditsButton;
  HelpView helpView;
  CreditsView creditsView;
  int score;
  ScoreDisplay scoreDisplay;
  HighscoreDisplay highscoreDisplay;
  AudioPlayer homeBGM;
  AudioPlayer playingBGM;
  double kVolumeHomeBGM = 0.5; // Default Home music volume
  double kVolumePlayingBGM = 0.1; // Default Playing music volume
  MusicButton musicButton;
  SoundButton soundButton;

  final SharedPreferences storage;

  LangawGame(this.storage) {
    initialize();
  }

  void initialize() async {
    flies = List<Fly>();
    rnd = Random();
    score = 0;

    // Flame util‘s initialDimensions function returns a Future<Size>
    resize(await Flame.util.initialDimensions());

    // We pass the current instance of LangawGame using the keyword this
    background = Backyard(this);

    homeView = HomeView(this);
    lostView = LostView(this);
    helpView = HelpView(this);
    creditsView = CreditsView(this);

    startButton = StartButton(this);
    helpButton = HelpButton(this);
    creditsButton = CreditsButton(this);
    musicButton = MusicButton(this);
    soundButton = SoundButton(this);

    scoreDisplay = ScoreDisplay(this);
    highscoreDisplay = HighscoreDisplay(this);

    spawner = FlySpawner(this);

    // Background music
    homeBGM =
        await Flame.audio.loopLongAudio('bgm/home.mp3', volume: kVolumeHomeBGM);
    homeBGM.pause();
    playingBGM = await Flame.audio
        .loopLongAudio('bgm/playing.mp3', volume: kVolumePlayingBGM);
    playingBGM.pause();

    playHomeBGM();
  }

  void render(Canvas canvas) {
    // Paint the background
    background.render(canvas);

    // Render sound control buttons
    musicButton.render(canvas);
    soundButton.render(canvas);

    // Paint high score
    highscoreDisplay.render(canvas);

    // Paint the score
    if (activeView == View.playing) scoreDisplay.render(canvas);

    // Render the flies
    flies.forEach((Fly fly) => fly.render(canvas));

    // Render views
    if (activeView == View.home) homeView.render(canvas);
    if (activeView == View.home || activeView == View.lost) {
      startButton.render(canvas);
      helpButton.render(canvas);
      creditsButton.render(canvas);
    }
    if (activeView == View.lost) lostView.render(canvas);
    if (activeView == View.help) helpView.render(canvas);
    if (activeView == View.credits) creditsView.render(canvas);
  }

  // The update method is for all the code that changes anything in the game
  // that is not triggered by player input
  void update(double t) {
    flies.forEach((Fly fly) => fly.update(t));

    // Destroy fly instances that are off-screen
    flies.removeWhere((Fly fly) => fly.isOffScreen);

    spawner.update(t);

    if (activeView == View.playing) scoreDisplay.update(t);
  }

  void resize(Size size) {
    screenSize = size;
    // tileSize is the space occupied by a fly.
    // The screen is defined to be 9 tiles wide
    tileSize = screenSize.width / 9;
  }

  void spawnFly() {
    // Spawn location
//    double x = rnd.nextDouble() * (screenSize.width - (tileSize * 2.025));
//    double y = rnd.nextDouble() * (screenSize.height - (tileSize * 2.025));

    // Implement a no-fly zone at the top of the screen so that the sound
    // controls are always available
    // Subtract the largest fly (1.35 tiles) from the screen width
    // Do the same for the height but also account for the controls (1.5
    // tiles), then move the area down 1.5 tiles
    double x = rnd.nextDouble() * (screenSize.width - (tileSize * 1.35));
    double y = (rnd.nextDouble() * (screenSize.height - (tileSize * 2.85))) +
        (tileSize * 1.5); //    flies.add(HouseFly(this, x, y));

    switch (rnd.nextInt(5)) {
      case 0:
        flies.add(HouseFly(this, x, y));
        break;
      case 1:
        flies.add(DroolerFly(this, x, y));
        break;
      case 2:
        flies.add(AgileFly(this, x, y));
        break;
      case 3:
        flies.add(MachoFly(this, x, y));
        break;
      case 4:
        flies.add(HungryFly(this, x, y));
        break;
    }
  }

  void onTapDown(TapDownDetails d) {
    bool isHandled = false;

    // start button
    if (!isHandled && startButton.rect.contains(d.globalPosition)) {
      if (activeView == View.home || activeView == View.lost) {
        startButton.onTapDown();
        isHandled = true;
      }
    }

    // help button
    if (!isHandled && helpButton.rect.contains(d.globalPosition)) {
      if (activeView == View.home || activeView == View.lost) {
        helpButton.onTapDown();
        isHandled = true;
      }
    }

    // credits button
    if (!isHandled && creditsButton.rect.contains(d.globalPosition)) {
      if (activeView == View.home || activeView == View.lost) {
        creditsButton.onTapDown();
        isHandled = true;
      }
    }

    // return home
    if (!isHandled) {
      if (activeView == View.help || activeView == View.credits) {
        activeView = View.home;
        isHandled = true;
      }
    }

    // music button
    if (!isHandled && musicButton.rect.contains(d.globalPosition)) {
      musicButton.onTapDown();
      isHandled = true;
    }

    // sound button
    if (!isHandled && soundButton.rect.contains(d.globalPosition)) {
      soundButton.onTapDown();
      isHandled = true;
    }

    // flies
    bool didHitAFly = false;

    // The Rect class has a method called contains which accepts an Offset as a
    // parameter, and returns true if the Offset is inside the bounds of
    // the Rect
    // The tap position is stored in a property called globalPosition which
    // is an Offset
    // So we can just pass the globalPosition property to the fly’s Rect
    // contains method and we’ll know if the tap hit the fly
    if (!isHandled) {
      flies.forEach(
        (Fly fly) {
          if (fly.flyRect.contains(d.globalPosition)) {
            fly.onTapDown();
            didHitAFly = true;
            isHandled = true;
          }
        },
      );
      if (activeView == View.playing && !didHitAFly) {
        if (soundButton.isEnabled) {
          Flame.audio
              .play('sfx/haha' + (rnd.nextInt(5) + 1).toString() + '.ogg');
        }
        playHomeBGM();
        activeView = View.lost;
      }
    }
  }

  // Start playing Home Background Music
  void playHomeBGM() {
    playingBGM.pause();
    playingBGM.seek(Duration.zero);
    homeBGM.resume();
  }

  // Start playing Playing Background Music
  void playPlayingBGM() {
    homeBGM.pause();
    homeBGM.seek(Duration.zero);
    playingBGM.resume();
  }
}
