import 'dart:math' as math;

import 'package:chichvirus/game/app/game_match/game_match_stats_bloc.dart';
import 'package:chichvirus/game/domain/entities/puzzle_piece.dart';
import 'package:chichvirus/game/view/assets/mini_sprite_assets.dart';
import 'package:chichvirus/game/view/components/board.dart';
import 'package:chichvirus/game/view/components/button.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flame_mini_sprite/flame_mini_sprite.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mini_sprite/mini_sprite.dart';

class ChichVirusGameMatch extends FlameGame with HasTappables, HasDraggables {
  final String matchId;
  static final paint = Paint()
    ..color = Colors.white
    ..style = PaintingStyle.fill;

  late Sprite startButtonAsset;
  final GameMatchStatsBloc statsBloc;
  final WidgetRef ref;

  // @override
  // bool debugMode = true;

  ChichVirusGameMatch(this.matchId, {required this.ref, required this.statsBloc});

  @override
  Future<void> onLoad() async {
    final buttonSprite =
        await (MiniLibrary.fromDataString(GameAssets.button)).toSprites(pixelSize: 1, color: Colors.black);
    startButtonAsset = buttonSprite['start']!;
    await add(
      FlameMultiBlocProvider(
        providers: [
          FlameBlocProvider<GameMatchStatsBloc, GameMatchStatsState>.value(
            value: statsBloc,
          ),
        ],
        children: [
          Board(),
          // GameMatchStatsController(position: Vector2(-75, -400), levelChangeCallback: renderPieces),
        ],
      ),
    );

    final buttonSpriteWhite =
        await (MiniLibrary.fromDataString(GameAssets.button)).toSprites(pixelSize: 1, color: Colors.white);
    addAll([
      MiniSpriteButton('Menu', onPressed: () {
        openMenu();
      }, position: Vector2(-75, -400), size: Vector2(150, 50), sprite: buttonSpriteWhite['start']),
      FpsTextComponent(position: Vector2(0, size.y - 24))
    ]);
    renderPieces();

    if (size.x > size.y) {
      camera.viewport = FixedResolutionViewport(Vector2(2000, 1000));
    } else {
      camera.viewport = FixedResolutionViewport(Vector2(1000, 2000));
    }

    camera.followVector2(Vector2.zero());

    start();
  }

  void openMenu() {
    overlays.add('menu');
  }

  void start() {
    overlays.remove('menu');
    // statsBloc.add(const GameEventPause(false));
  }

  void nextLevel() {}

  void renderPieces() {
    removeAll(children.whereType<PuzzlePiece>());
    final dimension = size.x > size.y ? size.y / 2 : size.x / 2;
    if (size.x > size.y) {
      final leftOffsetY = -dimension - 100;
      final rightOffsetY = dimension + 100;
      const margin = 300.0;
      PiecesRenderObject.pieces.asMap().forEach((index, piece) {
        final sprite = PiecesRenderObject.pieceSprites[index];
        final emptyBoxRelation = PiecesRenderObject.emptyBoxRelations[index];
        if (index < PiecesRenderObject.pieces.length / 2) {
          final puzzle = PuzzlePiece(
            id: index,
            piece: piece,
            sprite: sprite,
            position: Vector2(leftOffsetY, margin * (index - 1)),
            emptyBoxRelation: emptyBoxRelation,
            actionCallback: () {
              saveProgress();
            },
          );
          add(puzzle);
        } else {
          final puzzle = PuzzlePiece(
            id: index,
            piece: piece,
            sprite: sprite,
            position: Vector2(rightOffsetY, margin * (index - 4)),
            emptyBoxRelation: emptyBoxRelation,
            actionCallback: () {
              saveProgress();
            },
          );
          add(puzzle);
        }
      });
    } else {
      final topOffsetX = -dimension - 200;
      final bottomOffsetX = dimension + 200;
      const margin = 300.0;
      PiecesRenderObject.pieces.asMap().forEach((index, piece) {
        final sprite = PiecesRenderObject.pieceSprites[index];
        final emptyBoxRelation = PiecesRenderObject.emptyBoxRelations[index];
        if (index < PiecesRenderObject.pieces.length / 2) {
          final puzzle = PuzzlePiece(
            id: index,
            piece: piece,
            sprite: sprite,
            position: Vector2(margin * (index - 1), topOffsetX),
            emptyBoxRelation: emptyBoxRelation,
            actionCallback: () {
              saveProgress();
            },
          );
          add(puzzle);
        } else {
          final puzzle = PuzzlePiece(
            id: index,
            piece: piece,
            sprite: sprite,
            position: Vector2(margin * (index - 4), bottomOffsetX),
            emptyBoxRelation: emptyBoxRelation,
            actionCallback: () {
              saveProgress();
            },
          );
          add(puzzle);
        }
      });
    }
  }

  void saveProgress() {
    final solutionList = children.whereType<PuzzlePiece>().where((e) => e.isDropped).map((e) {
      final angle = (e.angle * 2 / math.pi).round();
      final Vector2 topLeftPosition = angle == 0
          ? e.topLeftPosition
          : angle == 1
              ? e.topLeftPosition - Vector2(e.height, 0)
              : angle == 2
                  ? e.topLeftPosition - Vector2(e.width, e.height)
                  : e.topLeftPosition - Vector2(0, e.width);

      final topLeft = (topLeftPosition + Vector2.all(250)) / 125;
      return MapEntry(e.id.toString(), [topLeft.x.round(), topLeft.y.round(), (e.angle * 2 / math.pi).round()]);
    }).toList();
    final solution = Map.fromEntries(solutionList);
    statsBloc.add(GameEventProgress(solution));
  }
}
