// Copyright 2024-2026 ProntoGUI, LLC
// ProntoGUI™ is a trademark of ProntoGUI, LLC
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:test/test.dart';
import 'package:cbor/cbor.dart';
import 'package:prontogui/src/string_field.dart';
import 'package:prontogui/src/pkey.dart';
import 'field_hooks_mock.dart';

void main() {
  group('StringField', () {
    late StringField field;
    late FieldHooksMock fieldhooks;

    setUp(() {
      field = StringField();
      fieldhooks = FieldHooksMock();
    });

    prepareForUpdates() {
      field.prepareForUpdates(10, 2, FieldOwnerMock(PKey(0), fieldhooks));
    }

    test('initial value is empty string', () {
      expect(field.value, equals(''));
    });

    test('set and get value', () {
      prepareForUpdates();
      field.value = 'test';
      expect(field.value, equals('test'));
      fieldhooks.verifyTotalCalls(1);
    });

    test('isStructural returns false', () {
      expect(field.isStructural, isFalse);
    });

    test('ingestFullCborValue with valid CborString', () {
      prepareForUpdates();
      var cborValue = CborString('test');
      field.ingestFullCborValue(cborValue);
      expect(field.value, equals('test'));
      fieldhooks.verifyTotalCalls(0);
    });

    test('ingestFullCborValue with valid CborString', () {
      prepareForUpdates();
      var cborValue = CborString('test');
      field.ingestPartialCborValue(cborValue);
      expect(field.value, equals('test'));
      fieldhooks.verifyTotalCalls(1);
    });

    test('ingestFullCborValue with invalid CborValue', () {
      var cborValue = CborSmallInt(123);
      try {
        field.ingestFullCborValue(cborValue);
      } catch (e) {
        expect(e, isA<Exception>());
        expect(e.toString(), equals('Exception: value is not a CborString'));
      }
    });

    test('egestCborValue returns CborString', () {
      field.value = 'test';
      var cborValue = field.egestCborValue();
      expect(cborValue, isA<CborString>());
      expect((cborValue as CborString).toString(), equals('test'));
    });
  });
}
