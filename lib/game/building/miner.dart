import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';

import '../../gen/assets.gen.dart';
import '../controller/building_controller.dart';
import '../controller/production_controller.dart';
import '../game.dart';

class Miner extends SpriteAnimationComponent with HasGameReference<FGJ2025> {
  Miner({required super.position});

  double speed = 0.75;

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
        Sprite(game.images.fromCache(Assets.images.miner.miner1.path)),
        Sprite(game.images.fromCache(Assets.images.miner.miner2.path)),
        Sprite(game.images.fromCache(Assets.images.miner.miner3.path)),
        Sprite(game.images.fromCache(Assets.images.miner.miner4.path)),
        Sprite(game.images.fromCache(Assets.images.miner.miner5.path)),
        Sprite(game.images.fromCache(Assets.images.miner.miner6.path)),
        Sprite(game.images.fromCache(Assets.images.miner.miner7.path)),
        Sprite(game.images.fromCache(Assets.images.miner.miner6.path)),
        Sprite(game.images.fromCache(Assets.images.miner.miner5.path)),
        Sprite(game.images.fromCache(Assets.images.miner.miner4.path)),
        Sprite(game.images.fromCache(Assets.images.miner.miner3.path)),
        Sprite(game.images.fromCache(Assets.images.miner.miner2.path)),
        Sprite(game.images.fromCache(Assets.images.miner.miner1.path)),
      ],
      stepTimes: [
        0.1 / speed,
        0.1 / speed,
        0.1 / speed,
        0.1 / speed,
        0.1 / speed,
        0.1 / speed,
        1.5 / speed,
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
        game.productionController.buildingProduce(BuildingType.miner);
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
      switchProduction(game.productionController.mapAreBuildingProducing[BuildingType.miner] ?? false);
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
