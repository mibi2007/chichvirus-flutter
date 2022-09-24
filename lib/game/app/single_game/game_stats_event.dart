part of 'game_stats_bloc.dart';

abstract class SingleGameStatsEvent extends Equatable {
  const SingleGameStatsEvent();
}

class GameEventLevel extends SingleGameStatsEvent {
  const GameEventLevel();

  @override
  List<Object?> get props => [];
}

class GameEventPause extends SingleGameStatsEvent {
  final bool isPause;
  const GameEventPause(this.isPause);

  @override
  List<Object?> get props => [isPause];
}

class GameEventCheckSolution extends SingleGameStatsEvent {
  final Map<String, List<int>> solution;
  const GameEventCheckSolution({required this.solution});

  @override
  List<Object?> get props => [solution];
}
