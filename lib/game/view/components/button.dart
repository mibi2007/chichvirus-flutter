import 'package:flame/components.dart';

class MiniSpriteButton extends SpriteComponent with Tappable {
  final Function onPressed;
  final String label;
  MiniSpriteButton(this.label,
      {required this.onPressed, required super.sprite, required super.position, required super.size})
      : super();

  @override
  Future<void>? onLoad() async {
    add(TextComponent(text: label, position: Vector2(75, 25), anchor: const Anchor(0.5, 0.5)));
  }

  @override
  bool onTapUp(info) {
    onPressed();
    return true;
  }
}
