import 'dart:convert';

import 'package:chichvirus/helpers/config_reader.dart';
import 'package:dio/dio.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GameService {}

Future<String> getMap(String mapId) async {
  // Obtain shared preferences.
  final prefs = await SharedPreferences.getInstance();
  final maps = jsonDecode(prefs.getString('maps') ?? '{}');
  final solutions = jsonDecode(prefs.getString('solutions') ?? '{}');
  if (maps[mapId] != null) {
    return jsonDecode(prefs.getString('maps') ?? '{}')[mapId];
  }
  // final Dio api = Dio();
  // final response = await http.get(Uri.parse("http://localhost:5001/mibi-demo/us-central1/api/maps/0"));
  // final data = await http.get(Uri.parse('https://us-central1-mibi-demo.cloudfunctions.net/api/maps/0'));
  var response = await Dio().get('${ConfigReader.getApiServer()}/maps/$mapId');
  if (response.data['data'] == null) return "";
  maps[mapId] = response.data['data']['sprite'];
  solutions[mapId] = response.data['data']['solution'];
  prefs.setString('maps', jsonEncode(maps));
  prefs.setString('solutions', jsonEncode(solutions));
  return maps[mapId] as String;
}

Future<bool> updateUserMatchProgress(String matchId, String userId, Map<String, List<int>> currentSolution) async {
  final userMatchRef = FirebaseDatabase.instance.ref('matches/$matchId/progress');
  final currentProgressSnap = await userMatchRef.get();
  final List<dynamic> currentProgress = currentProgressSnap.value != null
      ? (currentProgressSnap.value as List<dynamic>)
      // .map((e) {
      //     print(e);
      //     final Map<String, List<int>> result = {};
      //     (e as List<dynamic>).map((ee) {
      //       print(ee);
      //       (ee as List<int>).map((eee) {
      //         print(eee);
      //         // return eee;
      //       });
      //     });
      //     return <int, List<int>>{};
      //   }).toList()
      : [false];
  currentProgress
      .add({'player': userId, 'solution': jsonEncode(currentSolution), 'time': DateTime.now().microsecondsSinceEpoch});
  userMatchRef.set(currentProgress);
  // userMatchRef.push().key;
  if (currentSolution.keys.length == 6) {
    var response = await Dio().post('${ConfigReader.getApiServer()}/check_match', data: {
      'matchId': matchId,
      'userId': userId,
    });
    print(response.data);
    if (response.data != null && response.data['data'] == 'CORRECT') {
      return true;
    }
  }
  return false;
}

Future<String> getMapOfMatch(String matchId) async {
  final mapRef = FirebaseDatabase.instance.ref('matches/$matchId/map/sprite');
  final map = (await mapRef.get()).value;
  if (map == null) return '';
  return map as String;
}

Future<bool> checkSolution(String mapId, Map<String, List<int>> solution) async {
  final prefs = await SharedPreferences.getInstance();
  final solutions = jsonDecode(prefs.getString('solutions') ?? '{}');
  return jsonEncode(solution) == jsonEncode(solutions[mapId]);
}
