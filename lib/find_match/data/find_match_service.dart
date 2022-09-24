import 'package:firebase_database/firebase_database.dart';
import 'package:fpdart/fpdart.dart';

class FindMatchService {
  static Future<Unit> startFinding(String userId) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("finding/$userId");
    await ref.set("");
    return unit;
  }

  static Stream<DatabaseEvent> watchUserMatch(String userId) {
    DatabaseReference ref = FirebaseDatabase.instance.ref("finding/$userId");
    return ref.onValue;
  }
}
