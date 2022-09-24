import 'package:chichvirus/game/app/behaviors/movement_behavior.dart';
import 'package:chichvirus/game/domain/entities/puzzle_piece.dart';
import 'package:flame/extensions.dart';
import 'package:flame_behaviors/flame_behaviors.dart';

class DraggingBehavior extends DraggableBehavior<PuzzlePiece> {
  MovementBehavior? movement;

  Vector2? originalVelocity;
  late Vector2 originalPosition;

  @override
  Future<void> onLoad() async {
    movement = parent.findBehavior<MovementBehavior>();
    originalPosition = Vector2(parent.center.x, parent.center.y);
  }

  @override
  bool onDragStart(DragStartInfo info) {
    originalVelocity = movement?.velocity.clone();
    movement?.velocity.setFrom(Vector2.zero());
    return false;
  }

  @override
  bool onDragCancel() {
    movement?.velocity.setFrom(originalVelocity ?? Vector2.zero());
    return false;
  }

  @override
  bool onDragEnd(DragEndInfo info) {
    movement?.velocity.setFrom(Vector2.zero());
    if (isInvalidDropZone()) {
      parent.position.setFrom(originalPosition);
      parent.isDropped = false;
    } else {
      final multiplierX = (parent.topLeftPosition.x / 125).round();
      final multiplierY = (parent.topLeftPosition.y / 125).round();
      final translateX = ((parent.topLeftPosition.x.abs() - multiplierX.abs() * 125 > 125 / 2)
              ? multiplierX < 0
                  ? (multiplierX - 1) * 125
                  : (multiplierX + 1) * 125
              : multiplierX * 125) -
          parent.topLeftPosition.x;
      final translateY = ((parent.topLeftPosition.y.abs() - multiplierY.abs() * 125 > 125 / 2)
              ? multiplierY < 0
                  ? (multiplierY - 1) * 125
                  : (multiplierY + 1) * 125
              : multiplierY * 125) -
          parent.topLeftPosition.y;
      parent.position.setFrom(Vector2(parent.center.x + translateX, parent.center.y + translateY));
      parent.isDropped = true;
    }
    parent.actionCallback();
    return false;
  }

  @override
  bool onDragUpdate(DragUpdateInfo info) {
    parent.position.add(info.delta.game);
    return false;
  }

  bool isInvalidDropZone() {
    final rect = parent.toRect();
    return rect.top < -312.5 || rect.bottom > 312.5 || rect.left < -312.5 || rect.right > 312.5;
  }

  @override
  bool containsPoint(Vector2 point) {
    if (parent.emptyBox.containsPoint(point)) return false;
    return super.containsPoint(point);
  }
}
