// Copyright 2024-2026 ProntoGUI, LLC
// ProntoGUI™ is a trademark of ProntoGUI, LLC
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

/// A packed 32-bit ARGB color value (0xAARRGGBB) — alpha in the highest
/// byte, then red, green, blue. This is the same bit layout Flutter's own
/// `dart:ui.Color` uses, which is deliberate: dartlib itself stays
/// Flutter-free (see pubspec.yaml), but the app that renders it is Flutter,
/// so a color crosses the wire as one integer and reaches `Color(value)` at
/// the other end with no conversion.
///
/// The zero value, 0x00000000, is fully transparent black — treated as this
/// type's "unset" state (see ColorValueField.isDefault), which is why it's a
/// sensible default rather than an arbitrary one: fully transparent paints
/// nothing, so an unset color behaves the same as one that's absent from
/// the wire entirely. Where transparent must be a choosable value distinct
/// from "not specified", the field is optional instead (ColorOptField, schema
/// type `color?` - see app_core/specs/OPTIONAL-FIELDS.md).
class Color {
  const Color(this.value);

  const Color.fromARGB(int a, int r, int g, int b)
      : value = ((a & 0xff) << 24) |
            ((r & 0xff) << 16) |
            ((g & 0xff) << 8) |
            (b & 0xff);

  const Color.fromRGB(int r, int g, int b) : this.fromARGB(0xff, r, g, b);

  /// The packed 0xAARRGGBB value.
  final int value;

  int get alpha => (value >> 24) & 0xff;
  int get red => (value >> 16) & 0xff;
  int get green => (value >> 8) & 0xff;
  int get blue => value & 0xff;

  /// Returns a copy of this color with the alpha component replaced.
  Color withAlpha(int a) => Color.fromARGB(a, red, green, blue);

  /// The canonical "#AARRGGBB" representation of this color.
  String toHex() => '#${value.toRadixString(16).padLeft(8, '0').toUpperCase()}';

  /// Parses a hex color string into a Color. Accepts an optional leading
  /// '#', and either 6 digits (RRGGBB, alpha assumed fully opaque) or 8
  /// digits (AARRGGBB). Returns null if the string isn't a valid color.
  static Color? fromHex(String hex) {
    var s = hex.trim();
    if (s.startsWith('#')) {
      s = s.substring(1);
    }

    if (s.length == 6) {
      s = 'FF$s';
    } else if (s.length != 8) {
      return null;
    }

    final parsed = int.tryParse(s, radix: 16);
    if (parsed == null) {
      return null;
    }

    return Color(parsed);
  }

  @override
  bool operator ==(Object other) => other is Color && other.value == value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => toHex();
}

/// A small named color palette, for convenience — common in GUI libraries so
/// a quick prototype doesn't need to hand-compute hex values for the obvious
/// cases. Kept as a separate class (mirroring Flutter's own Color/Colors
/// split) because `red`/`green`/`blue` would otherwise collide with Color's
/// own component getters of the same name.
abstract class Colors {
  static const transparent = Color(0x00000000);
  static const black = Color(0xFF000000);
  static const white = Color(0xFFFFFFFF);
  static const red = Color(0xFFFF0000);
  static const green = Color(0xFF00FF00);
  static const blue = Color(0xFF0000FF);
}
