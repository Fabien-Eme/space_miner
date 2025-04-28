import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame_game_jam_2025/game/controller/building_controller.dart';

import '../controller/ressource_controller.dart';
import '../game.dart';
import '../text/my_text_style.dart';

class RessourceDisplay extends PositionComponent with HasGameReference<FGJ2025> {
  RessourceDisplay({required this.ressourceType, super.position, super.priority});

  final RessourceType ressourceType;

  late final ComponentsNotifier<RessourceController> ressourceControllerNotifier;
  late final VoidCallback ressourceControllerListener;

  late final ComponentsNotifier<BuildingController> buildingControllerNotifier;
  late final VoidCallback buildingControllerListener;

  late final TextComponent ressourceTextComponent;
  late final TextComponent buildingTextComponent;

  late final BuildingType buildingType;

  @override
  void onLoad() {
    super.onLoad();

    buildingType = getBuildingTypeFromRessourceType();
    anchor = Anchor.topCenter;
    ressourceTextComponent = TextComponent(
      anchor: Anchor.center,
      text: "${ressourceType.name}: 0",
      textRenderer: (ressourceType == RessourceType.enemies) ? MyTextStyle.headerRed : MyTextStyle.headerWhite,
    );
    add(ressourceTextComponent);

    buildingTextComponent = TextComponent(
      position: Vector2(0, 25),
      anchor: Anchor.center,
      text: "0 ${buildingType.name}",
      textRenderer: MyTextStyle.textDarkGrey,
    );
    if (ressourceType != RessourceType.rocketLife) {
      add(buildingTextComponent);
    }
  }

  @override
  void onMount() {
    ressourceControllerNotifier = game.componentsNotifier<RessourceController>();
    ressourceControllerListener = () {
      switch (ressourceType) {
        case RessourceType.ore:
          ressourceTextComponent.text =
              "${ressourceType.name}: ${formatNumberToText(game.ressourceController.ore.truncate())}";
          break;
        case RessourceType.mplate:
          ressourceTextComponent.text =
              "${ressourceType.name}: ${formatNumberToText(game.ressourceController.mplate.truncate())}";
          break;
        case RessourceType.bullet:
          ressourceTextComponent.text =
              "${ressourceType.name}: ${formatNumberToText(game.ressourceController.bullet.truncate())}";
          break;
        case RessourceType.enemies:
          ressourceTextComponent.text =
              "${ressourceType.name}: ${formatNumberToText(game.ressourceController.enemies.truncate())}";
          break;
        case RessourceType.rocketPart:
          ressourceTextComponent.text =
              "${ressourceType.name}: ${formatNumberToText(game.ressourceController.rocketPart.truncate())}/100";
          break;
        case RessourceType.rocketLife:
          ressourceTextComponent.text =
              "${ressourceType.name}: ${formatNumberToText(game.ressourceController.rocketLife.truncate())}/100";
          break;
      }
    };
    ressourceControllerNotifier.addListener(ressourceControllerListener);

    buildingControllerNotifier = game.componentsNotifier<BuildingController>();
    buildingControllerListener = () {
      switch (buildingType) {
        case BuildingType.miner:
          buildingTextComponent.text =
              "${game.buildingController.buildingBuilt[BuildingType.miner]} ${buildingType.name}";
          break;
        case BuildingType.furnace:
          buildingTextComponent.text =
              "${game.buildingController.buildingBuilt[BuildingType.furnace]} ${buildingType.name}";
          break;
        case BuildingType.rocketPad:
          buildingTextComponent.text =
              "${game.buildingController.buildingBuilt[BuildingType.rocketPad]} ${buildingType.name}";
          break;
        case BuildingType.turret:
          buildingTextComponent.text =
              "${game.buildingController.buildingBuilt[BuildingType.turret]} ${buildingType.name}";
          break;
        case BuildingType.armory:
          buildingTextComponent.text =
              "${game.buildingController.buildingBuilt[BuildingType.armory]} ${buildingType.name}";
          break;
      }
    };
    buildingControllerNotifier.addListener(buildingControllerListener);

    super.onMount();
  }

  String formatNumberToText(int number) {
    if (number > 1000000) {
      return "${(number / 1000000).toStringAsFixed(1)}M";
    } else if (number > 1000) {
      return "${(number / 1000).toStringAsFixed(1)}k";
    } else {
      return number.toString();
    }
  }

  BuildingType getBuildingTypeFromRessourceType() {
    switch (ressourceType) {
      case RessourceType.ore:
        return BuildingType.miner;
      case RessourceType.mplate:
        return BuildingType.furnace;
      case RessourceType.bullet:
        return BuildingType.armory;
      case RessourceType.enemies:
        return BuildingType.turret;
      case RessourceType.rocketPart:
        return BuildingType.rocketPad;
      case RessourceType.rocketLife:
        return BuildingType.rocketPad;
    }
  }

  @override
  void onRemove() {
    ressourceControllerNotifier.removeListener(ressourceControllerListener);
    buildingControllerNotifier.removeListener(buildingControllerListener);
    super.onRemove();
  }
}
