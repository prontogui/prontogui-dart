// Copyright 2024-2026 ProntoGUI, LLC
// ProntoGUI™ is a trademark of ProntoGUI, LLC
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'field.dart';
import 'package:cbor/cbor.dart';
import 'field_base.dart';
import 'cbor_values.dart';

/// A field that holds a floating-point value — the numeric type Flutter's
/// own layout APIs (EdgeInsets, BoxConstraints, ...) use, so values like
/// width, height, and spacing stay in their natural fractional form all the
/// way from the server instead of round-tripping through an int.
class DoubleField extends FieldBase implements Field {
  /// Construct a DoubleField with a default value of 0.
  DoubleField() : _d = 0;

  /// Construct a DoubleField from a value.
  DoubleField.from(double d) : _d = d;

  /// Storage of this field's value.
  double _d;

  /// The value of this field.
  double get value => _d;
  set value(double d) {
    _d = d;
    onSet();
  }

  // Implement Field interface

  @override
  void ingestFullCborValue(CborValue value) {
    _d = doubleFromCbor(value);
  }

  @override
  void ingestPartialCborValue(CborValue value) {
    ingestFullCborValue(value);
    onIngest();
  }

  @override
  CborValue egestCborValue() {
    return CborFloat(_d);
  }

  @override
  bool get isDefault => _d == 0;

  // Object overrides

  @override
  String toString() {
    return _d.toString();
  }
}
