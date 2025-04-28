import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_game_jam_2025/game/component/button_build.dart';
import 'package:flame_game_jam_2025/game/component/switch_production.dart';
import 'package:flame_game_jam_2025/game/controller/building_controller.dart';
import 'package:flutter/material.dart';

import '../building/armory.dart';
import '../building/furnace.dart';
import '../building/miner.dart';
import '../building/rocket.dart';
import '../building/rocket_pad.dart';
import '../building/turret.dart';
import '../component/building_cost_display.dart';
import '../component/ennemy.dart';
import '../component/ennemy_bullet.dart';
import '../component/objective_display.dart';
import '../component/production_notification.dart';
import '../component/ressource_display.dart';
import '../component/turret_bullet.dart';
import '../controller/game_controller.dart';
import '../controller/objective_controller.dart';
import '../controller/ressource_controller.dart';
import '../game.dart';
import '../shader/night_sky_shader.dart';

class LevelWorld extends World with HasGameReference<FGJ2025> {
  LevelWorld({super.key});

  late final NightSkyShader nightSkyShader;

  late final ComponentsNotifier<ObjectiveController> objectiveControllerNotifier;
  late final VoidCallback objectiveControllerListener;

  late final PositionComponent ground;

  double? targetGroundY;

  Vector2 minerPosition = Vector2(-FGJ2025.gameWidth / 2 + 40, 124);

  Vector2 furnacePosition = Vector2(-FGJ2025.gameWidth / 2 + 120, 124);

  Vector2 rocketPadPosition = Vector2(150, 76);

  Vector2 turretPosition = Vector2(0, 124);

  Vector2 armoryPosition = Vector2(-FGJ2025.gameWidth / 2 + 200, 124);

  List<ObjectiveDisplay> objectiveDisplays = [];
  Vector2 objectiveDisplayPosition = Vector2(0, -FGJ2025.gameHeight / 2 + 30);

  double buttonY = FGJ2025.gameHeight / 2 - 90;

  RocketPad? rocketPad;

  double enemyForce = 1;
  double timeSinceLastEnemy = 0;
  double enemySpawnRate = 20;

  @override
  FutureOr<void> onLoad() async {
    await parent!.mounted;

    add(nightSkyShader = NightSkyShader());

    add(
      ground = RectangleComponent(
        position: Vector2(-FGJ2025.gameWidth / 2, 0),
        size: Vector2(FGJ2025.gameWidth, FGJ2025.gameHeight / 2),
        paint: Paint()..color = Colors.white,
      ),
    );

    game.hasIntroBeenPlayed = true;
    game.audioController.playBackgroundMusic();

    return super.onLoad();
  }

  @override
  void onMount() {
    objectiveControllerNotifier = game.componentsNotifier<ObjectiveController>();
    objectiveControllerListener = () {
      List<Future<void>> futures = [];
      for (var objectiveDisplay in objectiveDisplays) {
        remove(objectiveDisplay);
        futures.add(objectiveDisplay.removed);
      }
      Future.wait(futures);
      objectiveDisplays.clear();

      int index = 0;
      for (var objective in game.objectiveController.currentlyDisplayedObjectives) {
        objectiveDisplays.add(
          ObjectiveDisplay(
            objective: objective,
            position: objectiveDisplayPosition + Vector2(FGJ2025.gameWidth / 2 - 40, index * 30),
          ),
        );
        index++;
        add(objectiveDisplays.last);
      }
    };
    objectiveControllerNotifier.addListener(objectiveControllerListener);
    super.onMount();
  }

  void addRocket() {
    add(Rocket(position: rocketPadPosition + Vector2(0, 20)));
  }

  void addRessourceDisplay({required RessourceType ressourceType}) {
    Vector2 ressourceDisplayPosition = Vector2(0, 0);

    switch (ressourceType) {
      case RessourceType.ore:
        ressourceDisplayPosition = Vector2(-FGJ2025.gameWidth / 2 + 80, -FGJ2025.gameHeight / 2 + 25);
        break;
      case RessourceType.mplate:
        ressourceDisplayPosition = Vector2(-FGJ2025.gameWidth / 2 + 230, -FGJ2025.gameHeight / 2 + 25);
        break;
      case RessourceType.bullet:
        ressourceDisplayPosition = Vector2(-FGJ2025.gameWidth / 2 + 380, -FGJ2025.gameHeight / 2 + 25);
        break;
      case RessourceType.enemies:
        ressourceDisplayPosition = Vector2(-FGJ2025.gameWidth / 2 + 530, -FGJ2025.gameHeight / 2 + 25);
        break;
      case RessourceType.rocketPart:
        ressourceDisplayPosition = Vector2(FGJ2025.gameWidth / 2 - 150, 0);
        break;
      case RessourceType.rocketLife:
        ressourceDisplayPosition = Vector2(FGJ2025.gameWidth / 2 - 150, 75);
        break;
    }

    add(RessourceDisplay(ressourceType: ressourceType, position: ressourceDisplayPosition, priority: 1));
  }

  void addBuildingButton({required BuildingType buildingType}) {
    double positionX = -FGJ2025.gameWidth / 2 + 40;

    switch (buildingType) {
      case BuildingType.miner:
        positionX = minerPosition.x;
        break;
      case BuildingType.furnace:
        positionX = furnacePosition.x;
        break;
      case BuildingType.rocketPad:
        positionX = rocketPadPosition.x;
        break;
      case BuildingType.turret:
        positionX = turretPosition.x;
        break;
      case BuildingType.armory:
        positionX = armoryPosition.x;
        break;
    }

    add(ButtonBuild(type: buildingType, position: Vector2(positionX, buttonY)));

    add(BuildingCostDisplay(buildingType: buildingType, position: Vector2(positionX, buttonY - 2)));

    add(SwitchProduction(buildingType: buildingType, position: Vector2(positionX, buttonY + 65)));
  }

  void addTurretBullet({required Ennemy target}) {
    add(TurretBullet(target: target, position: turretPosition + Vector2(0, -15)));
  }

  void addEnnemyBullet() {
    add(EnnemyBullet(position: Vector2(rocketPadPosition.x, 0)));
  }

  void addEnnemy(Ennemy ennemy) {
    add(ennemy);
  }

  void removeEnnemy(Ennemy ennemy) {
    remove(ennemy);
  }

  void getLevelInPlace({bool instant = false}) {
    if (instant) {
      ground.position.y = 140;
    } else {
      targetGroundY = 140;
    }
  }

  void addBuilding({required BuildingType buildingType}) {
    switch (buildingType) {
      case BuildingType.miner:
        add(Miner(position: minerPosition));
        break;
      case BuildingType.furnace:
        add(Furnace(position: furnacePosition));
        break;
      case BuildingType.rocketPad:
        rocketPad = RocketPad(position: rocketPadPosition);
        add(rocketPad!);
        break;
      case BuildingType.turret:
        add(Turret(position: turretPosition));
        break;
      case BuildingType.armory:
        add(Armory(position: armoryPosition));
    }
  }

  void addProductionNotification({
    required List<RessourceType> ressourceTypes,
    required BuildingType buildingType,
    required List<int> amounts,
  }) {
    Vector2 notificationPosition;

    switch (buildingType) {
      case BuildingType.miner:
        notificationPosition = minerPosition - Vector2(0, 24);
        break;
      case BuildingType.furnace:
        notificationPosition = furnacePosition - Vector2(0, 24);
        break;
      case BuildingType.rocketPad:
        notificationPosition = rocketPadPosition - Vector2(0, 24);
        break;
      case BuildingType.turret:
        notificationPosition = turretPosition - Vector2(0, 24);
        break;
      case BuildingType.armory:
        notificationPosition = armoryPosition - Vector2(0, 24);
        break;
    }

    add(ProductionNotification(ressourceTypes: ressourceTypes, amounts: amounts, position: notificationPosition));
  }

  double time = 0;

  @override
  void update(double dt) {
    time += dt;
    const speed = 100;

    if (targetGroundY != null) {
      final distance = targetGroundY! - ground.position.y;
      final direction = distance.sign;
      final moveAmount = speed * dt;

      if (distance.abs() <= moveAmount) {
        ground.position.y = targetGroundY!;
        targetGroundY = null;
        game.gameController.changeGameStep(GameStep.levelStart);
      } else {
        ground.position.y += direction * moveAmount;
      }
    }

    if (game.ressourceController.isEnnemyUnlocked) {
      timeSinceLastEnemy += dt;
      if (timeSinceLastEnemy >= enemySpawnRate) {
        game.combatController.addEnnemy(amount: enemyForce.toInt() * 2);
        if (enemyForce < 100) {
          enemyForce += 0.5;
        }
        if (enemyForce > 10 && enemyForce < 20) {
          enemySpawnRate = 30;
        } else if (enemyForce > 20 && enemyForce < 30) {
          enemySpawnRate = 40;
        } else if (enemyForce > 30 && enemyForce < 40) {
          enemySpawnRate = 50;
        } else if (enemyForce > 40 && enemyForce < 50) {
          enemySpawnRate = 60;
        }
        timeSinceLastEnemy = 0;
      }
    }

    super.update(dt);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    nightSkyShader.sampler(canvas: canvas, time: time, pos: Vector2(0, 0));
  }
}
