// Copyright 2024-2026 ProntoGUI, LLC
// ProntoGUI™ is a trademark of ProntoGUI, LLC
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:test/test.dart';
import 'package:prontogui/src/color.dart';

void main() {
  group('Color', () {
    test('fromRGB defaults to fully opaque', () {
      final c = Color.fromRGB(0x11, 0x22, 0x33);
      expect(c.alpha, equals(0xff));
      expect(c.red, equals(0x11));
      expect(c.green, equals(0x22));
      expect(c.blue, equals(0x33));
    });

    test('fromARGB packs components correctly', () {
      final c = Color.fromARGB(0x44, 0x11, 0x22, 0x33);
      expect(c.value, equals(0x44112233));
      expect(c.alpha, equals(0x44));
      expect(c.red, equals(0x11));
      expect(c.green, equals(0x22));
      expect(c.blue, equals(0x33));
    });

    test('withAlpha preserves RGB while changing alpha', () {
      final c = Color.fromRGB(0x11, 0x22, 0x33).withAlpha(0x80);
      expect(c.alpha, equals(0x80));
      expect(c.red, equals(0x11));
      expect(c.green, equals(0x22));
      expect(c.blue, equals(0x33));
    });

    test('toHex returns canonical AARRGGBB form', () {
      final c = Color.fromARGB(0x44, 0x11, 0x22, 0x33);
      expect(c.toHex(), equals('#44112233'));
      expect(c.toString(), equals(c.toHex()));
    });

    test('fromHex parses 6-digit RRGGBB as fully opaque', () {
      final c = Color.fromHex('#112233');
      expect(c, isNotNull);
      expect(c!.alpha, equals(0xff));
      expect(c.red, equals(0x11));
      expect(c.green, equals(0x22));
      expect(c.blue, equals(0x33));
    });

    test('fromHex parses 8-digit AARRGGBB', () {
      final c = Color.fromHex('44112233');
      expect(c, isNotNull);
      expect(c!.alpha, equals(0x44));
      expect(c.red, equals(0x11));
      expect(c.green, equals(0x22));
      expect(c.blue, equals(0x33));
    });

    test('fromHex returns null for invalid input', () {
      expect(Color.fromHex('#12345'), isNull);
      expect(Color.fromHex('#ZZZZZZ'), isNull);
    });

    test('round trips through hex', () {
      final original = Color.fromARGB(0xab, 0xcd, 0xef, 0x12);
      final parsed = Color.fromHex(original.toHex());
      expect(parsed, equals(original));
    });

    test('equality and hashCode are value-based', () {
      final a = Color.fromRGB(1, 2, 3);
      final b = Color.fromRGB(1, 2, 3);
      expect(a, equals(b));
      expect(a.hashCode, equals(b.hashCode));
    });

    test('named palette', () {
      expect(Colors.transparent.value, equals(0));
      expect(Colors.black, equals(Color.fromRGB(0, 0, 0)));
      expect(Colors.white, equals(Color.fromRGB(0xff, 0xff, 0xff)));
      expect(Colors.red, equals(Color.fromRGB(0xff, 0, 0)));
      expect(Colors.green, equals(Color.fromRGB(0, 0xff, 0)));
      expect(Colors.blue, equals(Color.fromRGB(0, 0, 0xff)));
    });
  });
}
