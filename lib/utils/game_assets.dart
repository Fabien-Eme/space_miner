import 'package:flame/extensions.dart';
import 'package:flame_audio/flame_audio.dart';

import '../game/game.dart';
import '../gen/assets.gen.dart';

extension MGameAssets on FGJ2025 {
  List<Future<Image> Function()> preLoadAssetsImages() {
    return [
      for (AssetGenImage element in Assets.images.values) () => images.load(element.path),
      for (AssetGenImage element in Assets.images.miner.values) () => images.load(element.path),
      for (AssetGenImage element in Assets.images.furnace.values) () => images.load(element.path),
      for (AssetGenImage element in Assets.images.rocket.values) () => images.load(element.path),
      for (AssetGenImage element in Assets.images.rocketPad.values) () => images.load(element.path),
      for (AssetGenImage element in Assets.images.turret.values) () => images.load(element.path),
      for (AssetGenImage element in Assets.images.ennemy.values) () => images.load(element.path),
      for (AssetGenImage element in Assets.images.armory.values) () => images.load(element.path),
    ];
  }

  List<Future<Uri> Function()> preLoadAssetsSounds() {
    return [
      for (String element in Assets.audio.music.values) () => FlameAudio.audioCache.load(element),
      for (String element in Assets.audio.sfx.values) () => FlameAudio.audioCache.load(element),
    ];
  }
}
