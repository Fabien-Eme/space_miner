import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';

import '../../gen/assets.gen.dart';
import '../controller/building_controller.dart';
import '../controller/production_controller.dart';
import '../game.dart';

class Furnace extends SpriteAnimationComponent with HasGameReference<FGJ2025> {
  Furnace({required super.position});

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
        Sprite(game.images.fromCache(Assets.images.furnace.furnace1.path)),
        Sprite(game.images.fromCache(Assets.images.furnace.furnace2.path)),
        Sprite(game.images.fromCache(Assets.images.furnace.furnace3.path)),
        Sprite(game.images.fromCache(Assets.images.furnace.furnace4.path)),
        Sprite(game.images.fromCache(Assets.images.furnace.furnace5.path)),
        Sprite(game.images.fromCache(Assets.images.furnace.furnace6.path)),
        Sprite(game.images.fromCache(Assets.images.furnace.furnace7.path)),
        Sprite(game.images.fromCache(Assets.images.furnace.furnace8.path)),
        Sprite(game.images.fromCache(Assets.images.furnace.furnace9.path)),
        Sprite(game.images.fromCache(Assets.images.furnace.furnace10.path)),
        Sprite(game.images.fromCache(Assets.images.furnace.furnace11.path)),
        Sprite(game.images.fromCache(Assets.images.furnace.furnace12.path)),
        Sprite(game.images.fromCache(Assets.images.furnace.furnace13.path)),
        Sprite(game.images.fromCache(Assets.images.furnace.furnace14.path)),
        Sprite(game.images.fromCache(Assets.images.furnace.furnace15.path)),
        Sprite(game.images.fromCache(Assets.images.furnace.furnace16.path)),
      ],
      stepTimes: [
        0.1 / speed,
        0.1 / speed,
        0.1 / speed,
        0.1 / speed,
        0.1 / speed,
        0.1 / speed,
        0.1 / speed,
        0.1 / speed,
        0.1 / speed,
        0.1 / speed,
        0.1 / speed,
        0.1 / speed,
        0.1 / speed,
        0.1 / speed,
        0.1 / speed,
        0.1 / speed,
      ],
    );

    animationTicker!.onFrame = (int index) {
      if (index == animation!.frames.length - 1) {
        game.productionController.buildingProduce(BuildingType.furnace);
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
      switchProduction(game.productionController.mapAreBuildingProducing[BuildingType.furnace] ?? false);
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
