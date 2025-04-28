import 'package:flame/components.dart';

import '../controller/ressource_controller.dart';
import '../text/my_text_style.dart';

class ProductionNotification extends PositionComponent {
  ProductionNotification({required this.ressourceTypes, required this.amounts, required super.position})
    : initialY = position!.y;

  final List<RessourceType> ressourceTypes;
  final List<int> amounts;

  final double initialY;

  List<TextComponent> textComponents = [];

  @override
  void onLoad() {
    position.y -= (ressourceTypes.length - 1) * 15;
    anchor = Anchor.topLeft;

    for (int i = 0; i < ressourceTypes.length; i++) {
      String sign;

      if (amounts[i] > 0) {
        sign = "+";
      } else if (amounts[i] < 0) {
        sign = "-";
      } else {
        sign = "not";
      }

      final textComponent = TextComponent();

      if (sign == "not") {
        textComponent.text = "$sign enough ${ressourceTypes[i].name}";
        textComponent.textRenderer = MyTextStyle.smallTextRed;
      } else if (sign == "-") {
        textComponent.text = "${amounts[i]} ${ressourceTypes[i].name}";
        textComponent.textRenderer = MyTextStyle.smallTextGrey;
      } else {
        textComponent.text = "$sign ${amounts[i]} ${ressourceTypes[i].name}";
        textComponent.textRenderer = MyTextStyle.smallTextWhite;
      }

      textComponent.position = Vector2(0, i * 15);
      textComponent.anchor = Anchor.center;

      textComponents.add(textComponent);
    }

    addAll(textComponents);

    super.onLoad();
  }

  @override
  void update(double dt) {
    position.y -= 50 * dt;

    if (position.y < initialY - 50) {
      removeFromParent();
    }

    super.update(dt);
  }
}
