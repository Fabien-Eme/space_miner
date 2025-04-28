import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flutter/material.dart';

import '../controller/building_controller.dart';
import '../controller/ressource_controller.dart';
import '../game.dart';
import '../text/my_text_style.dart';

class BuildingCostDisplay extends PositionComponent with HasGameReference<FGJ2025> {
  BuildingCostDisplay({required this.buildingType, super.position});

  final BuildingType buildingType;

  ColumnComponent? columnComponent;

  Map<RessourceType, int> cost = {};

  late final ComponentsNotifier<BuildingController> buildingControllerNotifier;
  late final VoidCallback buildingControllerListener;

  late final ComponentsNotifier<RessourceController> ressourceControllerNotifier;
  late final VoidCallback ressourceControllerListener;

  @override
  void onLoad() {
    anchor = Anchor.bottomCenter;
    cost = game.buildingController.getCost(buildingType);

    columnComponent = buildColumnComponent();
    add(columnComponent!);

    super.onLoad();
  }

  @override
  void onMount() {
    super.onMount();

    buildingControllerNotifier = game.componentsNotifier<BuildingController>();
    buildingControllerListener = () async {
      cost = game.buildingController.getCost(buildingType);
      rebuildColumnComponent();
    };
    buildingControllerNotifier.addListener(buildingControllerListener);

    ressourceControllerNotifier = game.componentsNotifier<RessourceController>();
    ressourceControllerListener = () async {
      rebuildColumnComponent();
    };
    ressourceControllerNotifier.addListener(ressourceControllerListener);
  }

  void rebuildColumnComponent() async {
    remove(columnComponent!);
    columnComponent = buildColumnComponent();
    add(columnComponent!);
  }

  ColumnComponent buildColumnComponent() {
    List<TextComponent> textComponents = [];

    for (var entry in cost.entries) {
      TextPaint textPaint;

      if (entry.value <= game.ressourceController.getAmount(entry.key)) {
        textPaint = MyTextStyle.smallTextBlack;
      } else {
        textPaint = MyTextStyle.smallTextRed;
      }

      textComponents.add(TextComponent(text: "${entry.value} ${entry.key.name}", textRenderer: textPaint));
    }

    return ColumnComponent(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      gap: -3,
      children: textComponents,
    );
  }

  @override
  void onRemove() {
    buildingControllerNotifier.removeListener(buildingControllerListener);
    ressourceControllerNotifier.removeListener(ressourceControllerListener);
    super.onRemove();
  }
}
