import 'package:flame/text.dart';

import '../../utils/palette.dart';

class MyTextStyle {
  static TextPaint titleWhite = TextPaint(style: const TextStyle(fontSize: 36, color: Palette.white));
  static TextPaint titleBlack = TextPaint(style: const TextStyle(fontSize: 36, color: Palette.black));

  static TextPaint headerWhite = TextPaint(style: const TextStyle(fontSize: 22, color: Palette.white));
  static TextPaint headerRed = TextPaint(style: const TextStyle(fontSize: 22, color: Palette.red));
  static TextPaint headerDarkGrey = TextPaint(style: const TextStyle(fontSize: 22, color: Palette.darkGrey));
  static TextPaint headerBlack = TextPaint(style: const TextStyle(fontSize: 22, color: Palette.black));

  static TextPaint textWhite = TextPaint(style: const TextStyle(fontSize: 20, color: Palette.white));
  static TextPaint textDarkGrey = TextPaint(style: const TextStyle(fontSize: 20, color: Palette.darkGrey));
  static TextPaint textBlack = TextPaint(style: const TextStyle(fontSize: 20, color: Palette.black));

  static TextPaint smallTextWhite = TextPaint(style: const TextStyle(fontSize: 14, color: Palette.white));
  static TextPaint smallTextRed = TextPaint(style: const TextStyle(fontSize: 14, color: Palette.red));
  static TextPaint smallTextGrey = TextPaint(style: const TextStyle(fontSize: 14, color: Palette.grey));
  static TextPaint smallTextBlack = TextPaint(style: const TextStyle(fontSize: 14, color: Palette.black));
  static TextPaint smallTextGreen = TextPaint(style: const TextStyle(fontSize: 14, color: Palette.green));
}
