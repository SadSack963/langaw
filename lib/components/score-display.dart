import 'dart:ui';
import 'package:flutter/painting.dart';
import 'package:langaw/langaw-game.dart';

class ScoreDisplay {
  final LangawGame game;
  TextPainter painter; // Used to render the value of the score on the screen
  TextStyle textStyle; // The styles that will control how the score is rendered
  Offset position; // The Offset where the score will be painted on

  ScoreDisplay(this.game) {
    painter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    textStyle = TextStyle(
      color: Color(0xffffffff),
      fontSize: 90,
      shadows: <Shadow>[
        Shadow(
          blurRadius: 7,
          color: Color(0xff000000),
          offset: Offset(3, 3),
        ),
      ],
    );

    position = Offset.zero;
  }

  void render(Canvas c) {
    painter.paint(c, position);
  }

  void update(double t) {
    // This expression uses Dart’s null-aware operators.
    // The ?. operator checks if the object just before it is null, if it is,
    // immediately stop the whole expression and return null. We already know
    // that painter is initialized and not null so we don’t check it. We’re not
    // sure though if the text property of painter is null or not, so we use
    // this operator.
    // Another operator used is ??. This operator returns the left-hand side
    // expression if it’s not null, if it is, the operator returns the
    // right-hand side expression.

// TODO: text is deprecated
//  'text' is deprecated and shouldn't be used. InlineSpan does not innately
//  have text. Use TextSpan.text instead. This feature was deprecated after
//  v1.7.3.. */

    if ((painter.text?.text ?? '') != game.score.toString()) {
      painter.text = TextSpan(
        text: game.score.toString(),
        style: textStyle,
      );
      // The layout method is called so the TextPainter can calculate the
      // dimensions of the new text it was just assigned.
      painter.layout();

      position = Offset(
        (game.screenSize.width / 2) - (painter.width / 2),
        (game.screenSize.height * .25) - (painter.height / 2),
      );
    }
  }
}
