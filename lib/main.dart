import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import 'flame_game_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  WakelockPlus.enable();
  // Put game into full screen mode on mobile devices.
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  // Lock the game to landscape mode on mobile devices.
  await SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);

  runApp(
    MaterialApp(
      title: 'Time of Adventure',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorScheme: ColorScheme.fromSeed(seedColor: Colors.tealAccent[200]!)),
      home: const FlameGameWidget(),
    ),
  );
}
