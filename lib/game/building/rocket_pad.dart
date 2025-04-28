import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';

import '../../gen/assets.gen.dart';
import '../../utils/palette.dart';
import '../controller/audio_controller.dart';
import '../controller/building_controller.dart';
import '../controller/production_controller.dart';
import '../controller/ressource_controller.dart';
import '../game.dart';

class RocketPad extends SpriteAnimationComponent with HasGameReference<FGJ2025> {
  RocketPad({required super.position});

  double speed = 0.2;

  late final ComponentsNotifier<ProductionController> productionControllerNotifier;
  late final VoidCallback productionControllerListener;

  bool isProducing = true;

  @override
  FutureOr<void> onLoad() {
    anchor = Anchor.center;
    size = Vector2(128, 128);
    paint = Paint()..filterQuality = FilterQuality.none;
    animation = SpriteAnimation.variableSpriteList(
      [
        Sprite(game.images.fromCache(Assets.images.rocketPad.rocketPad1.path)),
        Sprite(game.images.fromCache(Assets.images.rocketPad.rocketPad2.path)),
        Sprite(game.images.fromCache(Assets.images.rocketPad.rocketPad3.path)),
        Sprite(game.images.fromCache(Assets.images.rocketPad.rocketPad4.path)),
        Sprite(game.images.fromCache(Assets.images.rocketPad.rocketPad5.path)),
        Sprite(game.images.fromCache(Assets.images.rocketPad.rocketPad6.path)),
        Sprite(game.images.fromCache(Assets.images.rocketPad.rocketPad7.path)),
        Sprite(game.images.fromCache(Assets.images.rocketPad.rocketPad8.path)),
        Sprite(game.images.fromCache(Assets.images.rocketPad.rocketPad9.path)),
        Sprite(game.images.fromCache(Assets.images.rocketPad.rocketPad10.path)),
        Sprite(game.images.fromCache(Assets.images.rocketPad.rocketPad11.path)),
        Sprite(game.images.fromCache(Assets.images.rocketPad.rocketPad12.path)),
        Sprite(game.images.fromCache(Assets.images.rocketPad.rocketPad13.path)),
        Sprite(game.images.fromCache(Assets.images.rocketPad.rocketPad14.path)),
        Sprite(game.images.fromCache(Assets.images.rocketPad.rocketPad15.path)),
        Sprite(game.images.fromCache(Assets.images.rocketPad.rocketPad16.path)),
        Sprite(game.images.fromCache(Assets.images.rocketPad.rocketPad17.path)),
        Sprite(game.images.fromCache(Assets.images.rocketPad.rocketPad18.path)),
        Sprite(game.images.fromCache(Assets.images.rocketPad.rocketPad19.path)),
        Sprite(game.images.fromCache(Assets.images.rocketPad.rocketPad20.path)),
        Sprite(game.images.fromCache(Assets.images.rocketPad.rocketPad21.path)),
        Sprite(game.images.fromCache(Assets.images.rocketPad.rocketPad22.path)),
        Sprite(game.images.fromCache(Assets.images.rocketPad.rocketPad23.path)),
        Sprite(game.images.fromCache(Assets.images.rocketPad.rocketPad24.path)),
        Sprite(game.images.fromCache(Assets.images.rocketPad.rocketPad25.path)),
        Sprite(game.images.fromCache(Assets.images.rocketPad.rocketPad26.path)),
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
        game.productionController.buildingProduce(BuildingType.rocketPad);
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
      switchProduction(game.productionController.mapAreBuildingProducing[BuildingType.rocketPad] ?? false);
    };
    productionControllerNotifier.addListener(productionControllerListener);
    super.onMount();
  }

  void takeAhit() {
    game.ressourceController.removeRessources(ressourceType: RessourceType.rocketLife, amount: 0.1);
    game.audioController.playSound(SoundType.takeAHit);
    if (isTakingHit) return;
    isTakingHit = true;
    paint = Paint()..colorFilter = ColorFilter.mode(Palette.red, BlendMode.srcIn);
  }

  bool isTakingHit = false;
  double timeElapsed = 0;

  @override
  void update(double dt) {
    if (isTakingHit) {
      timeElapsed += dt;
      if (timeElapsed >= 0.2) {
        timeElapsed = 0;
        paint = Paint()..colorFilter = null;
        isTakingHit = false;
      }
    }
    super.update(dt);
  }

  @override
  void onRemove() {
    productionControllerNotifier.removeListener(productionControllerListener);
    super.onRemove();
  }
}
