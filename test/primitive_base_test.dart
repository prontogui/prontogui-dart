// Copyright 2024-2026 ProntoGUI, LLC
// ProntoGUI™ is a trademark of ProntoGUI, LLC
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:test/test.dart';
import 'package:cbor/cbor.dart';
import 'package:prontogui/src/primitive_base.dart';
import 'package:prontogui/src/pkey.dart';
import 'package:prontogui/src/field_hooks.dart';
import 'package:prontogui/src/primitive_locator.dart';
import 'package:prontogui/src/fkey.dart';

class TestPrimitive extends PrimitiveBase {
  TestPrimitive({super.tag, super.left});

  @override
  void describeFields(List<FieldRef> fieldRefs) {
    fieldRefs.add(leftFieldRef());
    fieldRefs.add(tagFieldRef());
  }

  @override
  String get describeType => 'TestPrimitive';
}

void main() {
  group('PrimitiveBase Tests', () {
    test('Test tag and box-model getters and setters', () {
      var primitive = TestPrimitive(left: 5.0, tag: 'initialTag');

      expect(primitive.left, 5.0);
      expect(primitive.tag, 'initialTag');

      primitive.left = 9.0;
      primitive.tag = 'newTag';

      expect(primitive.left, 9.0);
      expect(primitive.tag, 'newTag');
    });

    test('Test initializeFromCborMap', () {
      var primitive = TestPrimitive();
      var pkey = PKey();
      var cborMap = CborMap({
        CborSmallInt(fkLeft): CborFloat(7.0),
        CborSmallInt(fkTag): CborString('testTag'),
      });

      primitive.initializeFromCborMap(pkey, cborMap);
      expect(primitive.left, 7.0);
      expect(primitive.tag, 'testTag');
    });

    test('Test egestFullCborMap', () {
      var primitive = TestPrimitive(left: 3.0, tag: 'testTag');
      var cborMap = primitive.egestFullCborMap();

      expect((cborMap[CborSmallInt(fkLeft)] as CborFloat).value, 3.0);
      expect(cborMap[CborSmallInt(fkTag)], CborString('testTag'));
    });

    test('Test egestPartialCborMap', () {
      var primitive = TestPrimitive(left: 3.0, tag: 'testTag');

      primitive.prepareForUpdates(
          PKey(0), NullFieldHooks(), NullPrimitiveLocator());
      primitive.tag = 'testTagUpdate';
      var cborMap = primitive.egestPartialCborMap([fkTag]);

      expect(cborMap.length, 1);
      expect(cborMap[CborSmallInt(fkTag)], CborString('testTagUpdate'));
    });

    test('Test ingestFullCborMap', () {
      var primitive = TestPrimitive();
      var cborMap = CborMap({
        CborSmallInt(fkLeft): CborFloat(7.0),
        CborSmallInt(fkTag): CborString('testTag'),
      });

      primitive.ingestFullCborMap(cborMap);
      expect(primitive.left, 7.0);
      expect(primitive.tag, 'testTag');
    });

    test('Test ingestPartialCborMap', () {
      var primitive = TestPrimitive(left: 1.0, tag: 'initialTag');
      var cborMap = CborMap({
        CborSmallInt(fkTag): CborString('testTag'),
      });

      primitive.ingestPartialCborMap(cborMap);
      expect(primitive.tag, 'testTag');
      expect(primitive.left, 1.0);
    });

    test('Test prettyPrint', () {
      var primitive = TestPrimitive(left: 3.0, tag: 'testTag');
      primitive.prepareForUpdates(
          PKey(0, 2), NullFieldHooks(), NullPrimitiveLocator());
      var prettyString = primitive.prettyPrint();

      expect(prettyString.contains('testTag'), true);
    });
  });
}
