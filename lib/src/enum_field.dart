// Copyright 2024-2026 ProntoGUI, LLC
// ProntoGUI™ is a trademark of ProntoGUI, LLC
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'field.dart';
import 'package:cbor/cbor.dart';
import 'field_base.dart';
import 'cbor_values.dart';

/// A field that holds a value of a real Dart enum type, egesting/ingesting
/// as that value's [Enum.index] — one small integer, the same wire shape a
/// plain IntegerField would use, but with a named, compiler-checked Dart
/// type on this side instead of an int that happens to have a doc comment
/// next to it explaining what each number means.
///
/// Dart can't recover a generic type's `values` list on its own (there's no
/// static-member access through a type parameter), so the field is
/// constructed with the enum's `values` list passed in explicitly:
///
/// ```dart
/// enum SelectionMode { none, one, multiple }
/// final selectionMode = EnumField<SelectionMode>(SelectionMode.values);
/// ```
///
/// The first value in the enum declaration (index 0) is this field's
/// default/omittable state (see [isDefault]), so declare whichever value
/// reads naturally as "the default" for a given field first - and it must
/// equal the App's fallback for an unset field, or that first value can never
/// be chosen. When no single value is the default, use EnumOptField instead:
/// there null (unset) is the default and the order carries no meaning (see
/// app_core/specs/OPTIONAL-FIELDS.md).
class EnumField<T extends Enum> extends FieldBase implements Field {
  /// Construct an EnumField defaulting to `values.first`.
  EnumField(this._values) : _v = _values.first;

  /// Construct an EnumField holding a specific starting value.
  EnumField.from(this._values, T v) : _v = v;

  /// All values of T, in declaration order — index i is what crosses the
  /// wire for `values[i]`.
  final List<T> _values;

  /// Storage of this field's value.
  T _v;

  /// The value of this field.
  T get value => _v;
  set value(T v) {
    _v = v;
    onSet();
  }

  // Implement Field interface

  @override
  void ingestFullCborValue(CborValue value) {
    _v = enumFromCbor(value, _values);
  }

  @override
  void ingestPartialCborValue(CborValue value) {
    ingestFullCborValue(value);
    onIngest();
  }

  @override
  CborValue egestCborValue() {
    return CborSmallInt(_v.index);
  }

  /// True at the enum's first declared value (index 0) — see the class doc
  /// comment for why that's the field's default/omittable state.
  @override
  bool get isDefault => _v.index == 0;

  // Object overrides

  @override
  String toString() {
    return _v.toString();
  }
}
