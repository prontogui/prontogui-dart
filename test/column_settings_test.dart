// Copyright 2024-2026 ProntoGUI, LLC
// ProntoGUI™ is a trademark of ProntoGUI, LLC
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:cbor/cbor.dart';
import 'package:prontogui/src/column_settings.dart';
import 'package:prontogui/src/enums.dart';
import 'package:prontogui/src/pkey.dart';
import 'package:prontogui/src/pkind.dart';
import 'package:prontogui/src/primitive_factory.dart';
import 'package:test/test.dart';

void main() {
  group('ColumnSettings', () {
    test('constructs with defaults', () {
      // PrimitiveBase's constructor assigns width, which ColumnSettings
      // overrides - this used to throw LateInitializationError.
      final cs = ColumnSettings();
      expect(cs.width, isNull);
      expect(cs.sortType, isNull);
      expect(cs.dateTimeFormat, isNull);
    });

    test('constructs with values', () {
      final cs = ColumnSettings(
          width: 80.0, sortType: SortType.numeric, dateTimeFormat: 'yyyy');
      expect(cs.width, 80.0);
      expect(cs.sortType, SortType.numeric);
      expect(cs.dateTimeFormat, 'yyyy');
    });

    test('decodes from a full update', () {
      final cs = PrimitiveFactory.createPrimitiveFromKind(
          PKey(0),
          pkindColumnSettings,
          CborMap({
            const CborSmallInt(101): const CborSmallInt(2),
            const CborSmallInt(102): CborFloat(80.0),
          })) as ColumnSettings;
      expect(cs.sortType, SortType.numeric);
      expect(cs.width, 80.0);
    });
  });
}
