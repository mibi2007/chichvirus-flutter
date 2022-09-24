// import 'dart:async';

// import 'package:mini_sprite/mini_sprite.dart';

import 'package:chichvirus/game/app/game_match/game_match_stats_bloc.dart';
import 'package:chichvirus/game/view/components/game_match_menu.dart';
import 'package:chichvirus/game/view/components/lose_dialog.dart';
import 'package:chichvirus/game/view/components/win_dialog.dart';
import 'package:chichvirus/game/view/game_match.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
// import 'package:chichvirus/game/app/single_game_level/game_stats_bloc.dart';
// import 'package:chichvirus/game/domain/entities/puzzle_piece.dart';
// import 'package:chichvirus/game/view/components/single_game_menu.dart';
// import 'package:chichvirus/game/view/assets/mini_sprite_assets.dart';
// import 'package:chichvirus/game/view/components/board.dart';
// import 'package:chichvirus/game/view/game_match.dart';
// import 'package:flame/components.dart';
// import 'package:flame/game.dart';
// import 'package:flame_bloc/flame_bloc.dart';
// import 'package:flame_mini_sprite/flame_mini_sprite.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class GameMatchPage extends StatelessWidget {
  final String matchId;
  const GameMatchPage({super.key, required this.matchId});

  @override
  Widget build(BuildContext context) {
    print("build GameMatchPage");
    return Scaffold(
        appBar: AppBar(title: Text(matchId)),
        body: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  MultiBlocProvider(
                    providers: [
                      BlocProvider<GameMatchStatsBloc>(
                        create: (_) => GameMatchStatsBloc(matchId: matchId),
                      )
                    ],
                    child: BlocListener<GameMatchStatsBloc, GameMatchStatsState>(
                      listener: (context, state) {
                        if (state.winOrLose.isSome() && state.winOrLose.getOrElse(() => false) == true) {
                          showWinDialog(context, callback: () {
                            context.go('/');
                          });
                        }
                        if (state.winOrLose.isSome() && state.winOrLose.getOrElse(() => false) == false) {
                          showLoseDialog(context, callback: () {
                            context.go('/');
                          });
                        }
                      },
                      child: Positioned.fill(child: GameMatchWidget(matchId)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}

class GameMatchWidget extends ConsumerWidget {
  final String matchId;
  const GameMatchWidget(this.matchId, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print("build GameMatchWidget");
    return GameWidget<ChichVirusGameMatch>(
      game: ChichVirusGameMatch(
        matchId,
        statsBloc: context.read<GameMatchStatsBloc>()..add(const GameEventInitMatch()),
        ref: ref,
      ),
      overlayBuilderMap: {
        'menu': (_, game) => GameMatchMenu(game, ref: ref),
      },
      initialActiveOverlays: const ['menu'],
    );
  }
}
