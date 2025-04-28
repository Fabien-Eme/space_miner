import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame/input.dart';
import 'package:flame_game_jam_2025/game/text/my_text_style.dart';
import 'package:flutter/material.dart';

import '../controller/building_controller.dart';
import '../controller/production_controller.dart';
import '../game.dart';

class SwitchProduction extends PositionComponent with HasGameReference<FGJ2025> {
  SwitchProduction({required this.buildingType, required super.position});

  final BuildingType buildingType;

  bool isOn = true;

  TextComponent onTextComponent = TextComponent();
  TextComponent offTextComponent = TextComponent();

  @override
  void onLoad() {
    anchor = Anchor.center;

    add(
      RowComponent(
        mainAxisAlignment: MainAxisAlignment.center,
        gap: 5,
        children: [
          ButtonComponent(
            button:
                onTextComponent = TextComponent(
                  text: "on",
                  textRenderer: (isOn) ? MyTextStyle.smallTextGreen : MyTextStyle.smallTextGrey,
                ),
            onPressed: () {
              switchProduction();
            },
          ),
          ButtonComponent(
            button:
                offTextComponent = TextComponent(
                  text: "off",
                  textRenderer: (isOn) ? MyTextStyle.smallTextGrey : MyTextStyle.smallTextRed,
                ),
            onPressed: () {
              switchProduction();
            },
          ),
        ],
      ),
    );
  }

  void switchProduction() {
    isOn = !isOn;
    onTextComponent.textRenderer = (isOn) ? MyTextStyle.smallTextGreen : MyTextStyle.smallTextGrey;
    offTextComponent.textRenderer = (isOn) ? MyTextStyle.smallTextGrey : MyTextStyle.smallTextRed;
    game.productionController.switchProduction(buildingType, isOn);
  }
}
