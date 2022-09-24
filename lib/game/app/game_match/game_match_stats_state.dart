part of 'game_match_stats_bloc.dart';

class GameMatchStatsState extends Equatable {
  final String mapSprite;
  final Option<bool> winOrLose;
  final bool isDone;

  const GameMatchStatsState({required this.mapSprite, required this.winOrLose, required this.isDone});

  @override
  List<Object?> get props => [mapSprite, winOrLose, isDone];

  const GameMatchStatsState.initial() : this(mapSprite: "", winOrLose: const None(), isDone: false);
  const GameMatchStatsState.loaded(String map) : this(mapSprite: map, winOrLose: const None(), isDone: false);

  GameMatchStatsState copyWith({
    String? mapSprite,
    Option<bool>? winOrLose,
    bool? isDone,
  }) =>
      GameMatchStatsState(mapSprite: mapSprite ?? '', winOrLose: winOrLose ?? const None(), isDone: false);
}
