import 'package:flame/components.dart';

class CollisionBlock extends PositionComponent {
  bool isPlatForm;
  CollisionBlock({
    position,
    size,
    this.isPlatForm = false,
  }) : super(
          position: position,
          size: size,
        ) {
    // debugMode = true;
  }
}
