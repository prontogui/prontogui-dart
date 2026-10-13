// Copyright 2024-2026 ProntoGUI, LLC
// ProntoGUI™ is a trademark of ProntoGUI, LLC
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:test/test.dart';
import 'package:cbor/cbor.dart';
import 'package:prontogui/src/color_value_field.dart';
import 'package:prontogui/src/color.dart';
import 'package:prontogui/src/pkey.dart';
import 'field_hooks_mock.dart';

void main() {
  group('ColorValueField', () {
    late ColorValueField field;
    late FieldHooksMock fieldhooks;

    setUp(() {
      field = ColorValueField();
      fieldhooks = FieldHooksMock();
    });

    prepareForUpdates() {
      field.prepareForUpdates(10, 2, FieldOwnerMock(PKey(0), fieldhooks));
    }

    test('default constructor initializes with transparent', () {
      expect(field.value, equals(Colors.transparent));
      expect(field.isDefault, isTrue);
    });

    test('constructor from Color initializes with correct value', () {
      final field = ColorValueField.from(Color.fromRGB(1, 2, 3));
      expect(field.value, equals(Color.fromRGB(1, 2, 3)));
    });

    test('value setter updates the value', () {
      prepareForUpdates();
      field.value = Colors.red;
      expect(field.value, equals(Colors.red));
      fieldhooks.verifyTotalCalls(1);
    });

    test('isDefault is false once a non-transparent color is set', () {
      field.value = Colors.red;
      expect(field.isDefault, isFalse);
    });

    test('ingestFullCborValue sets the value correctly for CborSmallInt', () {
      prepareForUpdates();
      field.ingestFullCborValue(CborSmallInt(0x44112233));
      expect(field.value.value, equals(0x44112233));
      fieldhooks.verifyTotalCalls(0);
    });

    test('ingestFullCborValue sets the value correctly for CborBigInt', () {
      prepareForUpdates();
      field.ingestFullCborValue(CborBigInt(BigInt.from(0x44112233)));
      expect(field.value.value, equals(0x44112233));
      fieldhooks.verifyTotalCalls(0);
    });

    test('ingestFullCborValue throws exception for non-integer value', () {
      expect(() => field.ingestFullCborValue(CborString('not a color')),
          throwsException);
    });

    test('ingestPartialCborValue sets the value correctly', () {
      prepareForUpdates();
      field.ingestPartialCborValue(CborSmallInt(0x44112233));
      expect(field.value.value, equals(0x44112233));
      fieldhooks.verifyTotalCalls(1);
    });

    test('egestCborValue returns correct CborSmallInt', () {
      field.value = Color.fromARGB(0x44, 0x11, 0x22, 0x33);
      final cborValue = field.egestCborValue();
      expect(cborValue, isA<CborSmallInt>());
      expect((cborValue as CborSmallInt).value, equals(0x44112233));
    });

    test('toString returns the color hex representation', () {
      field.value = Color.fromARGB(0x44, 0x11, 0x22, 0x33);
      expect(field.toString(), equals('#44112233'));
    });
  });
}
