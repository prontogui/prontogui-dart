// Copyright 2024-2026 ProntoGUI, LLC
// ProntoGUI™ is a trademark of ProntoGUI, LLC
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:test/test.dart';
import 'package:cbor/cbor.dart';
import 'package:prontogui/src/primitive_model.dart';
import 'package:prontogui/src/pkey.dart';
import 'package:prontogui/src/fkey.dart';
import 'package:prontogui/src/primitive_model_watcher.dart';
import 'package:prontogui/src/text.dart';
import 'package:prontogui/src/frame.dart';
import 'package:prontogui/src/group.dart';
import 'package:prontogui/src/list.dart';
import 'package:prontogui/src/static_table.dart';
import 'package:prontogui/src/pkind.dart';
import 'package:prontogui/src/protocol.dart';

import 'test_cbor_samples.dart';

class MockPrimitiveModelWatcher implements PrimitiveModelWatcher {
  bool fullModelUpdated = false;
  bool partialModelUpdated = false;
  bool topLevelPrimitiveUpdated = false;
  bool fieldSet = false;

  @override
  void onFullModelUpdate() {
    fullModelUpdated = true;
  }

  @override
  void onBeginPartialModelUpdate() {}

  @override
  void onPartialModelUpdate() {
    partialModelUpdated = true;
  }

  @override
  void onTopLevelPrimitiveUpdate() {
    topLevelPrimitiveUpdated = true;
  }

  @override
  void onSetField(PKey pkey, FKey fkey, bool structural,
      [int containerIndex = -1]) {
    fieldSet = true;
  }

  @override
  void onIngestField(PKey pkey, FKey fkey, bool structural,
      [int containerIndex = -1]) {
    fieldSet = true;
  }
}

void main() {
  group('PrimitiveModel', () {
    late PrimitiveModel model;
    late MockPrimitiveModelWatcher watcher;

    setUp(() {
      model = PrimitiveModel();
      watcher = MockPrimitiveModelWatcher();
      model.addWatcher(watcher);
    });

    test('isEmpty returns true when no primitives are present', () {
      expect(model.isEmpty, isTrue);
    });

    test('isEmpty returns false when primitives are present', () {
      model.topPrimitives = [Text()];
      expect(model.isEmpty, isFalse);
    });

    test('addWatcher adds a watcher', () {
      expect(model.watchers.contains(watcher), isTrue);
    });

    test('removeWatcher removes a watcher', () {
      model.removeWatcher(watcher);
      expect(model.watchers.contains(watcher), isFalse);
    });

    test('onFullModelUpdate notifies watchers', () {
      model.onFullModelUpdate();
      expect(watcher.fullModelUpdated, isTrue);
    });

    test('onTopLevelPrimitiveUpdate notifies watchers', () {
      model.onTopLevelPrimitiveUpdate();
      expect(watcher.topLevelPrimitiveUpdated, isTrue);
    });

    test('ingestCborUpdate handles full update', () {
      var cborList = CborList([
        CborSmallInt(protocolVersion),
        CborBool(true),
        CborSmallInt(1), // guiEpoch
        CborList([CborSmallInt(pkindText), distinctCborForText()]),
      ]);
      model.ingestCborUpdate(cborList);
      expect(watcher.fullModelUpdated, isTrue);
    });

    test('ingestCborUpdate handles partial update', () {
/* DISABLED
      var cborList = CborList([CborBool(false), CborList([])]);
      model.ingestCborUpdate(cborList);
      expect(watcher.topLevelPrimitiveUpdated, isTrue);
*/
    });

    test('onSetField notifies watchers', () {
      var pkey = PKey();
      var fkey = 10;
      model.onSetField(pkey, fkey, true);
      expect(watcher.fieldSet, isTrue);
    });
  });

  group('PKey assignments and locatePrimitive', () {
    final l1 = Text(content: 'l1');
    final l2 = Text(content: 'l2');
    final l = ListP(listItems: [l1, l2]);
    final g = Group(items: [l]);
    final t1 = Text(content: 't1');
    final t2 = Text(content: 't2');
    final t = StaticTable(rows: [
      [t1],
      [t2]
    ]);
    final f = Frame(items: [g, t]);
    final model = PrimitiveModel();

    test('Correct PKeys are assigned', () {
      model.topPrimitives = [f];

      expect(f.pkey, PKey.fromIndices([0]));
      expect(t.pkey, PKey.fromIndices([0, 0, 1]));
      expect(t1.pkey, PKey.fromIndices([0, 0, 1, 3, 0, 0]));
      expect(t2.pkey, PKey.fromIndices([0, 0, 1, 3, 1, 0]));
      expect(g.pkey, PKey.fromIndices([0, 0, 0]));
      expect(l.pkey, PKey.fromIndices([0, 0, 0, 0, 0]));
      expect(l1.pkey, PKey.fromIndices([0, 0, 0, 0, 0, 0, 0]));
      expect(l2.pkey, PKey.fromIndices([0, 0, 0, 0, 0, 0, 1]));
    });
    test('locatePrimitive returns correct primitive', () {
      model.topPrimitives = [f];

      expect(model.locatePrimitive(PKey.fromIndices([0])), equals(f));
      expect(model.locatePrimitive(PKey.fromIndices([0, 0, 1])), equals(t));
      expect(model.locatePrimitive(PKey.fromIndices([0, 0, 1, 3, 0, 0])),
          equals(t1));
      expect(model.locatePrimitive(PKey.fromIndices([0, 0, 1, 3, 1, 0])),
          equals(t2));
      expect(model.locatePrimitive(PKey.fromIndices([0, 0, 0])), equals(g));
      expect(
          model.locatePrimitive(PKey.fromIndices([0, 0, 0, 0, 0])), equals(l));
      expect(model.locatePrimitive(PKey.fromIndices([0, 0, 0, 0, 0, 0, 0])),
          equals(l1));
      expect(model.locatePrimitive(PKey.fromIndices([0, 0, 0, 0, 0, 0, 1])),
          equals(l2));
    });
  });
}
