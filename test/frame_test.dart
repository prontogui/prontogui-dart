// Copyright 2024-2026 ProntoGUI, LLC
// ProntoGUI™ is a trademark of ProntoGUI, LLC
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:test/test.dart';
import 'package:prontogui/src/frame.dart';
import 'package:prontogui/src/text.dart';
import 'package:prontogui/src/pkey.dart';

void main() {
  group('Frame', () {
    test('should initialize with default values', () {
      final frame = Frame();

      expect(frame.items, isEmpty);
      expect(frame.status, 0);
    });

    test('should initialize with provided values', () {
      final primitive = Text();
      final frame = Frame(items: [primitive]);

      expect(frame.items, contains(primitive));
    });

    test('should update items', () {
      final frame = Frame();
      final primitive = Text();

      frame.items = [primitive];

      expect(frame.items, contains(primitive));
    });

    test('should describe type correctly', () {
      final frame = Frame();

      expect(frame.describeType, 'Frame');
    });

    test('should locate next descendant correctly', () {
      var primitive1 = Text();
      var primitive2 = Text();
      var frame = Frame(items: [primitive1, primitive2]);
      var locator = PKeyLocator(PKey(0, 1));
      var descendant = frame.locateNextDescendant(locator);
      expect(descendant, primitive2);
    });

    test('should throw exception for out of bounds locator', () {
      final frame = Frame();
      final locator = PKeyLocator(PKey(0));
      locator.nextIndex();

      expect(() => frame.locateNextDescendant(locator), throwsException);
    });
  });
}
