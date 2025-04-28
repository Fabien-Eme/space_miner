import 'dart:async';
import 'dart:convert';

import 'package:flame/components.dart';
import 'package:flutter/services.dart';

import '../../gen/assets.gen.dart';
import '../dialog/dialog_component.dart';
import '../game.dart';
import '../level/level_world.dart';
import 'game_controller.dart';

class DialogController extends Component with HasGameReference<FGJ2025> {
  bool isADialogActive = false;

  DialogSequence? activeDialogSequence;
  DialogComponent? dialogComponent;

  Map<String, dynamic> allDialogs = {};

  @override
  FutureOr<void> onLoad() async {
    String allDialogsJson = await rootBundle.loadString(Assets.json.allDialogs);
    allDialogs = jsonDecode(allDialogsJson);

    return super.onLoad();
  }

  void showDialog(DialogSequence dialogSequence) {
    isADialogActive = true;
    activeDialogSequence = dialogSequence;

    levelWorld.add(dialogComponent = DialogComponent(dialogSequence: allDialogs[dialogSequence.name], priority: 100));
  }

  void onGameTapDown() {
    if (isADialogActive) {
      if (dialogComponent?.nextDialog() ?? true) {
        isADialogActive = false;

        onDialogEnd(activeDialogSequence!);

        dialogComponent = null;
        activeDialogSequence = null;
      }
    }
  }

  void onDialogEnd(DialogSequence dialogSequence) {
    switch (dialogSequence) {
      case DialogSequence.intro:
        game.gameController.changeGameStep(GameStep.levelGetInPlace);
        break;
      case DialogSequence.gameWon:
        game.router.pushReplacementNamed('mainMenu');
        break;
      case DialogSequence.gameLost:
        game.router.pushReplacementNamed('mainMenu');
        break;
      default:
        break;
    }
  }

  LevelWorld get levelWorld => game.findByKeyName('levelWorld') as LevelWorld;
}

enum DialogSequence {
  intro,
  buildAMiner,
  timeToMakePlate,
  buildARocketPad,
  buildATurret,
  outOfAmmo,
  manageEconomy,
  gameWon,
  gameLost,
}
