// Copyright 2024-2026 ProntoGUI, LLC
// ProntoGUI™ is a trademark of ProntoGUI, LLC
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:prontogui/prontogui.dart';
import 'package:prontogui/src/pkey.dart';
import 'package:test/test.dart';

void main() {
  group('ColorField', () {
    test('defaults + describeType', () {
      var cf = ColorField();
      expect(cf.colorEntry, '');
      expect(cf.allowEmptyValue, isFalse);
      expect(cf.focusSelection, isNull);
      expect(cf.status, 0);
      expect(cf.describeType, 'ColorField');
      expect(cf.isNotificationHandled(Notify.change), isFalse);
    });

    test('fields round-trip', () {
      var cf = ColorField(
        colorEntry: '#FF3366CC',
        allowEmptyValue: true,
        focusSelection: FocusSelection.all,
      );
      expect(cf.colorEntry, '#FF3366CC');
      expect(cf.allowEmptyValue, isTrue);
      expect(cf.focusSelection, FocusSelection.all);

      cf.colorEntry = '#FF000000';
      expect(cf.colorEntry, '#FF000000');
      expect(cf.toString(), '#FF000000');
    });

    test('has no child primitives', () {
      var cf = ColorField();
      expect(
          () => cf.locateNextDescendant(PKeyLocator(PKey(0))), throwsException);
    });
  });
}
