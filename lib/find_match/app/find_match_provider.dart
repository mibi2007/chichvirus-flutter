import 'dart:async';

import 'package:chichvirus/auth/data/auth_service.dart' as auth_service;
import 'package:chichvirus/find_match/data/find_match_service.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

part 'find_match_state.dart';

class FindMatchNotifier extends StateNotifier<FindMatchState> {
  FindMatchNotifier() : super(const FindMatchState.initial());

  StreamSubscription? _sub;

  Future<void> init() async {
    final uid = await auth_service.getUid();
    await FindMatchService.startFinding(uid);
    state = const FindMatchState.finding();
    final myStream = FindMatchService.watchUserMatch(uid);
    _sub = myStream.listen((event) {
      if (event.type == DatabaseEventType.value && event.snapshot.value != '') {
        state = state.copyWith(finding: false, matchId: Some(event.snapshot.value as String));
      }
    });
  }

  @override
  void dispose() async {
    if (_sub != null) await _sub!.cancel();
    super.dispose();
  }
}

final findMatchNotifierProvider = StateNotifierProvider.autoDispose<FindMatchNotifier, FindMatchState>(
  (ref) => FindMatchNotifier(),
);
