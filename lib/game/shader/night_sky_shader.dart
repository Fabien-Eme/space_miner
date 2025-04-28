import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/extensions.dart';

import '../game.dart';

class NightSkyShader extends Component with HasGameReference<FGJ2025> {
  void sampler({required Canvas canvas, required double time, required Vector2 pos}) {
    FragmentShader shader = game.nightSkyShader;

    shader.setFloatUniforms((value) {
      value
        ..setFloat(time)
        ..setVector(pos)
        ..setVector(Vector2(FGJ2025.gameWidth, FGJ2025.gameHeight));
    });

    canvas.save();
    canvas.drawRect(
      Rect.fromLTWH(-FGJ2025.gameWidth / 2, -FGJ2025.gameHeight / 2, FGJ2025.gameWidth, FGJ2025.gameHeight),
      Paint()
        ..shader = shader
        ..blendMode = BlendMode.srcOver,
    );
    canvas.restore();
  }
}
