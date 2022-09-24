import 'package:chichvirus/auth/data/auth_service.dart' as auth_service;
import 'package:chichvirus/game/data/game_service.dart' as game_service;
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';

part 'game_match_stats_event.dart';
part 'game_match_stats_state.dart';

class GameMatchStatsBloc extends Bloc<GameMatchStatsEvent, GameMatchStatsState> {
  final String matchId;

  GameMatchStatsBloc({required this.matchId}) : super(const GameMatchStatsState.initial()) {
    on<GameEventInitMatch>((event, emit) async {
      emit(const GameMatchStatsState.initial());
      final map = await game_service.getMapOfMatch(matchId);
      // print("map: $map");
      // print(state);
      emit(GameMatchStatsState.loaded(map));
      print("<GameEventInitMatch>");
    });
    on<GameEventProgress>((event, emit) async {
      final userId = await auth_service.getUid();
      final winOrLose = await game_service.updateUserMatchProgress(matchId, userId, event.currentSolution);
      emit(state.copyWith(winOrLose: winOrLose ? Some(winOrLose) : const None(), isDone: winOrLose));
    });
  }
}
