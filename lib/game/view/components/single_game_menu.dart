import 'package:chichvirus/auth/app/auth_provider.dart';
import 'package:chichvirus/game/view/components/text_style.dart';
import 'package:chichvirus/game/view/single_game.dart';
import 'package:flame/game.dart';
import 'package:flame/widgets.dart';
import 'package:flutter/material.dart' hide Image, Gradient;
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SingleGameMenu extends StatelessWidget {
  const SingleGameMenu(this.game, {super.key, required this.ref});

  final ChichVirusSingleGame game;

  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    final textTheme = Theme.of(context).textTheme;
    return Material(
      color: Colors.transparent,
      child: Center(
        child: Wrap(
          children: [
            Column(
              children: [
                MenuCard(
                  children: [
                    Text(
                      'Chich Virus',
                      style: textTheme.headline1,
                    ),
                    const SizedBox(height: 20),
                    if (authState.status == AuthStatus.authenticated) ...[
                      Text(
                        'Press "Single Mode" to play alone or "Find Match" to play with the other players',
                        style: textTheme.headline5!.copyWith(fontFamily: 'Minecraft'),
                      ),
                      const SizedBox(height: 50),
                      SpriteButton(
                        sprite: game.startButtonAsset,
                        pressedSprite: game.startButtonAsset,
                        srcPosition: Vector2(5, 0),
                        srcSize: Vector2(38, 12),
                        pressedSrcPosition: Vector2(0, 20),
                        pressedSrcSize: Vector2(38, 14),
                        onPressed: game.start,
                        label: const Text(
                          'Single Mode',
                          style: defaultTextStyle,
                        ),
                        width: 300,
                        height: 100,
                      ),
                      const SizedBox(height: 50),
                      SpriteButton(
                        sprite: game.startButtonAsset,
                        pressedSprite: game.startButtonAsset,
                        srcPosition: Vector2(5, 0),
                        srcSize: Vector2(38, 12),
                        pressedSrcPosition: Vector2(0, 20),
                        pressedSrcSize: Vector2(38, 14),
                        onPressed: () => context.go('/find-match'),
                        // onPressed: () => context.go('/match/e87b6db3-79b8-4d0d-9c1b-62e6fabf4cc4'),
                        label: const Text(
                          'Find Match',
                          style: defaultTextStyle,
                        ),
                        width: 300,
                        height: 100,
                      ),
                      const SizedBox(height: 50),
                      TextButton(
                          onPressed: () => context.go('/logout'),
                          // onPressed: () async {
                          //   var response = await Dio().post('${ConfigReader.getApiServer()}/check_match', data: {
                          //     'matchId': '04a83e26-95f6-4204-8745-b761c7c2ae0c',
                          //     'userId': '6S6ZfKnQa4zGTQLJpDqwk9nlw0UA',
                          //   });
                          //   print(response.data.data);
                          //   if (response.data != null && response.data == 'CORRECT') {
                          //     print("OK");
                          //   }
                          // },
                          child: Text(
                            'Logout',
                            style: textTheme.headline5!.copyWith(fontFamily: 'Minecraft'),
                          )),
                    ],
                    if (authState.status != AuthStatus.authenticated) ...[
                      Text(
                        'Please login to start',
                        style: textTheme.headline5!.copyWith(fontFamily: 'Minecraft'),
                      ),
                      const SizedBox(height: 50),
                      SpriteButton(
                        sprite: game.startButtonAsset,
                        pressedSprite: game.startButtonAsset,
                        srcPosition: Vector2(5, 0),
                        srcSize: Vector2(38, 12),
                        pressedSrcPosition: Vector2(0, 20),
                        pressedSrcSize: Vector2(38, 14),
                        onPressed: () {
                          context.go('/login');
                        },
                        label: const Text(
                          'Login',
                          style: defaultTextStyle,
                        ),
                        width: 300,
                        height: 100,
                      ),
                    ],
                    const SizedBox(height: 50),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class MenuCard extends StatelessWidget {
  const MenuCard({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      // shadowColor: GameColors.green.color,
      elevation: 10,
      margin: const EdgeInsets.only(bottom: 20),
      child: Container(
        margin: const EdgeInsets.all(20),
        child: Column(
          children: children,
        ),
      ),
    );
  }
}
