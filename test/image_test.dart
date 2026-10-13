// Copyright 2024-2026 ProntoGUI, LLC
// ProntoGUI™ is a trademark of ProntoGUI, LLC
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'dart:typed_data';

import 'package:test/test.dart';
import 'package:prontogui/src/image.dart';
import 'package:prontogui/src/pkey.dart';
import 'package:prontogui/src/references.dart';
import 'package:prontogui/src/primitive.dart';
import 'package:prontogui/src/primitive_locator.dart';
import 'field_hooks_mock.dart';

class MockPrimitiveLocator implements PrimitiveLocator {
  final Map<String, Primitive> primitivesByPKey = {};

  void register(PKey pkey, Primitive primitive) {
    primitivesByPKey[pkey.toString()] = primitive;
  }

  @override
  int get guiEpoch => 0;

  @override
  Primitive? locatePrimitive(PKey pkey) {
    return primitivesByPKey[pkey.toString()];
  }
}

void main() {
  group('Image', () {
    setUp(() {
      // Clean up singleton state between tests
      References().resetState();
    });

    test('Default constructor initializes with empty values', () {
      final image = Image();
      expect(image.image, isEmpty);
      expect(image.id, '');
      expect(image.ref, '');
      expect(image.status, 0);
    });

    test('Constructor initializes with provided values', () {
      final image = Image(id: 'img1', ref: 'otherImg', status: 1);
      expect(image.id, 'img1');
      expect(image.ref, 'otherImg');
      expect(image.status, 1);
    });

    test('image getter and setter work correctly', () {
      final image = Image();
      final data = Uint8List.fromList([1, 2, 3]);
      image.image = data;
      expect(image.image, equals(data));
    });

    test('id getter and setter work correctly', () {
      final image = Image();
      image.id = 'newID';
      expect(image.id, 'newID');
    });

    test('ref getter and setter work correctly', () {
      final image = Image();
      image.ref = 'newRef';
      expect(image.ref, 'newRef');
    });

    test('status getter and setter work correctly', () {
      final image = Image();
      image.status = 2;
      expect(image.status, 2);
    });

    test('enabled reflects and controls status', () {
      final image = Image();
      expect(image.enabled, isTrue);

      image.enabled = false;
      expect(image.status, 1);
      expect(image.enabled, isFalse);

      image.enabled = true;
      expect(image.status, 0);
    });

    test('visible reflects and controls status', () {
      final image = Image();
      expect(image.visible, isTrue);

      image.visible = false;
      expect(image.status, 2);
      expect(image.visible, isFalse);

      image.visible = true;
      expect(image.status, 0);
    });

    test('hidden reflects and controls status', () {
      final image = Image();
      expect(image.hidden, isFalse);

      image.hidden = true;
      expect(image.status, 2);
      expect(image.hidden, isTrue);

      image.hidden = false;
      expect(image.status, 0);
    });

    test('collapsed reflects and controls status', () {
      final image = Image();
      expect(image.collapsed, isFalse);

      image.collapsed = true;
      expect(image.status, 3);
      expect(image.collapsed, isTrue);

      image.collapsed = false;
      expect(image.status, 0);
    });

    test('describeType returns correct type', () {
      final image = Image();
      expect(image.describeType, 'Image');
    });

    test('toString returns empty string', () {
      final image = Image(id: 'img1');
      image.image = Uint8List.fromList([1, 2, 3]);
      expect(image.toString(), '');
    });

    test('image getter resolves data through a reference', () {
      final source = Image(id: 'sourceImg');
      source.image = Uint8List.fromList([9, 8, 7]);

      final viewer = Image(ref: 'sourceImg');

      final locator = MockPrimitiveLocator();
      final sourcePKey = PKey(0);
      locator.register(sourcePKey, source);

      source.prepareForUpdates(sourcePKey, FieldHooksMock(), locator);
      viewer.prepareForUpdates(PKey(1), FieldHooksMock(), locator);

      expect(viewer.image, equals(Uint8List.fromList([9, 8, 7])));
    });

    test('image getter returns empty data when reference cannot be resolved',
        () {
      final viewer = Image(ref: 'missingImg');
      final locator = MockPrimitiveLocator();
      viewer.prepareForUpdates(PKey(0), FieldHooksMock(), locator);

      expect(viewer.image, isEmpty);
    });

    test('prepareForUpdates does not throw for an image without an id', () {
      final image = Image();
      expect(
          () => image.prepareForUpdates(
              PKey(), FieldHooksMock(), MockPrimitiveLocator()),
          returnsNormally);
    });
  });
}
