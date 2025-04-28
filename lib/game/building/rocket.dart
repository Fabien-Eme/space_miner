import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';

import '../../gen/assets.gen.dart';
import '../controller/production_controller.dart';
import '../game.dart';

class Rocket extends SpriteAnimationComponent with HasGameReference<FGJ2025> {
  Rocket({required super.position});

  double speed = 0.01;

  late final ComponentsNotifier<ProductionController> productionControllerNotifier;
  late final VoidCallback productionControllerListener;

  bool isProducing = true;

  @override
  FutureOr<void> onLoad() {
    anchor = Anchor.center;
    size = Vector2(64, 64);
    paint = Paint()..filterQuality = FilterQuality.none;
    animation = SpriteAnimation.variableSpriteList(
      [Sprite(game.images.fromCache(Assets.images.rocket.rocketButton.path))],
      stepTimes: [0.1 / speed],
    );

    animationTicker!.onFrame = (int index) {
      if (index == animation!.frames.length - 1) {}
    };

    return super.onLoad();
  }
}
