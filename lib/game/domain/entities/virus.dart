import 'package:flame/components.dart';
import 'package:flame_behaviors/flame_behaviors.dart';

class Virus extends Entity with HasPaint {
  Virus({super.position, super.size, required Sprite sprite})
      : super(
          anchor: Anchor.center,
          behaviors: [
            // TODO: Die()
            // TODO: Win()
          ],
        );
}
