import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:pixel_adventure/components/background_tile.dart';
import 'package:pixel_adventure/components/checkpoint.dart';
import 'package:pixel_adventure/components/collision.dart';
import 'package:pixel_adventure/components/fruit.dart';
import 'package:pixel_adventure/components/player.dart';
import 'package:pixel_adventure/components/saw.dart';
import 'package:pixel_adventure/pixel_adventure.dart';

class Level extends World with HasGameRef<PixelAdventure> {
  final String levelName;
  final Player player;
  Level({required this.levelName, required this.player});
  late TiledComponent level;
  List<CollisionBlock> collisionBlock = [];
  @override
  FutureOr<void> onLoad() async {
    level = await TiledComponent.load(
      '$levelName.tmx',
      Vector2.all(16),
    );
    add(level);

    _scrollingBackground();
    _spawningObjects();
    _addCollision();

    return super.onLoad();
  }

  void _scrollingBackground() {
    final backgroundLayer = level.tileMap.getLayer('Background');
    const tileSize = 64;
    final numsTilesY = (game.size.y / tileSize).floor();
    final numsTilesX = (game.size.x / tileSize).floor();
    if (backgroundLayer != null) {
      final backgroundColor =
          backgroundLayer.properties.getValue('BackgroundColor');

      for (double y = 0; y < game.size.y / numsTilesY; y++) {
        for (double x = 0; x < numsTilesX; x++) {
          final backgroundTile = BackgroundTile(
            color: backgroundColor ?? 'Gray',
            position: Vector2(x * tileSize, y * tileSize - tileSize),
          );
          add(backgroundTile);
        }
      }
    }
  }

  void _spawningObjects() {
    final spwanPointsLayer = level.tileMap.getLayer<ObjectGroup>('spawnpoints');
    if (spwanPointsLayer != null) {
      for (final spwanpoint in spwanPointsLayer.objects) {
        switch (spwanpoint.class_) {
          case 'Player':
            player.position = Vector2(
              spwanpoint.x,
              spwanpoint.y,
            );
            player.scale.x = 1;
            add(player);
            break;
          case 'Fruit':
            final fruit = Fruit(
              fruit: spwanpoint.name,
              position: Vector2(spwanpoint.x, spwanpoint.y),
              size: Vector2(spwanpoint.width, spwanpoint.height),
            );
            add(fruit);
            break;
          case 'Saw':
            final isVertical = spwanpoint.properties.getValue('isvertical');
            final offNeg = spwanpoint.properties.getValue('offNeg');
            final offPos = spwanpoint.properties.getValue('offPos');
            final saw = Saw(
              isVertical: isVertical,
              offNeg: offNeg,
              offPos: offPos,
              position: Vector2(spwanpoint.x, spwanpoint.y),
              size: Vector2(spwanpoint.width, spwanpoint.height),
            );
            add(saw);
            break;
          case 'Checkpoint':
            final checkpoint = Checkpoint(
              position: Vector2(spwanpoint.x, spwanpoint.y),
              size: Vector2(spwanpoint.width, spwanpoint.height),
            );
            add(checkpoint);
            break;

          default:
        }
      }
    }
  }

  void _addCollision() {
    final collisionlayer = level.tileMap.getLayer<ObjectGroup>('Collision');
    if (collisionlayer != null) {
      for (final collision in collisionlayer.objects) {
        switch (collision.class_) {
          case 'Platform':
            final platform = CollisionBlock(
              position: Vector2(
                collision.x,
                collision.y,
              ),
              size: Vector2(
                collision.width,
                collision.height,
              ),
              isPlatForm: true,
            );
            collisionBlock.add(platform);
            add(platform);
            break;
          default:
            final block = CollisionBlock(
              position: Vector2(
                collision.x,
                collision.y,
              ),
              size: Vector2(
                collision.width,
                collision.height,
              ),
            );
            collisionBlock.add(block);
            add(block);
        }
      }
    }
    player.collisionBlock = collisionBlock;
  }
}
