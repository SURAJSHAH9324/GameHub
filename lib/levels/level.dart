import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:pixel_adventure/actors/player.dart';

class Level extends World {
  final String levelName;
  Level({required this.levelName});
  late TiledComponent level;

  @override
  FutureOr<void> onLoad() async {
    level = await TiledComponent.load(
      '$levelName.tmx',
      Vector2.all(16),
    );
    add(level);

    final spwanPointsLayer = level.tileMap.getLayer<ObjectGroup>('spawnpoints');
    for (final spwanpoint in spwanPointsLayer!.objects) {
      switch (spwanpoint.class_) {
        case 'Player':
          final player = Player(
            character: 'Ninja Frog',
            position: Vector2(
              spwanpoint.x,
              spwanpoint.y,
            ),
          );
          add(player);
          break; // Add this break statement
        default:
      }
    }

    return super.onLoad();
  }
}
