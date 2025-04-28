import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/foundation.dart';

import '../utils/game_assets.dart';
import '../utils/palette.dart';
import 'controller/audio_controller.dart';
import 'controller/building_controller.dart';
import 'controller/combat_controller.dart';
import 'controller/dialog_controller.dart';
import 'controller/game_controller.dart';
import 'controller/objective_controller.dart';
import 'controller/production_controller.dart';
import 'controller/ressource_controller.dart';
import 'router/router.dart';

class FGJ2025 extends FlameGame with TapDetector {
  static const double gameWidth = 960;
  static const double gameHeight = 540;

  late final RouterComponent router;

  late final FragmentShader spaceSkyShader;
  late final FragmentShader nightSkyShader;

  late final AudioController audioController;
  late final GameController gameController;
  late final DialogController dialogController;
  late final BuildingController buildingController;
  late final ProductionController productionController;
  late final RessourceController ressourceController;
  late final ObjectiveController objectiveController;
  late final CombatController combatController;

  bool hasIntroBeenPlayed = false;

  @override
  FutureOr<void> onLoad() async {
    /// Preload all images
    images.prefix = '';
    final futurePreLoadImages = preLoadAssetsImages().map((loadableBuilder) => loadableBuilder());
    await Future.wait<void>(futurePreLoadImages);

    ///Preload all sounds
    FlameAudio.audioCache.prefix = '';
    final futurePreLoadSounds = preLoadAssetsSounds().map((loadableBuilder) => loadableBuilder());
    await Future.wait<void>(futurePreLoadSounds);

    FragmentProgram spaceSkyProgram = await FragmentProgram.fromAsset('assets/shaders/space_sky.frag');
    spaceSkyShader = spaceSkyProgram.fragmentShader();

    FragmentProgram nightSkyProgram = await FragmentProgram.fromAsset('assets/shaders/night_sky.frag');
    nightSkyShader = nightSkyProgram.fragmentShader();

    addAll([
      audioController = AudioController(),
      gameController = GameController(),
      dialogController = DialogController(),
      buildingController = BuildingController(),
      productionController = ProductionController(),
      ressourceController = RessourceController(),
      objectiveController = ObjectiveController(),
      combatController = CombatController(),
    ]);

    /// Add router
    add(router = GameRouter());

    if (kDebugMode) add(FpsTextComponent());

    return super.onLoad();
  }

  @override
  Color backgroundColor() {
    return Palette.trueBlack;
  }

  @override
  void onTapDown(TapDownInfo info) {
    super.onTapDown(info);
    gameController.onGameTapDown(info);
  }
}
