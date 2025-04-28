import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/input.dart';

import '../game.dart';

class BeginMenu extends PositionComponent with HasGameReference<FGJ2025> {
  final World world = World();
  late final CameraComponent cameraComponent;

  late final PositionComponent beginComponent;

  @override
  FutureOr<void> onLoad() {
    add(world);

    add(
      cameraComponent = CameraComponent.withFixedResolution(
        width: FGJ2025.gameWidth,
        height: FGJ2025.gameHeight,
        world: world,
      ),
    );

    world.add(
      beginComponent = ButtonComponent(
        anchor: Anchor.center,
        onPressed: () {
          game.router.pushReplacementNamed('mainMenu');
        },
        button: TextComponent(text: 'BEGIN'),
      ),
    );

    return super.onLoad();
  }

  double time = 0;

  @override
  void update(double dt) {
    super.update(dt);

    beginComponent.scale = Vector2.all(1.25 + 0.35 * sin(time));
    time += 2 * dt;
  }
}
