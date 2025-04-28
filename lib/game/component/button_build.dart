import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';

import '../../gen/assets.gen.dart';
import '../controller/audio_controller.dart';
import '../controller/building_controller.dart';
import '../game.dart';
import '../text/my_text_style.dart';

class ButtonBuild extends PositionComponent with HasGameReference<FGJ2025> {
  ButtonBuild({required this.type, required super.position});

  final BuildingType type;

  @override
  FutureOr<void> onLoad() {
    anchor = Anchor.topCenter;
    final buttonComponent = ButtonComponent(
      button: ButtonSkeleton(type: type),
      size: Vector2(48, 48),
      onPressed: () {
        bool canBuild = true;
        for (var entry in game.buildingController.getCost(type).entries) {
          if (entry.value > game.ressourceController.getAmount(entry.key)) {
            canBuild = false;
          }
        }

        if (canBuild) {
          for (var entry in game.buildingController.getCost(type).entries) {
            game.ressourceController.removeRessources(ressourceType: entry.key, amount: entry.value.toDouble());
          }

          game.buildingController.buildBuilding(buildingType: type);
          game.audioController.playSound(SoundType.buildingBuilt);
        }
      },
    );

    add(
      ColumnComponent(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [buttonComponent, TextComponent(text: type.name, textRenderer: MyTextStyle.smallTextBlack)],
      ),
    );

    return super.onLoad();
  }
}

class ButtonSkeleton extends PositionComponent with HasGameReference<FGJ2025> {
  ButtonSkeleton({required this.type});

  final BuildingType type;

  @override
  void onLoad() {
    size = Vector2(48, 48);

    add(
      SpriteComponent.fromImage(
        game.images.fromCache(getImagePath()),
        size: Vector2(32, 32),
        paint: Paint()..filterQuality = FilterQuality.none,
        position: Vector2(8, 8),
      ),
    );

    add(
      SpriteComponent.fromImage(
        game.images.fromCache(Assets.images.buttonSkeleton.path),
        size: Vector2(48, 48),
        paint: Paint()..filterQuality = FilterQuality.none,
      ),
    );
  }

  String getImagePath() {
    switch (type) {
      case BuildingType.miner:
        return Assets.images.miner.miner.path;
      case BuildingType.furnace:
        return Assets.images.furnace.furnace16.path;
      case BuildingType.rocketPad:
        return Assets.images.rocket.rocketButton.path;
      case BuildingType.turret:
        return Assets.images.turret.turret.path;
      case BuildingType.armory:
        return Assets.images.armory.armory.path;
    }
  }
}
