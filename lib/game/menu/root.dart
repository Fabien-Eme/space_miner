import 'package:flame/components.dart';

import '../game.dart';

class Root extends Component with HasGameReference<FGJ2025> {
  @override
  void onLoad() {
    super.onLoad();
    game.router.pushNamed('mainMenu');
  }
}
