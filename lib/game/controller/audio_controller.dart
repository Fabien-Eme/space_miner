import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';

import '../../../gen/assets.gen.dart';
import '../game.dart';

class AudioController extends Component with HasGameReference<FGJ2025>, Notifier {
  double musicVolume = 0.8;
  double sfxVolume = 1.0;
  double dialogVolume = 0.75;

  bool hasTakingAHitLately = false;
  double lastTakingAHitTime = 0;

  @override
  FutureOr<void> onLoad() {
    FlameAudio.bgm.initialize();

    return super.onLoad();
  }

  Future<void> playBackgroundMusic() async {
    if (FlameAudio.bgm.isPlaying) return;
    if (!game.hasIntroBeenPlayed) {
      AudioPlayer intro = await FlameAudio.play(Assets.audio.music.intro, volume: musicVolume);
      intro.onPlayerComplete.listen((_) {
        FlameAudio.bgm.play(Assets.audio.music.mainLoop, volume: musicVolume);
      });
    } else {
      if (FlameAudio.bgm.audioPlayer.state == PlayerState.stopped) {
        FlameAudio.bgm.play(Assets.audio.music.mainLoop, volume: musicVolume);
      }
    }
  }

  void playSound(SoundType soundType) {
    switch (soundType) {
      case SoundType.buildingBuilt:
        FlameAudio.play(Assets.audio.sfx.buildingBuilt, volume: sfxVolume);
        break;
      case SoundType.fireBullet:
        FlameAudio.play(Assets.audio.sfx.fireBullet, volume: sfxVolume);
        break;
      case SoundType.takeAHit:
        if (hasTakingAHitLately) return;
        FlameAudio.play(Assets.audio.sfx.takeHit, volume: sfxVolume);
        hasTakingAHitLately = true;
        break;
      case SoundType.ennemyDestroyed:
        FlameAudio.play(Assets.audio.sfx.ennemyDestroyed, volume: sfxVolume);
        break;
    }
  }

  // void playDialog(DialogName dialogName) {
  //   switch (dialogName) {
  //     case DialogName.bienvenue:
  //       FlameAudio.play(Assets.audio.dialog.bienvenue, volume: dialogVolume);
  //       break;

  //     case DialogName.prenezVosCarnets:
  //       FlameAudio.play(Assets.audio.dialog.prenezVosCarnets, volume: dialogVolume);
  //       break;
  //   }
  // }

  void setMusicVolume(double volume) {
    volume = clampDouble(volume, 0, 1);
    musicVolume = volume;
    FlameAudio.bgm.audioPlayer.setVolume(volume);
    notifyListeners();
  }

  void setSfxVolume(double volume) {
    volume = clampDouble(volume, 0, 1);

    sfxVolume = volume;
    notifyListeners();
  }

  void setDialogVolume(double volume) {
    volume = clampDouble(volume, 0, 1);

    dialogVolume = volume;
    notifyListeners();
  }

  double getMusicVolume() {
    return musicVolume;
  }

  double getSfxVolume() {
    return sfxVolume;
  }

  @override
  void update(double dt) {
    if (hasTakingAHitLately) {
      lastTakingAHitTime += dt;
      if (lastTakingAHitTime > 0.5) {
        hasTakingAHitLately = false;
        lastTakingAHitTime = 0;
      }
    }
  }
}

enum SoundType { buildingBuilt, fireBullet, takeAHit, ennemyDestroyed }
