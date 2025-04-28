import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';

import '../../gen/assets.gen.dart';
import '../controller/building_controller.dart';
import '../controller/production_controller.dart';
import '../game.dart';

class Armory extends SpriteAnimationComponent with HasGameReference<FGJ2025> {
  Armory({required super.position});

  double speed = 0.4;

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
        Sprite(game.images.fromCache(Assets.images.armory.armory1.path)),
        Sprite(game.images.fromCache(Assets.images.armory.armory2.path)),
        Sprite(game.images.fromCache(Assets.images.armory.armory3.path)),
        Sprite(game.images.fromCache(Assets.images.armory.armory4.path)),
        Sprite(game.images.fromCache(Assets.images.armory.armory5.path)),
        Sprite(game.images.fromCache(Assets.images.armory.armory6.path)),
        Sprite(game.images.fromCache(Assets.images.armory.armory7.path)),
        Sprite(game.images.fromCache(Assets.images.armory.armory8.path)),
        Sprite(game.images.fromCache(Assets.images.armory.armory9.path)),
        Sprite(game.images.fromCache(Assets.images.armory.armory10.path)),
        Sprite(game.images.fromCache(Assets.images.armory.armory11.path)),
        Sprite(game.images.fromCache(Assets.images.armory.armory12.path)),
        Sprite(game.images.fromCache(Assets.images.armory.armory13.path)),
        Sprite(game.images.fromCache(Assets.images.armory.armory14.path)),
        Sprite(game.images.fromCache(Assets.images.armory.armory15.path)),
        Sprite(game.images.fromCache(Assets.images.armory.armory16.path)),
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
        game.productionController.buildingProduce(BuildingType.armory);
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
      switchProduction(game.productionController.mapAreBuildingProducing[BuildingType.armory] ?? false);
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
