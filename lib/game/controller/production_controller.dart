import 'package:flame/components.dart';
import 'package:flame_game_jam_2025/game/controller/building_controller.dart';
import 'package:flame_game_jam_2025/game/level/level_world.dart';

import '../game.dart';
import 'ressource_controller.dart';

class ProductionController extends Component with HasGameReference<FGJ2025>, Notifier {
  Map<BuildingType, bool> mapAreBuildingProducing = {
    BuildingType.miner: true,
    BuildingType.furnace: true,
    BuildingType.rocketPad: true,
    BuildingType.turret: true,
    BuildingType.armory: true,
  };

  void switchProduction(BuildingType buildingType, bool isProducing) {
    mapAreBuildingProducing[buildingType] = isProducing;
    notifyListeners();
  }

  void buildingProduce(BuildingType buildingType) {
    if (mapAreBuildingProducing[buildingType] == false) return;

    double production = 0;
    RessourceType? ressourceType;

    int reducer = 0;

    switch (buildingType) {
      case BuildingType.miner:
        production =
            game.buildingController.buildingBuilt[BuildingType.miner]! * game.buildingController.minerProduction;
        ressourceType = RessourceType.ore;
        game.ressourceController.addRessources(ressourceType: ressourceType, amount: production);
        levelWorld.addProductionNotification(
          ressourceTypes: [ressourceType],
          buildingType: buildingType,
          amounts: [production.truncate()],
        );
        break;
      case BuildingType.furnace:
        production =
            game.buildingController.buildingBuilt[BuildingType.furnace]! * game.buildingController.furnaceProduction;
        ressourceType = RessourceType.mplate;

        while (reducer < game.buildingController.buildingBuilt[BuildingType.furnace]!) {
          if (game.ressourceController.ore < production * 3) {
            reducer++;
            production =
                (game.buildingController.buildingBuilt[BuildingType.furnace]! - reducer) *
                game.buildingController.furnaceProduction;
          } else {
            game.ressourceController.removeRessources(ressourceType: RessourceType.ore, amount: production * 3);
            game.ressourceController.addRessources(ressourceType: ressourceType, amount: production);

            levelWorld.addProductionNotification(
              ressourceTypes: [ressourceType, RessourceType.ore],
              buildingType: buildingType,
              amounts: [production.truncate(), -(production * 3).truncate()],
            );

            return;
          }
        }

        levelWorld.addProductionNotification(
          ressourceTypes: [RessourceType.ore],
          buildingType: buildingType,
          amounts: [0],
        );
        break;
      case BuildingType.rocketPad:
        production =
            game.buildingController.buildingBuilt[BuildingType.rocketPad]! *
            game.buildingController.rocketPadProduction;
        ressourceType = RessourceType.rocketPart;

        while (reducer < game.buildingController.buildingBuilt[BuildingType.rocketPad]!) {
          if (game.ressourceController.mplate < production * 5) {
            reducer++;
            production =
                (game.buildingController.buildingBuilt[BuildingType.rocketPad]! - reducer) *
                game.buildingController.rocketPadProduction;
          } else {
            game.ressourceController.removeRessources(ressourceType: RessourceType.mplate, amount: production * 5);
            game.ressourceController.addRessources(ressourceType: ressourceType, amount: production);

            levelWorld.addProductionNotification(
              ressourceTypes: [ressourceType, RessourceType.mplate],
              buildingType: buildingType,
              amounts: [production.truncate(), -(production * 5).truncate()],
            );

            return;
          }
        }

        levelWorld.addProductionNotification(
          ressourceTypes: [RessourceType.mplate],
          buildingType: buildingType,
          amounts: [0],
        );
        break;
      case BuildingType.turret:
        break;
      case BuildingType.armory:
        production =
            game.buildingController.buildingBuilt[BuildingType.armory]! * game.buildingController.armoryProduction;
        ressourceType = RessourceType.bullet;

        while (reducer < game.buildingController.buildingBuilt[BuildingType.armory]!) {
          if (game.ressourceController.mplate < production * 2) {
            reducer++;
            production =
                (game.buildingController.buildingBuilt[BuildingType.armory]! - reducer) *
                game.buildingController.armoryProduction;
          } else {
            game.ressourceController.removeRessources(ressourceType: RessourceType.mplate, amount: production * 2);
            game.ressourceController.addRessources(ressourceType: ressourceType, amount: production);

            levelWorld.addProductionNotification(
              ressourceTypes: [ressourceType, RessourceType.mplate],
              buildingType: buildingType,
              amounts: [production.truncate(), -(production * 2).truncate()],
            );

            return;
          }
        }

        levelWorld.addProductionNotification(
          ressourceTypes: [RessourceType.mplate],
          buildingType: buildingType,
          amounts: [0],
        );
        break;
    }
  }

  LevelWorld get levelWorld => game.findByKeyName("levelWorld")! as LevelWorld;
}
