import 'package:chichvirus/find_match/app/find_match_provider.dart';
import 'package:chichvirus/game/view/components/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class FindMatchScreen extends ConsumerWidget {
  const FindMatchScreen({super.key});

  @override
  Widget build(context, ref) {
    ref.read(findMatchNotifierProvider.notifier).init();
    ref.listen<FindMatchState>(findMatchNotifierProvider, (previous, next) {
      if (next.matchId.isSome()) {
        Future.delayed(const Duration(seconds: 2)).then((_) {
          context.go('/match/${next.matchId.getOrElse(() => '')}');
        });
      }
    });
    return const Scaffold(
      body: SafeArea(
          child: Center(
        child: SizedBox(
          width: 500,
          height: 400,
          child: FindMatchWidget(),
        ),
      )),
    );
  }
}

class FindMatchWidget extends HookConsumerWidget {
  const FindMatchWidget({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final findMatchState = ref.watch(findMatchNotifierProvider);

    return Column(
      children: [
        if (findMatchState.finding) const Text('Please wait for other player', style: defaultTextStyle),
        if (findMatchState.matchId.isSome())
          Text('Joining match id find ${findMatchState.matchId.getOrElse(() => '')}', style: defaultTextStyle)
      ],
    );
  }
}
