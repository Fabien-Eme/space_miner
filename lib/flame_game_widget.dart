import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'game/game.dart';

class FlameGameWidget extends StatelessWidget {
  const FlameGameWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GameWidget<FGJ2025>(game: FGJ2025());
  }
}
