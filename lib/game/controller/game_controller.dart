import 'package:flame/components.dart';
import 'package:flame/events.dart';

import '../game.dart';
import '../level/level_world.dart';
import 'building_controller.dart';
import 'dialog_controller.dart';
import 'objective_controller.dart';
import 'ressource_controller.dart';

class GameController extends Component with HasGameReference<FGJ2025>, Notifier {
  GameStep currentGameStep = GameStep.intro;

  void onGameTapDown(TapDownInfo info) {
    game.dialogController.onGameTapDown();
  }

  void changeGameStep(GameStep newGameStep) {
    if (currentGameStep == GameStep.gameWon || currentGameStep == GameStep.gameLost) return;

    currentGameStep = newGameStep;
    notifyListeners();

    switch (newGameStep) {
      case GameStep.intro:
        break;
      case GameStep.introDialog:
        game.dialogController.showDialog(DialogSequence.intro);
        break;
      case GameStep.levelGetInPlace:
        levelWorld.getLevelInPlace();
        break;
      case GameStep.levelStart:
        game.dialogController.showDialog(DialogSequence.buildAMiner);
        game.objectiveController.displayObjective(ObjectiveTitle.buildMiner);
        game.objectiveController.displayObjective(ObjectiveTitle.collect5Ore);
        levelWorld.addBuildingButton(buildingType: BuildingType.miner);
        levelWorld.addRessourceDisplay(ressourceType: RessourceType.ore);
        break;
      case GameStep.timeToMakePlate:
        game.objectiveController.removeDisplayedObjective(ObjectiveTitle.buildMiner);
        game.objectiveController.removeDisplayedObjective(ObjectiveTitle.collect5Ore);
        game.dialogController.showDialog(DialogSequence.timeToMakePlate);
        game.objectiveController.displayObjective(ObjectiveTitle.buildFurnace);
        game.objectiveController.displayObjective(ObjectiveTitle.craft5MetalPlate);
        levelWorld.addBuildingButton(buildingType: BuildingType.furnace);
        levelWorld.addRessourceDisplay(ressourceType: RessourceType.mplate);
        break;
      case GameStep.buildARocketPad:
        game.objectiveController.removeDisplayedObjective(ObjectiveTitle.buildFurnace);
        game.objectiveController.removeDisplayedObjective(ObjectiveTitle.craft5MetalPlate);
        game.dialogController.showDialog(DialogSequence.buildARocketPad);
        levelWorld.addBuildingButton(buildingType: BuildingType.rocketPad);
        game.objectiveController.displayObjective(ObjectiveTitle.buildRocketPad);
        game.objectiveController.displayObjective(ObjectiveTitle.produceRocketPart);
        levelWorld.addRessourceDisplay(ressourceType: RessourceType.rocketPart);
        levelWorld.addRessourceDisplay(ressourceType: RessourceType.rocketLife);
        break;
      case GameStep.buildATurret:
        game.objectiveController.removeDisplayedObjective(ObjectiveTitle.buildRocketPad);
        game.dialogController.showDialog(DialogSequence.buildATurret);
        levelWorld.addBuildingButton(buildingType: BuildingType.turret);
        game.objectiveController.displayObjective(ObjectiveTitle.buildTurret);
        game.combatController.addEnnemy(amount: 5);
        levelWorld.addRessourceDisplay(ressourceType: RessourceType.bullet);
        levelWorld.addRessourceDisplay(ressourceType: RessourceType.enemies);
        break;
      case GameStep.outOfAmmo:
        game.objectiveController.removeDisplayedObjective(ObjectiveTitle.buildTurret);
        game.dialogController.showDialog(DialogSequence.outOfAmmo);
        levelWorld.addBuildingButton(buildingType: BuildingType.armory);
        game.objectiveController.displayObjective(ObjectiveTitle.buildArmory);
        break;
      case GameStep.manageEconomy:
        game.objectiveController.removeDisplayedObjective(ObjectiveTitle.buildArmory);
        game.dialogController.showDialog(DialogSequence.manageEconomy);
        break;
      case GameStep.gameWon:
        game.objectiveController.removeDisplayedObjective(ObjectiveTitle.produceRocketPart);
        levelWorld.addRocket();
        Future.delayed(Duration(seconds: 1), () {
          game.dialogController.showDialog(DialogSequence.gameWon);
        });
        break;
      case GameStep.gameLost:
        game.dialogController.showDialog(DialogSequence.gameLost);
        break;
      case GameStep.cut:
        levelWorld.getLevelInPlace(instant: true);
        levelWorld.addBuildingButton(buildingType: BuildingType.miner);
        levelWorld.addBuildingButton(buildingType: BuildingType.furnace);
        levelWorld.addBuildingButton(buildingType: BuildingType.rocketPad);
        levelWorld.addBuildingButton(buildingType: BuildingType.turret);
        levelWorld.addBuildingButton(buildingType: BuildingType.armory);
        break;
    }
  }

  LevelWorld get levelWorld => game.findByKeyName('levelWorld') as LevelWorld;
}

enum GameStep {
  intro,
  introDialog,
  levelGetInPlace,
  levelStart,
  timeToMakePlate,
  buildARocketPad,
  buildATurret,
  outOfAmmo,
  manageEconomy,
  gameWon,
  gameLost,
  cut,
}
