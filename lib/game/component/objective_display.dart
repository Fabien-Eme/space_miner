import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flutter/material.dart';

import '../../utils/palette.dart';
import '../controller/objective_controller.dart';
import '../game.dart';
import '../text/my_text_style.dart';

class ObjectiveDisplay extends PositionComponent with HasGameReference<FGJ2025> {
  ObjectiveDisplay({required this.objective, super.position});

  Objective objective;

  late final ComponentsNotifier<ObjectiveController> objectiveControllerNotifier;
  late final VoidCallback objectiveControllerListener;

  late RowComponent rowComponent;

  @override
  void onLoad() {
    super.onLoad();

    anchor = Anchor.topLeft;

    rowComponent = buildObjectiveRow();
    add(rowComponent);
  }

  RowComponent buildObjectiveRow() {
    return RowComponent(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      gap: 15,
      children: [
        TextComponent(text: objective.displayText, textRenderer: MyTextStyle.textWhite),

        ColumnComponent(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RectangleComponent(size: Vector2(0, 5), paint: null),
            RectangleComponent.square(
              size: 17,
              paint:
                  Paint()
                    ..style = (objective.isCompleted) ? PaintingStyle.fill : PaintingStyle.stroke
                    ..strokeWidth = 3
                    ..color = Palette.white,
            ),
          ],
        ),
      ],
    );
  }

  @override
  void onMount() {
    objectiveControllerNotifier = game.componentsNotifier<ObjectiveController>();
    objectiveControllerListener = () async {
      final bool isObjectiveCompleted = game.objectiveController.isObjectiveCompleted(objective.title);

      if (isObjectiveCompleted) {
        objective.isCompleted = true;
        remove(rowComponent);

        await rowComponent.removed;

        rowComponent = buildObjectiveRow();
        add(rowComponent);
      }
    };
    objectiveControllerNotifier.addListener(objectiveControllerListener);
    super.onMount();
  }

  @override
  void onRemove() {
    objectiveControllerNotifier.removeListener(objectiveControllerListener);
    super.onRemove();
  }
}
