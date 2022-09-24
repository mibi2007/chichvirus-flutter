import 'dart:async';

import 'package:chichvirus/auth/data/auth_api.dart';
import 'package:chichvirus/auth/data/auth_service.dart' as auth_service;
import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

part 'auth_state.dart';

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthApi authApi;
  AuthNotifier._(this.authApi) : super(AuthState.initial());
  factory AuthNotifier(AuthApi authApi) => AuthNotifier._(authApi);

  StreamSubscription? _sub;

  Future<Unit> signIn(String email, String password) async {
    state = AuthState.loading();
    final response = await authApi.signInEmailPassword(emailAddress: email, password: password);
    print(response.user);
    if (response.user != null) {
      unawaited(auth_service.saveUid(response.user!.uid));
    }
    onStateChanged();
    return unit;
  }

  void onStateChanged() {
    state = AuthState.loading();
    _sub = authApi.authStateChanges().listen((event) {
      if (event != null) {
        state = AuthState.authenticated();
      } else {
        state = AuthState.unAuthenticated();
      }
    }, onError: (err) {
      print('Error');
      state = AuthState.unAuthenticated();
    });
  }

  Future<bool> isSignedIn() async {
    final isSignIn = await auth_service.getToken();
    return isSignIn.isNotEmpty;
  }

  Future<Unit> signOut() async {
    state = AuthState.loading();
    await auth_service.signOut().run(authApi);
    if (_sub != null) await _sub!.cancel();
    // onStateChanged();
    state = AuthState.unAuthenticated();
    return unit;
  }

  @override
  void dispose() async {
    if (_sub != null) await _sub!.cancel();
    super.dispose();
  }
}

final auth = Provider<AuthApi>(
  (ref) => AuthApi(),
);

final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) => AuthNotifier._(ref.read(auth)));
