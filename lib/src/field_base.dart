// Copyright 2024-2026 ProntoGUI, LLC
// ProntoGUI™ is a trademark of ProntoGUI, LLC
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'pkey.dart';
import 'fkey.dart';
import 'field_hooks.dart';
import 'field.dart';
import 'field_owner.dart';
import 'primitive_locator.dart';

abstract class FieldBase implements Field {
  FieldBase() : _isStructural = false;

  FieldBase.structural() : _isStructural = true;

  /// This field's key within its owning primitive.
  FKey _fkey = invalidFieldName;

  /// The primitive that owns this field. Null until prepared for updates and
  /// again after unprepare - while null, onSet/onIngest are silent no-ops
  /// (which is what makes field assignment during construction harmless).
  FieldOwner? _owner;

  /// PKey of this field's owning primitive.
  PKey get pkey => _owner?.pkey ?? PKey();

  /// The interface to call to notify the field was updated.
  FieldHooks? get fieldHooks => _owner?.fieldHooks;

  /// The primitive locator (needed by container fields).
  PrimitiveLocator? get locator => _owner?.locator;

  /// True if the field has not been prepared yet for updates.
  bool get notPreparedYet => _owner == null;

  /// Non-structural by default. Container fields pass true via the
  /// [FieldBase.structural] constructor and override [prepareForUpdates].
  final bool _isStructural;

  bool get isStructural => _isStructural;

  /// This field's container index (container fields only; -1 otherwise),
  /// passed with structural sets - see FieldHooks.
  int _structuralIndex = -1;

  @override
  bool prepareForUpdates(FKey fkey, int containerIndex, FieldOwner owner) {
    _fkey = fkey;
    _owner = owner;
    _structuralIndex = isStructural ? containerIndex : -1;
    return isStructural;
  }

  @override
  void unprepareForUpdates() {
    _owner = null;
  }

  void onSet() {
    final owner = _owner;
    if (owner != null) {
      owner.fieldHooks
          ?.onSetField(owner.pkey, _fkey, isStructural, _structuralIndex);
    }
  }

  void onIngest() {
    final owner = _owner;
    if (owner != null) {
      owner.fieldHooks
          ?.onIngestField(owner.pkey, _fkey, isStructural, _structuralIndex);
    }
  }
}
