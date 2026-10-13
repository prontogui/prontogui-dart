// Copyright 2024-2026 ProntoGUI, LLC
// ProntoGUI™ is a trademark of ProntoGUI, LLC
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:test/test.dart';
import 'package:cbor/cbor.dart';
import 'package:prontogui/src/text.dart';
import 'package:prontogui/src/icon.dart';
import 'package:prontogui/src/any_field.dart';
import 'package:prontogui/src/pkey.dart';
import 'package:prontogui/src/pkind.dart';
import 'field_hooks_mock.dart';

import 'test_cbor_samples.dart';

void main() {
  group('AnyField', () {
    late AnyField field;
    late FieldHooksMock fieldhooks;
    late Text text;
    late Text otherText;

    setUp(() {
      // (re)assign test variables
      field = AnyField();
      fieldhooks = FieldHooksMock();
      text = Text(content: 'test text');
      otherText = Text(content: 'other test text');

      // Prepare for updates and set a field of text
      var isContainer = field.prepareForUpdates(
          10, 6, FieldOwnerMock(PKey(0, 1, 2), fieldhooks));
      expect(isContainer, isTrue);
    });

    test('initial value is null', () {
      final field = AnyField();
      expect(field.value, isNull);
    });

    test('set and get value', () {
      final primitive = Text(content: 'test');
      field.value = primitive;
      expect(field.value, equals(primitive));
      fieldhooks.verifyTotalCalls(1);
    });

    test('set reports a structural set with its container index', () {
      field.value = text;
      expect(fieldhooks.onsetStructural, isTrue);
      expect(fieldhooks.onsetContainerIndex, equals(6));
    });

    test('ingestFullCborValue works', () {
      field.ingestFullCborValue(
          CborList([CborSmallInt(pkindText), distinctCborForText()]));
      expect(field.value!.describeType, equals('Text'));
      fieldhooks.verifyTotalCalls(0);
    });

    test('ingestParialCborValue works', () {
      field.value = text;
      field.ingestPartialCborValue(
          CborList([CborSmallInt(pkindText), partialCborForText('ABC')]));
      var newText = field.value as Text;
      expect(newText.content, equals('ABC'));
      // Two hook calls: the earlier field assignment, and the field's own
      // ingest. A partial update replaces the child (it is created from the
      // sent fields, not merged into the old one), so there is no separate
      // call for the child's Content field.
      fieldhooks.verifyTotalCalls(2);
    });

    test('ingestFullCborValue throws exception if value is not CborMap', () {
      final field = AnyField();
      expect(
          () => field.ingestFullCborValue(CborString('test')), throwsException);
    });

    test('ingestFullCborValue does not throw exception if primitive is null',
        () {
      final field = AnyField();
      expect(
          () => field.ingestFullCborValue(const CborNull()), returnsNormally);
    });

    test('ingestPartialCborValue throws exception if value is not CborMap', () {
      final field = AnyField();
      expect(() => field.ingestPartialCborValue(CborString('test')),
          throwsException);
    });

    test('ingestPartialCborValue throws exception if primitive is null', () {
      final field = AnyField();
      expect(() => field.ingestPartialCborValue(CborMap({})), throwsException);
    });

    test('partial update into an empty field creates the primitive', () {
      final field = AnyField();
      field.ingestPartialCborValue(
          CborList([CborSmallInt(pkindText), partialCborForText('new')]));
      expect((field.value as Text).content, 'new');
    });

    test('partial update with a different kind replaces the primitive', () {
      final field = AnyField.from(Text(content: 'old'));
      field.ingestPartialCborValue(
          CborList([CborSmallInt(pkindIcon), CborMap({})]));
      expect(field.value, isA<Icon>());
    });

    test('partial update with null clears the primitive', () {
      final field = AnyField.from(Text(content: 'old'));
      field.ingestPartialCborValue(const CborNull());
      expect(field.value, isNull);
    });

    test('egestCborValue returns CborNull if primitive is null', () {
      final field = AnyField();
      expect(field.egestCborValue(), isA<CborNull>());
    });

    test('toString returns <empty> if primitive is null', () {
      final field = AnyField();
      expect(field.toString(), equals('<empty>'));
    });

    test('toString returns primitive description if primitive is not null', () {
      final field = AnyField();
      final primitive = Text(content: 'test');
      field.value = primitive;
      expect(field.toString(), equals(primitive.describeType));
    });

    test('prepareForUpdates sets up field correctly (1)', () {
      field.value = text;
      fieldhooks.verifyOnsetCalled(1, pkey: PKey(0, 1, 2), fkey: 10);
    });

    test('prepareForUpdates sets up descendant primitives correctly', () {
      field.value = text;
      text.content = 'updated';
      // Text's own Content field key (see text.dart), not the dummy fkey
      // used to prepare this AnyField above.
      fieldhooks.verifyOnsetCalled(2, pkey: PKey(0, 1, 2, 6), fkey: 100);
    });

    test('when unpreparing for updates, it unprepares its primitive properly',
        () {
      field.unprepareForUpdates();
      field.value = text;
      fieldhooks.verifyTotalCalls(0);
    });

    test('assignment unprepares previous primitive', () {
      field.value = otherText;
      expect(text.notPreparedYet, isTrue);
    });

    test('ingest unprepares previous primitive', () {
      var update = {CborSmallInt(100): CborString('new stuff')}; // Content
      field.ingestFullCborValue(
          CborList([CborSmallInt(pkindText), CborMap(update)]));
      expect(text.notPreparedYet, isTrue);
    });
  });
}
