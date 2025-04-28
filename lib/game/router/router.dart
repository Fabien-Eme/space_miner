import 'package:flame/components.dart';
import 'package:flame/game.dart';

import '../level/level.dart';
import '../menu/begin_menu.dart';
import '../menu/main_menu.dart' show MainMenu;
import '../menu/root.dart';

class GameRouter extends RouterComponent {
  GameRouter()
    : super(
        initialRoute: 'root',
        routes: {
          'root': Route(Root.new, maintainState: false),

          'mainMenu': Route(MainMenu.new, maintainState: false),
          'beginMenu': Route(BeginMenu.new, maintainState: false),

          'level': Route(() => Level(key: ComponentKey.named('level')), maintainState: false),
        },
      );
}
