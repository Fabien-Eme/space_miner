import 'package:flame/components.dart';

import '../game.dart';
import '../level/level_world.dart';
import 'ressource_controller.dart';

class BuildingController extends Component with HasGameReference<FGJ2025>, Notifier {
  Map<BuildingType, int> buildingBuilt = {
    BuildingType.miner: 0,
    BuildingType.furnace: 0,
    BuildingType.rocketPad: 0,
    BuildingType.turret: 0,
    BuildingType.armory: 0,
  };

  double minerProduction = 1.0;
  Map<int, Map<RessourceType, int>> minerCost = {
    0: {RessourceType.ore: 0},
    1: {RessourceType.ore: 3},
    2: {RessourceType.ore: 5},
    3: {RessourceType.ore: 10},
    4: {RessourceType.ore: 15},
    5: {RessourceType.ore: 5, RessourceType.mplate: 3},
    6: {RessourceType.ore: 5, RessourceType.mplate: 5},
    7: {RessourceType.ore: 10, RessourceType.mplate: 5},
    8: {RessourceType.ore: 10, RessourceType.mplate: 10},
    9: {RessourceType.ore: 15, RessourceType.mplate: 10},
    10: {RessourceType.ore: 25, RessourceType.mplate: 10},
    11: {RessourceType.ore: 25, RessourceType.mplate: 15},
    12: {RessourceType.ore: 25, RessourceType.mplate: 20},
    13: {RessourceType.ore: 25, RessourceType.mplate: 25},
    14: {RessourceType.ore: 30, RessourceType.mplate: 25},
    15: {RessourceType.ore: 50},
    16: {RessourceType.ore: 35, RessourceType.mplate: 30},
    17: {RessourceType.ore: 40, RessourceType.mplate: 35},
    18: {RessourceType.ore: 40, RessourceType.mplate: 40},
  };

  double furnaceProduction = 1.0;
  Map<int, Map<RessourceType, int>> furnaceCost = {
    0: {RessourceType.ore: 5},
    1: {RessourceType.ore: 10},
    2: {RessourceType.mplate: 3},
    3: {RessourceType.mplate: 10},
    4: {RessourceType.mplate: 15},
    5: {RessourceType.mplate: 20},
    6: {RessourceType.mplate: 25},
    7: {RessourceType.mplate: 30},
    8: {RessourceType.mplate: 35},
    9: {RessourceType.mplate: 40},
    10: {RessourceType.mplate: 50},
    11: {RessourceType.mplate: 75},
    12: {RessourceType.mplate: 100},
  };

  double rocketPadProduction = 1.0;
  Map<int, Map<RessourceType, int>> rocketCost = {
    0: {RessourceType.mplate: 10},
    1: {RessourceType.mplate: 15},
    2: {RessourceType.mplate: 20},
    3: {RessourceType.mplate: 25},
    4: {RessourceType.mplate: 50},
    5: {RessourceType.mplate: 50},
    6: {RessourceType.mplate: 75},
    7: {RessourceType.mplate: 75},
    8: {RessourceType.mplate: 100},
    9: {RessourceType.mplate: 100},
  };

  Map<int, Map<RessourceType, int>> turretCost = {
    0: {RessourceType.mplate: 0},
    1: {RessourceType.mplate: 5},
    2: {RessourceType.mplate: 5, RessourceType.bullet: 5},
    3: {RessourceType.mplate: 10, RessourceType.bullet: 10},
    4: {RessourceType.mplate: 20, RessourceType.bullet: 10},
    5: {RessourceType.mplate: 25, RessourceType.bullet: 15},
    6: {RessourceType.mplate: 30, RessourceType.bullet: 15},
    7: {RessourceType.mplate: 30, RessourceType.bullet: 20},
    8: {RessourceType.mplate: 50, RessourceType.bullet: 30},
    9: {RessourceType.mplate: 50, RessourceType.bullet: 50},
    10: {RessourceType.mplate: 100, RessourceType.bullet: 50},
    11: {RessourceType.mplate: 100, RessourceType.bullet: 100},
  };

  double armoryProduction = 1.0;
  Map<int, Map<RessourceType, int>> armoryCost = {
    0: {RessourceType.mplate: 10},
    1: {RessourceType.mplate: 10},
    2: {RessourceType.mplate: 15},
    3: {RessourceType.mplate: 20},
    4: {RessourceType.mplate: 20},
    5: {RessourceType.mplate: 25},
    6: {RessourceType.mplate: 30},
    7: {RessourceType.mplate: 40},
    8: {RessourceType.mplate: 50},
  };

  double rocketLife = 100.0;

  void buildBuilding({required BuildingType buildingType}) {
    buildingBuilt[buildingType] = buildingBuilt[buildingType]! + 1;
    if (buildingBuilt[buildingType] == 1) {
      levelWorld.addBuilding(buildingType: buildingType);
    }

    notifyListeners();
  }

  Map<RessourceType, int> getCost(BuildingType buildingType) {
    switch (buildingType) {
      case BuildingType.miner:
        return minerCost[buildingBuilt[BuildingType.miner] ?? 0] ?? minerCost.values.last;
      case BuildingType.furnace:
        return furnaceCost[buildingBuilt[BuildingType.furnace] ?? 0] ?? furnaceCost.values.last;
      case BuildingType.rocketPad:
        return rocketCost[buildingBuilt[BuildingType.rocketPad] ?? 0] ?? rocketCost.values.last;
      case BuildingType.turret:
        return turretCost[buildingBuilt[BuildingType.turret] ?? 0] ?? turretCost.values.last;
      case BuildingType.armory:
        return armoryCost[buildingBuilt[BuildingType.armory] ?? 0] ?? armoryCost.values.last;
    }
  }

  LevelWorld get levelWorld => game.findByKeyName('levelWorld') as LevelWorld;
}

enum BuildingType { miner, furnace, rocketPad, turret, armory }
