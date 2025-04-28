import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';

import '../../gen/assets.gen.dart';
import '../controller/audio_controller.dart';
import '../game.dart';
import 'ennemy.dart';

class TurretBullet extends SpriteComponent with HasGameReference<FGJ2025> {
  TurretBullet({required this.target, required super.position});

  Ennemy target;
  double speed = 100;

  @override
  FutureOr<void> onLoad() {
    anchor = Anchor.center;
    size = Vector2(8, 8);
    paint = Paint()..filterQuality = FilterQuality.none;
    sprite = Sprite(game.images.fromCache(Assets.images.turret.bullet.path));

    return super.onLoad();
  }

  @override
  void update(double dt) {
    if (position.distanceTo(target.position) > 5) {
      final direction = target.position - position;
      direction.normalize();
      position += direction * speed * dt;

      angle = atan2(direction.y, direction.x) + pi / 2;
    } else {
      removeFromParent();
      game.combatController.removeEnnemy(target);
      game.audioController.playSound(SoundType.ennemyDestroyed);
    }

    super.update(dt);
  }
}
