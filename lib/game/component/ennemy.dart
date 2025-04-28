import 'dart:async';
import 'dart:math';

import 'dart:ui';

import 'package:flame/components.dart';

import '../../gen/assets.gen.dart';
import '../game.dart';
import '../level/level_world.dart';

class Ennemy extends SpriteComponent with HasGameReference<FGJ2025> {
  Ennemy({required super.position, super.priority});

  late Vector2 targetPosition;
  double speed = 5;

  bool isAimedByBullet = false;

  @override
  FutureOr<void> onLoad() {
    targetPosition = Vector2(levelWorld.rocketPadPosition.x, 0);

    position.x = Random().nextDouble() * FGJ2025.gameWidth - FGJ2025.gameWidth / 2;
    speed += Random().nextDouble() * 10;

    anchor = Anchor.center;
    size = Vector2(32, 32);
    paint = Paint()..filterQuality = FilterQuality.none;
    sprite = Sprite(game.images.fromCache(Assets.images.ennemy.ennemy.path));

    return super.onLoad();
  }

  void aimByBullet() {
    isAimedByBullet = true;
  }

  double fireRate = 1;
  double accumulatedTime = 0;

  @override
  void update(double dt) {
    if (position.distanceTo(targetPosition) > 5) {
      final direction = targetPosition - position;
      direction.normalize();
      position += direction * speed * dt;
    } else {
      accumulatedTime += dt;
      if (accumulatedTime >= fireRate) {
        game.combatController.fireEnemyBullet();
        accumulatedTime = 0;
      }
    }
    super.update(dt);
  }

  LevelWorld get levelWorld => game.findByKeyName('levelWorld') as LevelWorld;
}
