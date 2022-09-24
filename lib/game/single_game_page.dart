import 'package:chichvirus/game/app/single_game/game_stats_bloc.dart';
import 'package:chichvirus/game/view/components/single_game_menu.dart';
import 'package:chichvirus/game/view/components/win_dialog.dart';
import 'package:chichvirus/game/view/single_game.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SingleGamePage extends StatelessWidget {
  const SingleGamePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Stack(
            children: [
              Positioned.fill(
                child: MultiBlocProvider(
                  providers: [
                    BlocProvider<SingleGameStatsBloc>(
                      create: (_) => SingleGameStatsBloc(),
                    )
                  ],
                  child: BlocListener<SingleGameStatsBloc, SingleGameStatsState>(
                      listener: (context, state) {
                        if (state.isCorrect) showWinDialog(context);
                      },
                      child: const SingleGameWidget()),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class SingleGameWidget extends ConsumerWidget {
  const SingleGameWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GameWidget<ChichVirusSingleGame>(
      game: ChichVirusSingleGame(
        statsBloc: context.read<SingleGameStatsBloc>(),
        ref: ref,
      ),
      overlayBuilderMap: {
        'menu': (_, game) => SingleGameMenu(game, ref: ref),
      },
      initialActiveOverlays: const ['menu'],
    );
  }
}
