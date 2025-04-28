import 'dart:async';

import 'package:flame/components.dart';

import '../controller/game_controller.dart';
import '../game.dart';
import 'level_world.dart';

class Level extends PositionComponent with HasGameReference<FGJ2025> {
  Level({super.key});

  final LevelWorld levelWorld = LevelWorld(key: ComponentKey.named('levelWorld'));
  late final CameraComponent cameraComponent;

  @override
  FutureOr<void> onLoad() {
    add(
      cameraComponent = CameraComponent.withFixedResolution(
        width: FGJ2025.gameWidth,
        height: FGJ2025.gameHeight,
        world: levelWorld,
      ),
    );

    add(levelWorld);

    levelWorld.mounted.then((_) => game.gameController.changeGameStep(GameStep.introDialog));

    return super.onLoad();
  }
}
