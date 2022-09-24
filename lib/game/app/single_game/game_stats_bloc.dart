import 'package:chichvirus/game/data/game_service.dart' as game_service;
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'game_stats_event.dart';
part 'game_stats_state.dart';

class SingleGameStatsBloc extends Bloc<SingleGameStatsEvent, SingleGameStatsState> {
  SingleGameStatsBloc() : super(const SingleGameStatsState.initial()) {
    on<GameEventLevel>(
      (event, emit) async {
        final mapSprite = await game_service.getMap(state.level.toString());
        if (mapSprite == "") {
          final mapSpriteLv1 = await game_service.getMap("0");
          emit(
            state.copyWith(level: 1, mapSprite: mapSpriteLv1, isCorrect: false),
          );
          return;
        }
        final newLevel = state.level + 1;
        emit(
          state.copyWith(level: newLevel, mapSprite: mapSprite, isCorrect: false),
        );
      },
    );
    on<GameEventPause>(
      (event, emit) => emit(
        state.copyWith(status: event.isPause ? GameStatus.pause : GameStatus.play),
      ),
    );
    on<GameEventCheckSolution>((event, emit) async {
      final isCorrect = await game_service.checkSolution((state.level - 1).toString(), event.solution);
      emit(state.copyWith(isCorrect: isCorrect));
      emit(state.copyWith(isCorrect: false));
    });
  }
}
