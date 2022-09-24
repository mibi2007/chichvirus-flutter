part of 'find_match_provider.dart';

class FindMatchState extends Equatable {
  final Option<String> matchId;
  final bool finding;
  final bool hasError;

  const FindMatchState({required this.matchId, required this.finding, required this.hasError});

  const FindMatchState.initial() : this(matchId: const None(), finding: false, hasError: false);
  const FindMatchState.finding() : this(matchId: const None(), finding: true, hasError: false);

  FindMatchState copyWith({
    Option<String>? matchId,
    bool? finding,
    bool? hasError,
  }) =>
      FindMatchState(matchId: matchId ?? const None(), finding: false, hasError: false);

  @override
  List<Object?> get props => [matchId, finding, hasError];
}
