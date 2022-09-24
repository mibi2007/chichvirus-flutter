part of 'game_stats_bloc.dart';

enum GameStatus {
  pause,
  play,
}

class SingleGameStatsState extends Equatable {
  final int level;
  final int steps;
  final GameStatus status;
  final String mapSprite;
  final bool isCorrect;

  const SingleGameStatsState({
    required this.level,
    required this.steps,
    required this.status,
    required this.mapSprite,
    required this.isCorrect,
  });

  const SingleGameStatsState.initial()
      : this(level: 0, steps: 0, status: GameStatus.pause, mapSprite: '', isCorrect: false);

  SingleGameStatsState copyWith({
    int? level,
    int? steps,
    GameStatus? status,
    String? mapSprite,
    bool? isCorrect,
  }) =>
      SingleGameStatsState(
        level: level ?? this.level,
        steps: steps ?? this.steps,
        status: status ?? this.status,
        mapSprite: mapSprite ?? this.mapSprite,
        isCorrect: isCorrect ?? false,
      );

  @override
  List<Object?> get props => [level, steps, status, isCorrect];
}
