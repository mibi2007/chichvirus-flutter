import 'package:chichvirus/game/domain/entities/virus.dart';
import 'package:flame_behaviors/flame_behaviors.dart';

class VirusWinBehavior extends Behavior<Virus> {
  void win() {
    print('Ho ho ho');
  }
}
