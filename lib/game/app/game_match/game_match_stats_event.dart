part of 'game_match_stats_bloc.dart';

abstract class GameMatchStatsEvent extends Equatable {
  const GameMatchStatsEvent();
}

class GameEventInitMatch extends GameMatchStatsEvent {
  const GameEventInitMatch();
  @override
  List<Object?> get props => [];
}

class GameEventProgress extends GameMatchStatsEvent {
  final Map<String, List<int>> currentSolution;
  const GameEventProgress(this.currentSolution);

  @override
  List<Object?> get props => [currentSolution];
}
