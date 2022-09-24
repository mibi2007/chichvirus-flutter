import 'dart:math';

import 'package:chichvirus/game/domain/entities/puzzle_piece.dart';
import 'package:flame/components.dart';
import 'package:flame_behaviors/flame_behaviors.dart';

class RotationBehavior extends Behavior<PuzzlePiece> with HasGameRef, Tappable {
  RotationBehavior();

  @override
  bool onTapUp(TapUpInfo info) {
    if (parent.emptyBox.containsPoint(info.eventPosition.game)) return true;
    parent.angle += pi / 2;
    parent.children.query<SpriteComponent>().forEach((element) {
      if (element.anchor == Anchor.center) element.angle -= pi / 2;
    });

    //Simplify the solution of 1x2 empty puzzle piece
    if (parent.piece.shieldPositions.every((hasShield) => hasShield == false)) {
      parent.angle = parent.angle % pi;
    } else {
      parent.angle = parent.angle % (2 * pi);
    }
    print(parent.angle * 180 / pi);
    parent.actionCallback();
    return true;
  }
}
