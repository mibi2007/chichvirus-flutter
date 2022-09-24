import 'dart:async';

import 'package:chichvirus/game/app/game_match/game_match_stats_bloc.dart';
import 'package:chichvirus/game/app/single_game/game_stats_bloc.dart';
import 'package:chichvirus/game/view/assets/mini_sprite_assets.dart';
import 'package:chichvirus/game/view/game_match.dart';
import 'package:chichvirus/game/view/single_game.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flame_mini_sprite/flame_mini_sprite.dart';
import 'package:flutter/material.dart';
import 'package:mini_sprite/mini_sprite.dart';

class Board extends PositionComponent with HasGameRef {
  /// The stroke width of the field.
  static const strokWidth = 4.0;

  /// The half width of the field.
  // static const halfWidth = width / 2;

  /// The color of the field.
  static const backgroundColor = Color(0xFF363636);

  /// The rect used for drawing the middle line.
  static final _lineRect = Vector2.zero() & Vector2(strokWidth, strokWidth);

  static final _foregroundPaint = Paint()
    ..color = Colors.white
    ..strokeWidth = strokWidth
    ..isAntiAlias = false
    ..style = PaintingStyle.stroke;

  static final _backgroundPaint = Paint()
    ..color = backgroundColor
    ..isAntiAlias = false;

  static final _linePaint = Paint()
    ..color = Colors.white
    ..isAntiAlias = false;

  late List<Map<String, Sprite>> virusSpritesList;
  List<SpriteComponent> viruses = [];

  late Rect _gameRect;
  late Rect _boardRect;

  @override
  void onGameResize(Vector2 size) {
    final dimension = gameRef.size.x > gameRef.size.y ? gameRef.size.y / 2 : gameRef.size.x / 2;
    _gameRect = Vector2(-gameRef.size.x / 2, -gameRef.size.y / 2) & gameRef.size;
    _boardRect = Vector2(-dimension / 2, -dimension / 2) & Vector2(dimension, dimension);
    super.onGameResize(size);
  }

  @override
  void render(Canvas canvas) {
    canvas
      ..save()
      ..drawRect(_gameRect, _backgroundPaint);
    // ..translate(gameRef.size.x / 8 * 3 - _lineRect.width / 4, width);
    canvas..drawRect(_boardRect, _foregroundPaint);
    // ..translate(gameRef.size.x / 2 - _lineRect.width / 2, width);

    // for (var i = 0; i < _boardRect.size.toPoint().x; i++) {
    //   canvas
    //     ..drawLine(Offset(0, 0), _boardRect.size.toOffset(), _linePaint)
    //     ..translate(-100, width * 2);
    // }

    // Grid
    canvas.drawLine(
        Offset(_boardRect.left / 2, _boardRect.top), Offset(_boardRect.left / 2, _boardRect.bottom), _linePaint);
    canvas.drawLine(Offset(0, _boardRect.top), Offset(0, _boardRect.bottom), _linePaint);
    canvas.drawLine(
        Offset(-_boardRect.left / 2, _boardRect.top), Offset(-_boardRect.left / 2, _boardRect.bottom), _linePaint);

    canvas.drawLine(
        Offset(_boardRect.left, _boardRect.top / 2), Offset(_boardRect.right, _boardRect.top / 2), _linePaint);
    canvas.drawLine(Offset(_boardRect.left, 0), Offset(_boardRect.right, 0), _linePaint);
    canvas.drawLine(
        Offset(_boardRect.left, -_boardRect.top / 2), Offset(_boardRect.right, _boardRect.bottom / 2), _linePaint);

    canvas.restore();
  }

  @override
  Future<void>? onLoad() async {
    virusSpritesList = (await Future.wait<Map<String, Sprite>>(GameAssets.viruses.map((virus) async {
      final miniLibrary = MiniLibrary.fromDataString(virus);
      return miniLibrary.toSprites(
        color: Colors.white,
        pixelSize: 1,
      );
    })));
    final virusSprites =
        Map.fromIterables(virusSpritesList.map((e) => e.keys.first), virusSpritesList.map((e) => e.values.first));
    const dimension = 500.0;
    if (gameRef is ChichVirusSingleGame) {
      print("gameRef is ChichVirusSingleGame");
      add(
        FlameBlocListener<SingleGameStatsBloc, SingleGameStatsState>(
          listenWhen: (previousState, newState) {
            print("FlameBlocListener<SingleGameStatsBloc, SingleGameStatsState>");
            return newState.mapSprite.isNotEmpty;
          },
          onNewState: (state) {
            if (viruses.isNotEmpty) {
              removeAll(viruses);
              viruses = [];
            }
            // gameRef.removeWhere((element) => element is EnemyComponent);
            final map = MiniMap.fromDataString(state.mapSprite);
            for (final entry in map.objects.entries) {
              final sprite = virusSprites[entry.value['sprite']];
              if (sprite != null) {
                final size = (sprite.srcSize.x > sprite.srcSize.y ? sprite.srcSize.x : sprite.srcSize.y);
                final ratio = (dimension / 4) / size;
                viruses.add(SpriteComponent(
                  sprite: sprite,
                  position: Vector2(
                            entry.key.x * 1.0,
                            entry.key.y * 1.0,
                          ) *
                          dimension /
                          8 -
                      Vector2.all(dimension / 2),
                  size: Vector2(
                    sprite.image.width.toDouble(),
                    sprite.image.height.toDouble(),
                  ),
                  scale: Vector2.all(ratio),
                ));
              }
            }
            addAll(viruses);
          },
        ),
      );
    }
    if (gameRef is ChichVirusGameMatch) {
      print("gameRef is ChichVirusGameMatch");
      add(
        FlameBlocListener<GameMatchStatsBloc, GameMatchStatsState>(
          listenWhen: (previousState, newState) {
            print("FlameBlocListener<GameMatchStatsBloc, GameMatchStatsState>");
            return newState.mapSprite.isNotEmpty;
          },
          onNewState: (state) {
            if (state.mapSprite == "") return;
            if (viruses.isNotEmpty) {
              removeAll(viruses);
              viruses = [];
            }
            // gameRef.removeWhere((element) => element is EnemyComponent);
            final map = MiniMap.fromDataString(state.mapSprite);
            for (final entry in map.objects.entries) {
              final sprite = virusSprites[entry.value['sprite']];
              if (sprite != null) {
                final size = (sprite.srcSize.x > sprite.srcSize.y ? sprite.srcSize.x : sprite.srcSize.y);
                final ratio = (dimension / 4) / size;
                viruses.add(SpriteComponent(
                  sprite: sprite,
                  position: Vector2(
                            entry.key.x * 1.0,
                            entry.key.y * 1.0,
                          ) *
                          dimension /
                          8 -
                      Vector2.all(dimension / 2),
                  size: Vector2(
                    sprite.image.width.toDouble(),
                    sprite.image.height.toDouble(),
                  ),
                  scale: Vector2.all(ratio),
                ));
              }
            }
            addAll(viruses);
          },
        ),
      );
    }
  }
}
