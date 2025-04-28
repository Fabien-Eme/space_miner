import 'package:flame/components.dart';

import '../game.dart';
import 'game_controller.dart';

class RessourceController extends Component with HasGameReference<FGJ2025>, Notifier {
  double ore = 0;
  double mplate = 0;
  double bullet = 5;
  double enemies = 0;
  double rocketPart = 0;
  double rocketLife = 100;

  bool isEnnemyUnlocked = false;

  Map<int, int> ennemyWaveLaunched = {1: 5, 2: 10, 3: 15, 4: 20, 5: 30, 6: 40, 7: 50, 8: 70, 9: 90, 10: 50};

  void addRessources({required RessourceType ressourceType, required double amount}) {
    switch (ressourceType) {
      case RessourceType.ore:
        ore += amount;
        break;
      case RessourceType.mplate:
        mplate += amount;
        if (mplate > 100 && !isEnnemyUnlocked) {
          isEnnemyUnlocked = true;
        }
        break;
      case RessourceType.bullet:
        bullet += amount;
        break;
      case RessourceType.enemies:
        enemies += amount;
        break;
      case RessourceType.rocketPart:
        rocketPart += amount;
        if (rocketPart >= 10) {
          if (!isEnnemyUnlocked) {
            isEnnemyUnlocked = true;
          }

          int ennemyWave = (rocketPart / 10).truncate();
          if (ennemyWaveLaunched[ennemyWave] != null && ennemyWaveLaunched[ennemyWave]! != 0) {
            game.combatController.addEnnemy(amount: ennemyWaveLaunched[ennemyWave]!);
            ennemyWaveLaunched[ennemyWave] = 0;
          }
        }
        break;
      case RessourceType.rocketLife:
        rocketLife += amount;
        break;
    }

    notifyListeners();
  }

  void removeRessources({required RessourceType ressourceType, required double amount}) {
    switch (ressourceType) {
      case RessourceType.ore:
        ore -= amount;
        break;
      case RessourceType.mplate:
        mplate -= amount;
        break;
      case RessourceType.bullet:
        bullet -= amount;
        break;
      case RessourceType.enemies:
        enemies -= amount;
        break;
      case RessourceType.rocketPart:
        rocketPart -= amount;
        break;
      case RessourceType.rocketLife:
        rocketLife -= amount;
        if (rocketLife < 0) {
          rocketLife = 0;
          game.gameController.changeGameStep(GameStep.gameLost);
        }
        break;
    }

    notifyListeners();
  }

  double getAmount(RessourceType ressourceType) {
    switch (ressourceType) {
      case RessourceType.ore:
        return ore;
      case RessourceType.mplate:
        return mplate;
      case RessourceType.bullet:
        return bullet;
      case RessourceType.enemies:
        return enemies;
      case RessourceType.rocketPart:
        return rocketPart;
      case RessourceType.rocketLife:
        return rocketLife;
    }
  }
}

enum RessourceType {
  ore,
  mplate,
  bullet,
  enemies,
  rocketPart,
  rocketLife;

  String get name {
    switch (this) {
      case RessourceType.ore:
        return 'ore';
      case RessourceType.mplate:
        return 'm. plate';
      case RessourceType.bullet:
        return 'bullet';
      case RessourceType.enemies:
        return 'enemies';
      case RessourceType.rocketPart:
        return 'rocket part';
      case RessourceType.rocketLife:
        return 'rocket life';
    }
  }
}
