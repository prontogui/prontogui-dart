// Copyright 2024-2026 ProntoGUI, LLC
// ProntoGUI™ is a trademark of ProntoGUI, LLC
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'field.dart';
import 'package:cbor/cbor.dart';
import 'field_base.dart';
import 'cbor_values.dart';

/// A field that holds an integer value.
class IntegerField extends FieldBase implements Field {
  /// Construct an IntegerField with a default value.
  IntegerField() : _i = 0;

  IntegerField.from(int i) : _i = i;

  /// Storage of this field's value.
  int _i;

  /// The value of this field.
  int get value => _i;
  set value(int i) {
    _i = i;
    onSet();
  }

  // Implement Field interface

  @override
  void ingestFullCborValue(CborValue value) {
    _i = intFromCbor(value);
  }

  @override
  void ingestPartialCborValue(CborValue value) {
    ingestFullCborValue(value);
    onIngest();
  }

  @override
  CborValue egestCborValue() {
    return CborSmallInt(_i);
  }

  @override
  bool get isDefault => _i == 0;

  // Object overrides

  @override
  String toString() {
    return '$_i`';
  }
}
