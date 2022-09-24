import 'package:chichvirus/auth/app/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class LogoutScreen extends ConsumerWidget {
  const LogoutScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authNotifier = ref.read(authNotifierProvider.notifier);
    authNotifier.signOut();
    Future.delayed(const Duration(seconds: 2)).then((value) => context.go('/login'));
    // ref.listen<AuthState>(authNotifierProvider, (previous, next) {
    //   if (previous!.status != next.status && next.status == AuthStatus.unAuthenticated) {}
    // });
    return const Scaffold(
      body: Center(
        child: Text('Loging out...'),
      ),
    );
  }
}
