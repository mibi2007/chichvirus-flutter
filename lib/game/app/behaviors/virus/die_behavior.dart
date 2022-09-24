import 'package:chichvirus/game/domain/entities/virus.dart';
import 'package:flame_behaviors/flame_behaviors.dart';

class VirusDieBehavior extends Behavior<Virus> {
  void die() {
    print('Die');
  }
}
