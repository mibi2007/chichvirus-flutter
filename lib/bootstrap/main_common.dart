import 'package:chichvirus/auth/app/auth_provider.dart';
import 'package:chichvirus/auth/view/login_screen.dart';
import 'package:chichvirus/auth/view/logout_screen.dart';
import 'package:chichvirus/find_match/view/find_match.dart';
import 'package:chichvirus/firebase_options.dart';
import 'package:chichvirus/game/domain/entities/puzzle_piece.dart';
import 'package:chichvirus/game/game_match_page.dart';
import 'package:chichvirus/game/single_game_page.dart';
import 'package:chichvirus/helpers/config_reader.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flame/flame.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

Future<void> mainCommon(String env) async {
  print('setup game orientation');
  WidgetsFlutterBinding.ensureInitialized();
  Flame.device.fullScreen();
  Flame.device.setPortrait();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  if (kDebugMode) {
    try {
      // FirebaseDatabase.instance.useDatabaseEmulator('localhost', 9000);
      // FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }
  await ConfigReader.initialize(env);
  await PiecesRenderObject.initialize();
  runApp(ProviderScope(child: MyGame()));
}

class MyGame extends ConsumerWidget {
  MyGame({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authNotifier = ref.read(authNotifierProvider.notifier);
    authNotifier.onStateChanged();
    return MaterialApp.router(
      routerConfig: _router,
      title: 'ChichVirus Game',
    );
  }

  final GoRouter _router = GoRouter(
    routes: <GoRoute>[
      GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) {
          return const SingleGamePage();
        },
      ),
      GoRoute(
        path: '/match/:id',
        builder: (BuildContext context, GoRouterState state) {
          print("Call GameMatchPage");
          return GameMatchPage(matchId: state.params['id'] ?? '');
        },
      ),
      GoRoute(
        path: '/login',
        builder: (BuildContext context, GoRouterState state) {
          return const LoginScreen();
        },
      ),
      GoRoute(
        path: '/find-match',
        builder: (BuildContext context, GoRouterState state) {
          return const FindMatchScreen();
        },
      ),
      GoRoute(
        path: '/logout',
        builder: (BuildContext context, GoRouterState state) {
          return const LogoutScreen();
        },
      ),
    ],
  );
}

// void main() {
//   runApp(MultiBlocProvider(
//     providers: [
//       BlocProvider<GameStatsBloc>(create: (_) => GameStatsBloc()),
//     ],
//     child: GameWidget<ChichVirusGame>(
//       game: ChichVirusGame(
//         statsBloc: context.read<GameStatsBloc>(),
//       ),
//       overlayBuilderMap: {
//         'menu': (_, game) => Menu(game),
//       },
//       initialActiveOverlays: const ['menu'],
//     ),
//   ));
// }
