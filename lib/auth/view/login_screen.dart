import 'package:chichvirus/auth/app/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class LoginScreen extends HookConsumerWidget {
  const LoginScreen({super.key});

  // var email;
  // var password;

  @override
  Widget build(context, ref) {
    final email = useState<String>('');
    final password = useState<String>('');
    return Scaffold(
      body: SafeArea(
          child: Center(
        child: SizedBox(
          width: 400,
          height: 400,
          child: Column(
            children: [
              const Text('player1@te.st / player2@te.st / player3@te.st'),
              TextField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Email',
                ),
                onChanged: (value) => email.value = value,
              ),
              const SizedBox(height: 20),
              const Text('111111'),
              TextField(
                  obscureText: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                  ),
                  onChanged: (value) => password.value = value,
                  onEditingComplete: () {
                    // print('$email $password');
                    ref
                        .read(authNotifierProvider.notifier)
                        .signIn(email.value, password.value)
                        .then((value) => context.go('/'));
                  }),
            ],
          ),
        ),
      )),
    );
  }
}
