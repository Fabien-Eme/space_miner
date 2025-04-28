import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';

import '../../gen/assets.gen.dart';
import '../controller/audio_controller.dart';
import '../controller/building_controller.dart';
import '../controller/production_controller.dart';
import '../game.dart';

class Turret extends SpriteAnimationComponent with HasGameReference<FGJ2025> {
  Turret({required super.position});

  double speed = 0.3;

  late final ComponentsNotifier<ProductionController> productionControllerNotifier;
  late final VoidCallback productionControllerListener;

  bool isProducing = true;

  @override
  FutureOr<void> onLoad() {
    anchor = Anchor.center;
    size = Vector2(32, 32);
    paint = Paint()..filterQuality = FilterQuality.none;
    animation = SpriteAnimation.variableSpriteList(
      [
        Sprite(game.images.fromCache(Assets.images.turret.turret1.path)),
        Sprite(game.images.fromCache(Assets.images.turret.turret2.path)),
        Sprite(game.images.fromCache(Assets.images.turret.turret3.path)),
        Sprite(game.images.fromCache(Assets.images.turret.turret4.path)),
        Sprite(game.images.fromCache(Assets.images.turret.turret5.path)),
        Sprite(game.images.fromCache(Assets.images.turret.turret6.path)),
        Sprite(game.images.fromCache(Assets.images.turret.turret7.path)),
      ],
      stepTimes: [0.25 / speed, 0.1 / speed, 0.1 / speed, 0.1 / speed, 0.1 / speed, 0.1 / speed, 0.1 / speed],
    );

    animationTicker!.onFrame = (int index) async {
      if (index == animation!.frames.length - 1) {
        for (int i = 0; i < (game.buildingController.buildingBuilt[BuildingType.turret] ?? 0); i++) {
          if (game.combatController.fireBullet()) {
            game.audioController.playSound(SoundType.fireBullet);
            await Future.delayed(Duration(milliseconds: 100));
          }
        }
      }
    };

    return super.onLoad();
  }

  void switchProduction(bool isProducing) {
    this.isProducing = isProducing;
    if (isProducing) {
      animationTicker!.paused = false;
    } else {
      animationTicker!.reset();
      animationTicker!.paused = true;
    }
  }

  @override
  void onMount() {
    productionControllerNotifier = game.componentsNotifier<ProductionController>();
    productionControllerListener = () {
      switchProduction(game.productionController.mapAreBuildingProducing[BuildingType.turret] ?? false);
    };
    productionControllerNotifier.addListener(productionControllerListener);
    super.onMount();
  }

  @override
  void onRemove() {
    productionControllerNotifier.removeListener(productionControllerListener);
    super.onRemove();
  }
}
