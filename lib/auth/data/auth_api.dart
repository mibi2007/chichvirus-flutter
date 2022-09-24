import 'dart:async';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthApi {
  final Dio api = Dio();
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<UserCredential> signInEmailPassword({
    required String emailAddress,
    required String password,
  }) async {
    final response = await auth.signInWithEmailAndPassword(
      email: emailAddress,
      password: password,
    );
    return response;
  }

  signOut() async {
    await auth.signOut();
  }

  Stream<User?> authStateChanges() {
    return FirebaseAuth.instance.authStateChanges();
  }
}
