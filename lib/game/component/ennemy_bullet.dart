import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';

import '../../gen/assets.gen.dart';
import '../game.dart';
import '../level/level_world.dart';

class EnnemyBullet extends SpriteComponent with HasGameReference<FGJ2025> {
  EnnemyBullet({required super.position});

  double speed = 100;

  late Vector2 targetPosition;

  @override
  FutureOr<void> onLoad() {
    targetPosition = levelWorld.rocketPadPosition;

    anchor = Anchor.center;
    size = Vector2(8, 8);
    paint = Paint()..filterQuality = FilterQuality.none;
    sprite = Sprite(game.images.fromCache(Assets.images.ennemy.bullet.path));

    return super.onLoad();
  }

  @override
  void update(double dt) {
    if (position.distanceTo(targetPosition) > 5) {
      final direction = targetPosition - position;
      direction.normalize();
      position += direction * speed * dt;

      angle = atan2(direction.y, direction.x) + pi / 2;
    } else {
      removeFromParent();
      game.combatController.damageRocketPad();
    }

    super.update(dt);
  }

  LevelWorld get levelWorld => game.findByKeyName('levelWorld') as LevelWorld;
}
