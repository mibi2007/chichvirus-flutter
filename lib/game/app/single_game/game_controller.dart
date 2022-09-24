import 'package:chichvirus/game/app/single_game/game_stats_bloc.dart';
import 'package:chichvirus/game/view/assets/mini_sprite_assets.dart';
import 'package:chichvirus/game/view/single_game.dart';
import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flame_mini_sprite/flame_mini_sprite.dart';
import 'package:flutter/material.dart';
import 'package:mini_sprite/mini_sprite.dart';

class SingleGameStatsController extends Component with HasGameRef<ChichVirusSingleGame> {
  final Vector2 position;
  final Function levelChangeCallback;
  SingleGameStatsController({required this.position, required this.levelChangeCallback});
  int level = 0;
  List<Map<String, List<int>>> progress = [{}];
  List<int> currentSolution = [];

  @override
  Future<void>? onLoad() async {
    final buttonSprite =
        await (MiniLibrary.fromDataString(GameAssets.button)).toSprites(pixelSize: 1, color: Colors.white);
    add(
      FlameBlocListener<SingleGameStatsBloc, SingleGameStatsState>(
        listenWhen: (previousState, newState) {
          return previousState.status == newState.status && newState.status != GameStatus.pause;
        },
        onNewState: (state) {
          level = state.level;
          for (final child in children.whereType<LevelButton>()) {
            child.label = 'Level: ${state.level}';
          }
          levelChangeCallback();
        },
      ),
    );
    add(LevelButton(
        size: Vector2(150, 50),
        sprite: buttonSprite['start'],
        position: position,
        onPressed: () {
          gameRef.statsBloc.add(const GameEventLevel());
        })
      ..label = 'New Game');
  }
}

class LevelButton extends SpriteComponent with Tappable {
  final Function onPressed;
  String label = '';
  set setLabel(String text) => label = text;
  LevelButton({required this.onPressed, required super.sprite, required super.position, required super.size}) : super();

  @override
  Future<void>? onLoad() async {
    add(TextComponent(text: label, position: Vector2(75, 25), anchor: const Anchor(0.5, 0.5)));
  }

  @override
  bool onTapUp(info) {
    onPressed();
    return true;
  }
}
