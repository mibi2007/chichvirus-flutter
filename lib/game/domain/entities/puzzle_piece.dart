import 'package:chichvirus/game/app/behaviors/movement_behavior.dart';
import 'package:chichvirus/game/app/behaviors/puzzle/puzzle_behaviors.dart';
import 'package:chichvirus/game/view/assets/mini_sprite_assets.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_behaviors/flame_behaviors.dart';
import 'package:flame_mini_sprite/flame_mini_sprite.dart';
import 'package:flutter/material.dart';
import 'package:mini_sprite/mini_sprite.dart';

class Piece {
  final List<bool> shape;
  final List<bool> shieldPositions;
  final Anchor anchor;

  Piece({required this.shape, required this.shieldPositions, required this.anchor});
}

class PuzzlePiece extends Entity with HasPaint, HasGameRef {
  final int id;
  late Sprite sprite;
  final Piece piece;
  late ShapeHitbox emptyBox;
  final List<Vector2> emptyBoxRelation;
  final Function actionCallback;

  PuzzlePiece({
    required this.id,
    required this.piece,
    super.position,
    super.size,
    required this.sprite,
    required this.emptyBoxRelation,
    required this.actionCallback,
  }) : super(anchor: Anchor.center, behaviors: [
          MovementBehavior(velocity: Vector2.zero()),
          DraggingBehavior(),
          RotationBehavior(),
          // TODO: Win()
        ]) {
    print("PuzzlePiece was created");
  }

  bool isDropped = false;

  @override
  Future<void> onLoad() async {
    const dimension = 500;
    final ratio = (dimension / 2) / (sprite.srcSize.x > sprite.srcSize.y ? sprite.srcSize.x : sprite.srcSize.y);
    final puzzle = SpriteComponent(
      sprite: sprite,
      position: Vector2(0, 0),
      anchor: const Anchor(0, 0),
      scale: Vector2.all(ratio),
    );
    final sizi = sprite.srcSize * ratio;
    size = sprite.srcSize * ratio;
    await add(puzzle);

    final shieldSprite =
        await (MiniLibrary.fromDataString(GameAssets.shield)).toSprites(pixelSize: 1, color: Colors.white);
    final shieldAsset = shieldSprite['shield'];
    piece.shieldPositions.asMap().forEach((index, hasShield) {
      if (hasShield) {
        final x = index % 2;
        final y = index > 1 ? 1 : 0;
        final antiVirus = SpriteComponent(
          sprite: shieldAsset,
          position: Vector2((dimension / 4) * x + (dimension / 8), (dimension / 4) * y + (dimension / 8)),
          anchor: const Anchor(0.5, 0.5),
          scale: Vector2.all(ratio),
        );
        add(antiVirus);
      }
    });
    final relation = [Vector2(1, 0), Vector2(0, -1), Vector2(-1, 0), Vector2(0, 1)];
    emptyBox = PolygonHitbox.relative(emptyBoxRelation, parentSize: sizi);
    emptyBox.paint
      ..color = Colors.red
      ..strokeWidth = 9;
    add(emptyBox);

    await super.onLoad();
  }

  // @override
  // void render(Canvas canvas) {
  //   final center = size / 2;
  //   canvas.drawCircle(center.toOffset(), min(size.x, size.y) / 2, paint);
  // }
}

// Vector2 _getShieldPosition(Piece piece){
//   final x = piece.shieldPositions[0] ||piece.shieldPositions[2]
// }
class PiecesRenderObject {
  PiecesRenderObject._();
  static late List<Sprite> pieceSprites;

  static Future<void> initialize() async {
    final pieceSpritesListMap = (await Future.wait<Map<String, Sprite>>(GameAssets.pieces.map((piece) async {
      final miniLibrary = MiniLibrary.fromDataString(piece);
      return miniLibrary.toSprites(
        color: Colors.white,
        pixelSize: 1,
      );
    })));
    pieceSprites =
        Map.fromIterables(pieceSpritesListMap.map((e) => e.keys.first), pieceSpritesListMap.map((e) => e.values.first))
            .values
            .toList();
  }

  static final List<Piece> pieces = [
    Piece(
        shape: [true, false, true, false],
        shieldPositions: [true, false, false, false],
        anchor: const Anchor(-0.25, 0)),
    Piece(shape: [true, true, true, false], shieldPositions: [true, false, false, false], anchor: const Anchor(0, 0)),
    Piece(shape: [false, true, true, true], shieldPositions: [false, true, false, false], anchor: const Anchor(0, 0)),
    Piece(shape: [true, false, true, true], shieldPositions: [true, false, false, false], anchor: const Anchor(0, 0)),
    Piece(
        shape: [true, true, false, false],
        shieldPositions: [false, false, false, false],
        anchor: const Anchor(0, -0.25)),
    Piece(shape: [false, true, true, true], shieldPositions: [false, true, true, false], anchor: const Anchor(0, 0)),
  ];
  static final List<List<Vector2>> emptyBoxRelations = [
    [Vector2.zero(), Vector2.zero(), Vector2.zero()],
    [Vector2.zero(), Vector2(0, 1), Vector2(1, 1), Vector2(1, 0)],
    [Vector2(-1, -1), Vector2(-1, 0), Vector2.zero(), Vector2(0, -1)],
    [Vector2(0, -1), Vector2.zero(), Vector2(1, 0), Vector2(1, -1)],
    [Vector2.zero(), Vector2.zero(), Vector2.zero()],
    [Vector2(-1, -1), Vector2(-1, 0), Vector2.zero(), Vector2(0, -1)],
  ];

  static getPieceSprites() async {}
}
    // final List<PuzzlePiece> puzzles = [];

    
    