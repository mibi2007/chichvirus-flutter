import 'package:chichvirus/auth/data/auth_api.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<Option> saveToken(String token) async {
  final prefs = await SharedPreferences.getInstance();
  return await prefs.setString('token', token).then((value) => some(unit), onError: (error) => none());
}

Future<String> getToken() async {
  final prefs = await SharedPreferences.getInstance();
  return Future.value(prefs.getString('token') ?? '');
}

Future<Option> saveUid(String uid) async {
  final prefs = await SharedPreferences.getInstance();
  return await prefs.setString('uid', uid).then((value) => optionOf(value ? value : null));
}

Future<String> getUid() async {
  final prefs = await SharedPreferences.getInstance();
  return Future.value(prefs.getString('uid') ?? '');
}

Reader<AuthApi, Future<Either<String, UserCredential>>> signInEmailPassword(
    {required String emailAddress, required String password}) {
  return Reader(
    (api) => _signIn(emailAddress, password, api).run(),
  );
}

TaskEither<String, UserCredential> _signIn(
  String email,
  String password,
  AuthApi api,
) =>
    TaskEither.tryCatch(
      () => api.signInEmailPassword(emailAddress: email, password: password),
      (error, __) {
        if (error is String) return error;
        return "AuthFailure.serverError()";
      },
    );

Reader<AuthApi, Future<Either<String, Unit>>> signOut() {
  return Reader(
    (api) => _signOut(api).run(),
  );
}

TaskEither<String, Unit> _signOut(AuthApi api) => TaskEither.tryCatch(
      () => api.signOut(),
      (err, trace) {
        return "Error signout";
      },
    );
