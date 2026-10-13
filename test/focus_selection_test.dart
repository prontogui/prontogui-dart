// Copyright 2024-2026 ProntoGUI, LLC
// ProntoGUI™ is a trademark of ProntoGUI, LLC
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:cbor/cbor.dart';
import 'package:prontogui/prontogui.dart';
import 'package:test/test.dart';

void main() {
  group('FocusSelection', () {
    // TextField's FocusSelection is field key 101.
    final fk = CborSmallInt(101);

    test('begin (index 0) is sent and read back - the field is optional', () {
      final cbor = TextField(focusSelection: FocusSelection.begin)
          .egestFullCborMap();
      expect(cbor[fk], const CborSmallInt(0));

      final tf = TextField();
      tf.initializeFromCborMap(PKey(0), CborMap({fk: const CborSmallInt(0)}));
      expect(tf.focusSelection, FocusSelection.begin);
    });

    test('unset is omitted and reads as null on every text-entry primitive',
        () {
      expect(TextField().egestFullCborMap().containsKey(fk), isFalse);
      expect(TextField().focusSelection, isNull);
      expect(NumericField().focusSelection, isNull);
      expect(ColorField().focusSelection, isNull);
    });
  });
}
