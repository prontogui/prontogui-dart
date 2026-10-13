// Copyright 2024-2026 ProntoGUI, LLC
// ProntoGUI™ is a trademark of ProntoGUI, LLC
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:test/test.dart';
import 'package:prontogui/src/list.dart';
import 'package:prontogui/src/text.dart';
import 'package:prontogui/src/pkey.dart';

void main() {
  group('ListP', () {
    test('should initialize with default values', () {
      var listP = ListP();
      expect(listP.listItems, isEmpty);
    });

    test('should set and get listItems', () {
      var primitive1 = Text();
      var primitive2 = Text();
      var listP = ListP(listItems: [primitive1, primitive2]);

      expect(listP.listItems, [primitive1, primitive2]);
    });

    test('should throw exception for out of bounds locator', () {
      var listP = ListP();
      final locator = PKeyLocator(PKey(0));
      locator.nextIndex();
      expect(() => listP.locateNextDescendant(locator), throwsException);
    });
  });
}
