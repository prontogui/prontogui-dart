// Copyright 2024-2026 ProntoGUI, LLC
// ProntoGUI™ is a trademark of ProntoGUI, LLC
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:test/test.dart';
import 'package:prontogui/src/check.dart';
import 'package:prontogui/src/enums.dart';
import 'test_cbor_samples.dart';
import 'package:prontogui/src/pkey.dart';

void main() {
  group('Check', () {
    test('Default constructor initializes with default values', () {
      final check = Check();
      expect(check.checked, false);
      expect(check.label, '');
    });

    test('Constructor initializes with provided values', () {
      final check = Check(checked: true, label: 'Accept Terms');
      expect(check.checked, true);
      expect(check.label, 'Accept Terms');
    });

    test('style getter and setter work correctly', () {
      final check = Check();
      expect(check.style, isNull);
      check.style = CheckStyle.toggleButton;
      expect(check.style, CheckStyle.toggleButton);
    });

    test('Checked getter and setter work correctly', () {
      final check = Check();
      check.checked = true;
      expect(check.checked, true);
      check.checked = false;
      expect(check.checked, false);
    });

    test('Label getter and setter work correctly', () {
      final check = Check();
      check.label = 'New Label';
      expect(check.label, 'New Label');
    });

    test('toString returns label', () {
      final check = Check(label: 'Sample Label');
      expect(check.toString(), 'Sample Label');
    });

    test('describeType returns correct type', () {
      final check = Check();
      expect(check.describeType, 'Check');
    });

    test('nextState toggles the checked state', () {
      final check = Check();
      expect(check.checked, false);
      check.nextState();
      expect(check.checked, true);
      check.nextState();
      expect(check.checked, false);
    });

    test('all fields are added', () {
      final command = Check();
      expect(
          () => command.initializeFromCborMap(PKey(0), cborForCheck('Turn On')),
          returnsNormally);
    });
  });
}
