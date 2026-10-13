// Copyright 2024-2026 ProntoGUI, LLC
// ProntoGUI™ is a trademark of ProntoGUI, LLC
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:test/test.dart';
import 'package:cbor/cbor.dart';
import 'package:prontogui/src/enum_field.dart';
import 'package:prontogui/src/pkey.dart';
import 'field_hooks_mock.dart';

// A small enum type, standing in for the kind of named-value type a real
// primitive would declare for one of its own fields (e.g. SelectionMode).
enum TestWidgetSize { small, medium, large }

void main() {
  group('EnumField', () {
    late EnumField<TestWidgetSize> field;
    late FieldHooksMock fieldhooks;

    setUp(() {
      field = EnumField<TestWidgetSize>(TestWidgetSize.values);
      fieldhooks = FieldHooksMock();
    });

    prepareForUpdates() {
      field.prepareForUpdates(10, 2, FieldOwnerMock(PKey(0), fieldhooks));
    }

    test('default constructor initializes with the first enum value', () {
      expect(field.value, equals(TestWidgetSize.small));
      expect(field.isDefault, isTrue);
    });

    test('constructor from a value initializes with that value', () {
      final field = EnumField<TestWidgetSize>.from(
          TestWidgetSize.values, TestWidgetSize.large);
      expect(field.value, equals(TestWidgetSize.large));
    });

    test('value setter updates the value', () {
      prepareForUpdates();
      field.value = TestWidgetSize.large;
      expect(field.value, equals(TestWidgetSize.large));
      fieldhooks.verifyTotalCalls(1);
    });

    test('isDefault is false once a non-first value is set', () {
      field.value = TestWidgetSize.medium;
      expect(field.isDefault, isFalse);
    });

    test('ingestFullCborValue sets the value correctly', () {
      prepareForUpdates();
      field.ingestFullCborValue(CborSmallInt(TestWidgetSize.large.index));
      expect(field.value, equals(TestWidgetSize.large));
      fieldhooks.verifyTotalCalls(0);
    });

    test('ingestFullCborValue throws exception for non-CborSmallInt', () {
      expect(() => field.ingestFullCborValue(CborString('not an enum')),
          throwsException);
    });

    test('ingestFullCborValue throws exception for an out-of-range index', () {
      expect(
          () => field.ingestFullCborValue(CborSmallInt(99)), throwsException);
    });

    test('ingestPartialCborValue sets the value correctly', () {
      prepareForUpdates();
      field.ingestPartialCborValue(CborSmallInt(TestWidgetSize.medium.index));
      expect(field.value, equals(TestWidgetSize.medium));
      fieldhooks.verifyTotalCalls(1);
    });

    test('egestCborValue returns the value\'s index as CborSmallInt', () {
      field.value = TestWidgetSize.large;
      final cborValue = field.egestCborValue();
      expect(cborValue, isA<CborSmallInt>());
      expect((cborValue as CborSmallInt).value,
          equals(TestWidgetSize.large.index));
    });

    test('toString returns the enum value\'s own string representation', () {
      field.value = TestWidgetSize.medium;
      expect(field.toString(), equals(TestWidgetSize.medium.toString()));
    });
  });
}
