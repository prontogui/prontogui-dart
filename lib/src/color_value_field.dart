// Copyright 2024-2026 ProntoGUI, LLC
// ProntoGUI™ is a trademark of ProntoGUI, LLC
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'field.dart';
import 'package:cbor/cbor.dart';
import 'field_base.dart';
import 'cbor_values.dart';
import 'color.dart';

/// A field that holds a Color value. It egests/ingests as a plain unsigned
/// integer on the wire (see color.dart) — no new CBOR type, just an
/// existing one with a typed meaning attached on the language side.
class ColorValueField extends FieldBase implements Field {
  /// Construct a ColorValueField holding a fully transparent color.
  ColorValueField() : _c = Colors.transparent;

  /// Construct a ColorValueField from a Color.
  ColorValueField.from(Color c) : _c = c;

  /// Storage of this field's value.
  Color _c;

  /// The value of this field.
  Color get value => _c;
  set value(Color c) {
    _c = c;
    onSet();
  }

  // Implement Field interface

  @override
  void ingestFullCborValue(CborValue value) {
    _c = colorFromCbor(value);
  }

  @override
  void ingestPartialCborValue(CborValue value) {
    ingestFullCborValue(value);
    onIngest();
  }

  @override
  CborValue egestCborValue() {
    return CborSmallInt(_c.value);
  }

  /// True for fully transparent black (Colors.transparent) — see color.dart
  /// for why that's a meaningful "unset" state rather than an arbitrary one.
  @override
  bool get isDefault => _c.value == 0;

  // Object overrides

  @override
  String toString() {
    return _c.toString();
  }
}
