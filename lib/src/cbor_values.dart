// Copyright 2024-2026 ProntoGUI, LLC
// ProntoGUI™ is a trademark of ProntoGUI, LLC
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:cbor/cbor.dart';
import 'color.dart';

// Conversions from an ingested CBOR value to a field's Dart value, shared by
// the plain and optional (opt_field.dart) field types.

/// An int from a CBOR integer.
int intFromCbor(CborValue value) {
  if (value is CborSmallInt) return value.value;
  if (value is CborBigInt) return value.toInt();
  throw Exception('CBOR value is not an integer type');
}

/// A double from a CBOR number. CBOR encodes a whole-number double compactly
/// as an integer when it can (e.g. 12.0 crosses the wire as a plain 12).
double doubleFromCbor(CborValue value) {
  if (value is CborFloat) return value.value;
  if (value is CborSmallInt) return value.value.toDouble();
  if (value is CborBigInt) return value.toInt().toDouble();
  throw Exception('value is not a numeric CBOR type');
}

/// A Color from a CBOR integer (packed 0xAARRGGBB).
Color colorFromCbor(CborValue value) {
  if (value is CborSmallInt) return Color(value.value);
  if (value is CborBigInt) return Color(value.toInt());
  throw Exception('value is not an integer CBOR type');
}

/// An enum value from a CBOR integer index into [values].
T enumFromCbor<T extends Enum>(CborValue value, List<T> values) {
  if (value is! CborSmallInt) {
    throw Exception('value is not a CborSmallInt');
  }
  if (value.value < 0 || value.value >= values.length) {
    throw Exception('enum index ${value.value} is out of range for $T');
  }
  return values[value.value];
}
