import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';

import '../controller/audio_controller.dart';
import '../game.dart';
import '../shader/space_sky_shader.dart';

class MainMenu extends PositionComponent with HasGameReference<FGJ2025> {
  final World world = World();
  late final CameraComponent cameraComponent;

  late final SpaceSkyShader spaceSkyShader;

  late final PositionComponent menuComponent;
  late final PositionComponent optionsComponent;

  late final RectangleComponent outroComponent;

  late final TextComponent musicVolumeText;
  late final TextComponent sfxVolumeText;

  double yOffset = 0;
  double introTimeElapsed = 0;
  double totalYOffset = 3618;

  bool isIntroFinished = false;
  bool hasOutroStarted = false;
  bool isOutroFinished = false;

  double outroTimeElapsed = 0;
  int outroAlpha = 0;

  double magnifyingEffect = 0.000001;

  @override
  FutureOr<void> onLoad() {
    if (game.hasIntroBeenPlayed) isIntroFinished = true;
    if (isIntroFinished) totalYOffset = 0;

    add(world);

    add(
      cameraComponent = CameraComponent.withFixedResolution(
        width: FGJ2025.gameWidth,
        height: FGJ2025.gameHeight,
        world: world,
      ),
    );

    world.add(spaceSkyShader = SpaceSkyShader());

    world.add(
      menuComponent = ColumnComponent(
        position: Vector2(-FGJ2025.gameWidth / 2, -FGJ2025.gameHeight / 2 - totalYOffset),
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        size: Vector2(FGJ2025.gameWidth, FGJ2025.gameHeight),
        gap: 50,
        children: [
          ButtonComponent(
            onPressed: () {
              startOutro();
            },
            button: TextComponent(text: 'NEW GAME'),
          ),
          ButtonComponent(onPressed: onOptionsPressed, button: TextComponent(text: 'OPTIONS')),
        ],
      ),
    );

    game.audioController.playBackgroundMusic();

    initOptionsComponent();

    return super.onLoad();
  }

  void initOptionsComponent() {
    ComponentsNotifier<AudioController> audioNotifier = game.componentsNotifier<AudioController>();
    audioNotifier.addListener(() {
      musicVolumeText.text = (game.audioController.musicVolume * 100).toStringAsFixed(0);
      sfxVolumeText.text = (game.audioController.sfxVolume * 100).toStringAsFixed(0);
    });

    optionsComponent = ColumnComponent(
      position: Vector2(-FGJ2025.gameWidth / 2, -FGJ2025.gameHeight / 2),
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      size: Vector2(FGJ2025.gameWidth, FGJ2025.gameHeight),
      gap: 50,
      children: [
        RowComponent(
          mainAxisAlignment: MainAxisAlignment.center,
          gap: 100,
          children: [
            TextComponent(text: 'MUSIC'),

            RowComponent(
              mainAxisAlignment: MainAxisAlignment.center,
              gap: 25,
              children: [
                ButtonComponent(
                  onPressed: () {
                    game.audioController.setMusicVolume(game.audioController.musicVolume - 0.1);
                  },
                  button: TextComponent(text: '<'),
                ),
                musicVolumeText = TextComponent(
                  anchor: Anchor.topCenter,
                  text: (game.audioController.musicVolume * 100).toStringAsFixed(0),
                ),
                ButtonComponent(
                  onPressed: () {
                    game.audioController.setMusicVolume(game.audioController.musicVolume + 0.1);
                  },
                  button: TextComponent(text: '>'),
                ),
              ],
            ),
          ],
        ),
        RowComponent(
          mainAxisAlignment: MainAxisAlignment.center,
          gap: 100,
          children: [
            TextComponent(text: 'SFX    '),

            RowComponent(
              mainAxisAlignment: MainAxisAlignment.center,
              gap: 25,
              children: [
                ButtonComponent(
                  onPressed: () {
                    game.audioController.setSfxVolume(game.audioController.sfxVolume - 0.1);
                  },
                  button: TextComponent(text: '<'),
                ),
                sfxVolumeText = TextComponent(
                  anchor: Anchor.topCenter,
                  text: (game.audioController.sfxVolume * 100).toStringAsFixed(0),
                ),
                ButtonComponent(
                  onPressed: () {
                    game.audioController.setSfxVolume(game.audioController.sfxVolume + 0.1);
                  },
                  button: TextComponent(text: '>'),
                ),
              ],
            ),
          ],
        ),
        PositionComponent(),
        ButtonComponent(
          onPressed: () {
            world.remove(optionsComponent);
            world.add(menuComponent);
          },
          button: TextComponent(text: 'BACK'),
        ),
      ],
    );
  }

  void onOptionsPressed() {
    world.remove(menuComponent);
    world.add(optionsComponent);
  }

  void introHasFinished() {
    game.hasIntroBeenPlayed = true;
  }

  void outroHasFinished() {
    isOutroFinished = true;
    Future.delayed(Duration(seconds: 1), () {
      game.router.pushReplacementNamed('level');
    });
  }

  void startOutro() {
    hasOutroStarted = true;
    world.remove(menuComponent);

    cameraComponent.viewfinder.zoom = 0.000001;

    world.add(
      outroComponent = RectangleComponent(
        position: Vector2(-FGJ2025.gameWidth / 2 * 1000000, -FGJ2025.gameHeight / 2 * 1000000),
        size: Vector2(FGJ2025.gameWidth * 1000000, FGJ2025.gameHeight * 1000000),
        paint: Paint()..color = Colors.black.withAlpha(0),
        priority: 0,
      ),
    );

    world.add(
      CircleComponent(
        anchor: Anchor.center,
        position: Vector2(0, 1000000),
        radius: 1000000,
        paint: Paint()..color = Colors.white,
        priority: 1,
      ),
    );
  }

  double time = 0;
  Vector2 pos = Vector2(-100, -100);

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    spaceSkyShader.sampler(canvas: canvas, time: time, pos: pos);
  }

  @override
  void update(double dt) {
    super.update(dt);
    time += 0.005 * dt;
    pos.y += 50 * dt;
    pos.x += 20 * dt;

    if (!isIntroFinished) {
      pos.y += yOffset * dt;
      menuComponent.position.y += yOffset * dt;

      introTimeElapsed += dt;
      if (introTimeElapsed < 1) {
        yOffset += 50 * dt;
      } else if (introTimeElapsed < 2) {
        yOffset += 100 * dt;
      } else if (introTimeElapsed < 4) {
        yOffset += 200 * dt;
      } else if (introTimeElapsed > 10) {
        yOffset = 0;
        introHasFinished();
      } else if (introTimeElapsed > 9) {
        yOffset -= 100 * dt;
      } else if (introTimeElapsed > 8) {
        yOffset -= 300 * dt;
      }
    }

    if (hasOutroStarted && !isOutroFinished) {
      outroTimeElapsed += dt;
      outroAlpha = (outroTimeElapsed / 5 * 255).toInt();
      if (outroAlpha < 255) {
        outroComponent.paint.color = Colors.black.withAlpha(outroAlpha);
      } else {
        outroComponent.paint.color = Colors.black.withAlpha(255);
      }

      if (cameraComponent.viewfinder.zoom < 1) {
        cameraComponent.viewfinder.zoom += magnifyingEffect * dt;
        magnifyingEffect += magnifyingEffect * 2 * dt;
      } else {
        outroHasFinished();
      }
    }
  }
}
