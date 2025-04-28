import 'package:flame/components.dart';

import '../component/ennemy.dart';
import '../game.dart';
import '../level/level_world.dart';
import 'building_controller.dart';
import 'ressource_controller.dart';

class CombatController extends Component with HasGameReference<FGJ2025> {
  List<Ennemy> ennemies = [];

  void addEnnemy({int amount = 1}) {
    for (var i = 0; i < amount; i++) {
      final ennemy = Ennemy(position: Vector2(0, -FGJ2025.gameHeight / 2 - 10), priority: 0);
      ennemies.add(ennemy);
      levelWorld.addEnnemy(ennemy);
      game.ressourceController.addRessources(ressourceType: RessourceType.enemies, amount: 1);
    }
  }

  void removeEnnemy(Ennemy ennemy) {
    ennemies.remove(ennemy);
    levelWorld.removeEnnemy(ennemy);
    game.ressourceController.removeRessources(ressourceType: RessourceType.enemies, amount: 1);
  }

  bool fireBullet() {
    if (game.ressourceController.bullet <= 0) {
      levelWorld.addProductionNotification(
        ressourceTypes: [RessourceType.bullet],
        buildingType: BuildingType.turret,
        amounts: [0],
      );
      return false;
    }
    final target = getLowestEnnemyNotAimed();
    if (target != null) {
      target.isAimedByBullet = true;
      levelWorld.addTurretBullet(target: target);
      game.ressourceController.removeRessources(ressourceType: RessourceType.bullet, amount: 1);
      return true;
    }
    return false;
  }

  void fireEnemyBullet() {
    levelWorld.addEnnemyBullet();
  }

  void damageRocketPad() {
    levelWorld.rocketPad?.takeAhit();
  }

  Ennemy? getLowestEnnemyNotAimed() {
    if (ennemies.isEmpty) return null;
    if (ennemies.length == 1) {
      if (ennemies.first.isAimedByBullet) return null;
      return ennemies.first;
    } else {
      final notAimed = ennemies.where((e) => !e.isAimedByBullet).toList();
      if (notAimed.isEmpty) return null;
      final lowest = notAimed.reduce((lowest, current) => current.position.y > lowest.position.y ? current : lowest);
      if (lowest.isAimedByBullet) return null;
      return lowest;
    }
  }

  LevelWorld get levelWorld => game.findByKeyName('levelWorld') as LevelWorld;
}
