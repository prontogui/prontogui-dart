// Copyright 2024-2026 ProntoGUI, LLC
// ProntoGUI™ is a trademark of ProntoGUI, LLC
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:cbor/cbor.dart';
import 'cbor_values.dart';
import 'color.dart';
import 'field.dart';
import 'field_base.dart';

/// Shared behaviour of the optional field types (see OPTIONAL-FIELDS.md):
/// a field is set to any value - including the zero value - or unset, which
/// is `null`. Mirrors golib's optField.
///
/// On the wire, unset is omitted from full updates (it is the [isDefault]
/// state) and egested as CBOR null in partial updates; an ingested CBOR null
/// unsets the field.
abstract class OptField<T extends Object> extends FieldBase implements Field {
  OptField([this._v]);

  T? _v;

  /// The value, or null when unset. Assigning null unsets the field. Like
  /// every setter it always marks the field changed (doc/FIELD-SETTERS.md).
  T? get value => _v;
  set value(T? v) {
    _v = v;
    onSet();
  }

  /// True when a value is set.
  bool get isSet => _v != null;

  /// Unsets the field (marks it changed).
  void unset() => value = null;

  /// Converts a non-null ingested CBOR value.
  T fromCbor(CborValue value);

  /// Converts a set value for egest.
  CborValue toCbor(T v);

  @override
  void ingestFullCborValue(CborValue value) {
    _v = value is CborNull ? null : fromCbor(value);
  }

  @override
  void ingestPartialCborValue(CborValue value) {
    ingestFullCborValue(value);
    onIngest();
  }

  @override
  CborValue egestCborValue() {
    final v = _v;
    return v == null ? const CborNull() : toCbor(v);
  }

  /// Unset is the default; set to the zero value is not.
  @override
  bool get isDefault => _v == null;

  @override
  String toString() => _v?.toString() ?? 'unset';
}

/// An optional double field (schema type double?).
class DoubleOptField extends OptField<double> {
  DoubleOptField([super.v]);

  @override
  double fromCbor(CborValue value) => doubleFromCbor(value);

  @override
  CborValue toCbor(double v) => CborFloat(v);
}

/// An optional int field (schema type int?).
class IntegerOptField extends OptField<int> {
  IntegerOptField([super.v]);

  @override
  int fromCbor(CborValue value) => intFromCbor(value);

  @override
  CborValue toCbor(int v) => CborSmallInt(v);
}

/// An optional Color field (schema type color?). Unlike ColorValueField,
/// transparent is a value you can set.
class ColorOptField extends OptField<Color> {
  ColorOptField([super.v]);

  @override
  Color fromCbor(CborValue value) => colorFromCbor(value);

  @override
  CborValue toCbor(Color v) => CborSmallInt(v.value);
}

/// An optional enum field (schema type `enum<T>?`). Unlike EnumField, its first
/// value is an ordinary choice - unset is the default.
class EnumOptField<T extends Enum> extends OptField<T> {
  EnumOptField(this._values, [super.v]);

  /// All values of T, in declaration order - index i crosses the wire.
  final List<T> _values;

  @override
  T fromCbor(CborValue value) => enumFromCbor(value, _values);

  @override
  CborValue toCbor(T v) => CborSmallInt(v.index);
}
