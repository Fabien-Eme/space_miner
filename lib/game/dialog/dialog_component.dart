import 'dart:async';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../../utils/palette.dart';
import '../game.dart';

class DialogComponent extends PositionComponent with HasGameReference<FGJ2025> {
  DialogComponent({required this.dialogSequence, super.priority});

  final dynamic dialogSequence;

  int currentDialogIndex = 0;

  late TextBoxComponent textBoxComponent;
  late final TextComponent dotComponent;

  final double dialogY = 175;

  @override
  FutureOr<void> onLoad() async {
    add(DialogContainerComponent(position: Vector2(0, dialogY)));
    add(
      textBoxComponent = TextBoxComponent(
        anchor: Anchor.center,
        position: Vector2(0, dialogY),
        size: Vector2(575, 135),
        text: dialogSequence[currentDialogIndex],
        boxConfig: TextBoxConfig(timePerChar: 0.02),
      ),
    );
    add(dotComponent = TextComponent(anchor: Anchor.center, position: Vector2(275, dialogY + 50), text: '...'));

    return super.onLoad();
  }

  bool nextDialog() {
    if (currentDialogIndex < dialogSequence.length - 1) {
      currentDialogIndex++;

      remove(textBoxComponent);
      textBoxComponent.removed.then((_) {
        add(
          textBoxComponent = TextBoxComponent(
            anchor: Anchor.center,
            position: Vector2(0, dialogY),
            size: Vector2(575, 135),
            text: dialogSequence[currentDialogIndex],
            boxConfig: TextBoxConfig(timePerChar: 0.02),
          ),
        );
      });

      if (currentDialogIndex == dialogSequence.length - 1) remove(dotComponent);
      return false;
    } else {
      removeFromParent();
      return true;
    }
  }
}

class DialogContainerComponent extends PositionComponent {
  DialogContainerComponent({super.position});

  @override
  FutureOr<void> onLoad() {
    add(CustomPainterComponent(anchor: Anchor.center, size: Vector2(600, 150), painter: _DialogBoxPainter()));
    return super.onLoad();
  }
}

class _DialogBoxPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rect = RRect.fromRectAndRadius(Rect.fromLTWH(0, 0, size.width, size.height), const Radius.circular(5));
    canvas.drawRRect(
      rect,
      Paint()
        ..color = Palette.darkBlue
        ..style = PaintingStyle.fill
        ..isAntiAlias = true,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
