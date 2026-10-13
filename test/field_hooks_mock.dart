// Copyright 2024-2026 ProntoGUI, LLC
// ProntoGUI™ is a trademark of ProntoGUI, LLC
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:prontogui/src/field_hooks.dart';
import 'package:prontogui/src/field_owner.dart';
import 'package:prontogui/src/primitive_locator.dart';
import 'package:test/test.dart';
import 'package:prontogui/src/fkey.dart';
import 'package:prontogui/src/pkey.dart';

/// A FieldOwner for exercising a field's prepareForUpdates in isolation.
class FieldOwnerMock implements FieldOwner {
  FieldOwnerMock(this._pkey, this._hooks);

  final PKey _pkey;
  final FieldHooks? _hooks;

  @override
  PKey get pkey => _pkey;
  @override
  FieldHooks? get fieldHooks => _hooks;
  @override
  PrimitiveLocator? get locator => NullPrimitiveLocator();
}

class FieldHooksMock implements FieldHooks {
  var onsetCalled = 0;
  var onsetPkey = PKey();
  var onsetFKey = invalidFieldName;
  var onsetStructural = false;
  var onsetContainerIndex = -1;
  var oningestCalled = 0;
  var oningestPkey = PKey();
  var oningestFKey = invalidFieldName;

  @override
  void onSetField(PKey pkey, FKey fkey, bool structural,
      [int containerIndex = -1]) {
    onsetCalled++;
    onsetPkey = pkey;
    onsetFKey = fkey;
    onsetStructural = structural;
    onsetContainerIndex = containerIndex;
  }

  @override
  void onIngestField(PKey pkey, FKey fkey, bool structural,
      [int containerIndex = -1]) {
    oningestCalled++;
    oningestPkey = pkey;
    oningestFKey = fkey;
  }

  var onNotifyCalled = 0;
  var onNotifyPkey = PKey();
  var onNotifyType = -1;

  @override
  void onNotify(PKey pkey, int notificationType) {
    onNotifyCalled++;
    onNotifyPkey = pkey;
    onNotifyType = notificationType;
  }

  void verifyTotalCalls(int callCount) {
    expect(onsetCalled + oningestCalled, equals(callCount));
  }

  void verifyOnsetCalled(int callCount, {PKey? pkey, FKey? fkey}) {
    expect(onsetCalled, equals(callCount));

    if (pkey != null) {
      expect(onsetPkey.isEqualTo(pkey), isTrue);
    }

    if (fkey != null) {
      expect(onsetFKey, equals(fkey));
    }
  }

  void verifyOningestCalled(int callCount, {PKey? pkey, FKey? fkey}) {
    expect(oningestCalled, equals(callCount));

    if (pkey != null) {
      expect(oningestPkey.isEqualTo(pkey), isTrue);
    }

    if (fkey != null) {
      expect(oningestFKey, equals(fkey));
    }
  }
}
