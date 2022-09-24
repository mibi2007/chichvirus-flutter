part of 'auth_provider.dart';

enum AuthStatus { initial, loading, authenticated, unAuthenticated }

class AuthState extends Equatable {
  final AuthStatus status;

  const AuthState(this.status);

  factory AuthState.initial() => const AuthState(AuthStatus.initial);
  factory AuthState.loading() => const AuthState(AuthStatus.loading);
  factory AuthState.authenticated() => const AuthState(AuthStatus.authenticated);
  factory AuthState.unAuthenticated() => const AuthState(AuthStatus.unAuthenticated);

  @override
  List<Object?> get props => [status];
}
