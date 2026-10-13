// Copyright 2024-2026 ProntoGUI, LLC
// ProntoGUI™ is a trademark of ProntoGUI, LLC
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:cbor/cbor.dart';
import 'package:prontogui/prontogui.dart';
import 'package:test/test.dart';

void main() {
  group('NumericField optional fields', () {
    // Field keys: DisplayDecimalPlaces 102, MinValue 107.
    final fkDecimals = CborSmallInt(102);
    final fkMin = CborSmallInt(107);

    test('displayDecimalPlaces round-trips null, exactly n, and up to n', () {
      for (final v in [null, 0, 2, 15, -1, -4]) {
        expect(NumericField(displayDecimalPlaces: v).displayDecimalPlaces, v);
      }
    });

    test('exactly 0 digits and a minimum of 0 are sent; unset is omitted', () {
      final cbor =
          NumericField(displayDecimalPlaces: 0, minValue: 0).egestFullCborMap();
      expect(cbor[fkDecimals], const CborSmallInt(0));
      expect(cbor.containsKey(fkMin), isTrue);

      final asIs = NumericField().egestFullCborMap();
      expect(asIs.containsKey(fkDecimals), isFalse);
      expect(asIs.containsKey(fkMin), isFalse);
    });

    test('decodes golib wire values (n, -n, absent = unset)', () {
      for (final (wire, expected) in [(0, 0), (3, 3), (-2, -2)]) {
        final nf = NumericField();
        nf.initializeFromCborMap(
            PKey(0), CborMap({fkDecimals: CborSmallInt(wire)}));
        expect(nf.displayDecimalPlaces, expected, reason: 'wire $wire');
      }
      final nf = NumericField();
      nf.initializeFromCborMap(PKey(0), CborMap({}));
      expect(nf.displayDecimalPlaces, isNull);
      expect(nf.minValue, isNull);
    });
  });
}
