import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame_game_jam_2025/game/game.dart';

import 'building_controller.dart';
import 'game_controller.dart';
import 'ressource_controller.dart';

class ObjectiveController extends Component with HasGameReference<FGJ2025>, Notifier {
  final allObjectives = initializeObjectives();

  final List<Objective> currentlyDisplayedObjectives = [];

  late final ComponentsNotifier<BuildingController> buildingControllerNotifier;
  late final VoidCallback buildingControllerListener;

  late final ComponentsNotifier<RessourceController> ressourceControllerNotifier;
  late final VoidCallback ressourceControllerListener;

  @override
  void onMount() {
    super.onMount();
    buildingControllerNotifier = game.componentsNotifier<BuildingController>();
    buildingControllerListener = () {
      if (game.buildingController.buildingBuilt[BuildingType.miner]! > 0) {
        completeObjective(ObjectiveTitle.buildMiner);
      }
      if (game.buildingController.buildingBuilt[BuildingType.furnace]! > 0) {
        completeObjective(ObjectiveTitle.buildFurnace);
      }
      if (game.buildingController.buildingBuilt[BuildingType.rocketPad]! > 0) {
        completeObjective(ObjectiveTitle.buildRocketPad);
      }
      if (game.buildingController.buildingBuilt[BuildingType.turret]! > 0) {
        completeObjective(ObjectiveTitle.buildTurret);
      }
      if (game.buildingController.buildingBuilt[BuildingType.armory]! > 0) {
        completeObjective(ObjectiveTitle.buildArmory);
      }
    };
    buildingControllerNotifier.addListener(buildingControllerListener);

    ressourceControllerNotifier = game.componentsNotifier<RessourceController>();
    ressourceControllerListener = () {
      if (game.ressourceController.ore >= 5) completeObjective(ObjectiveTitle.collect5Ore);
      if (game.ressourceController.mplate >= 5) completeObjective(ObjectiveTitle.craft5MetalPlate);
      if (game.ressourceController.rocketPart >= 100) completeObjective(ObjectiveTitle.produceRocketPart);
      if (game.ressourceController.rocketPart >= 3) completeObjective(ObjectiveTitle.craft3RocketPart);
      if (game.ressourceController.bullet == 0 && game.gameController.currentGameStep == GameStep.buildATurret) {
        game.gameController.changeGameStep(GameStep.outOfAmmo);
      }
    };
    ressourceControllerNotifier.addListener(ressourceControllerListener);
  }

  void completeObjective(ObjectiveTitle title) {
    final objective = allObjectives.firstWhere((objective) => objective.title == title);

    if (objective.isCompleted) return;
    objective.isCompleted = true;

    checkCompletedObjectives();
    notifyListeners();
  }

  bool isObjectiveCompleted(ObjectiveTitle title) {
    return allObjectives.any((objective) => objective.title == title && objective.isCompleted);
  }

  void displayObjective(ObjectiveTitle title) {
    final objective = allObjectives.firstWhere((objective) => objective.title == title);
    currentlyDisplayedObjectives.add(objective);
    notifyListeners();
  }

  void removeDisplayedObjective(ObjectiveTitle title) {
    currentlyDisplayedObjectives.removeWhere((objective) => objective.title == title);
    notifyListeners();
  }

  void checkCompletedObjectives() {
    if (isObjectiveCompleted(ObjectiveTitle.buildMiner) && isObjectiveCompleted(ObjectiveTitle.collect5Ore)) {
      if (game.gameController.currentGameStep == GameStep.levelStart) {
        game.gameController.changeGameStep(GameStep.timeToMakePlate);
      }
    }
    if (isObjectiveCompleted(ObjectiveTitle.buildFurnace) && isObjectiveCompleted(ObjectiveTitle.craft5MetalPlate)) {
      if (game.gameController.currentGameStep == GameStep.timeToMakePlate) {
        game.gameController.changeGameStep(GameStep.buildARocketPad);
      }
    }
    if (isObjectiveCompleted(ObjectiveTitle.buildRocketPad) && isObjectiveCompleted(ObjectiveTitle.craft3RocketPart)) {
      if (game.gameController.currentGameStep == GameStep.buildARocketPad) {
        game.gameController.changeGameStep(GameStep.buildATurret);
      }
    }
    if (isObjectiveCompleted(ObjectiveTitle.buildArmory)) {
      if (game.gameController.currentGameStep == GameStep.outOfAmmo) {
        game.gameController.changeGameStep(GameStep.manageEconomy);
      }
    }
    if (isObjectiveCompleted(ObjectiveTitle.produceRocketPart)) {
      if (game.gameController.currentGameStep == GameStep.manageEconomy) {
        game.gameController.changeGameStep(GameStep.gameWon);
      }
    }
  }

  @override
  void onRemove() {
    buildingControllerNotifier.removeListener(buildingControllerListener);
    ressourceControllerNotifier.removeListener(ressourceControllerListener);
    super.onRemove();
  }
}

List<Objective> initializeObjectives() {
  return [
    Objective(title: ObjectiveTitle.buildMiner, displayText: 'Build a miner'),
    Objective(title: ObjectiveTitle.collect5Ore, displayText: 'Collect 5 ore'),
    Objective(title: ObjectiveTitle.buildFurnace, displayText: 'Build a furnace'),
    Objective(title: ObjectiveTitle.craft5MetalPlate, displayText: 'Craft 5 metal plates'),
    Objective(title: ObjectiveTitle.buildRocketPad, displayText: 'Build a rocket pad'),
    Objective(title: ObjectiveTitle.buildTurret, displayText: 'Build a turret'),
    Objective(title: ObjectiveTitle.buildArmory, displayText: 'Build an armory'),
    Objective(title: ObjectiveTitle.produceRocketPart, displayText: 'Produce 100 rocket parts'),
    Objective(title: ObjectiveTitle.craft3RocketPart, displayText: 'Craft 3 rocket parts'),
  ];
}

class Objective {
  ObjectiveTitle title;
  String displayText;
  bool isCompleted;

  Objective({required this.title, required this.displayText, this.isCompleted = false});
}

enum ObjectiveTitle {
  buildMiner,
  collect5Ore,
  buildFurnace,
  craft5MetalPlate,
  buildRocketPad,
  craft3RocketPart,
  buildTurret,
  buildArmory,
  produceRocketPart,
}
