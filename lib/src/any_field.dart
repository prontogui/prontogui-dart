// Copyright 2024-2026 ProntoGUI, LLC
// ProntoGUI™ is a trademark of ProntoGUI, LLC
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'field.dart';
import 'package:cbor/cbor.dart';
import 'field_base.dart';
import 'field_owner.dart';
import 'primitive.dart';
import 'fkey.dart';
import 'pkey.dart';
import 'primitive_factory.dart';

/// A field that holds a single primitive.
class AnyField extends FieldBase implements Field {
  AnyField()
      : _p = null,
        super.structural();

  /// Initializes with a primitive.
  AnyField.from(Primitive? p)
      : _p = p,
        super.structural();

  /// Storage of this field's value.
  Primitive? _p;

  /// The value of this field.
  Primitive? get value => _p;
  set value(Primitive? p) {
    _unprepareDescendantsForUpdates();
    _p = p;
    _prepareDescendantsForUpdates();
    onSet();
  }

  /// This field's position among its primitive's container fields - the pkey
  /// level for this field's descendant (see PrimitiveBase.prepareForUpdates).
  int _containerIndex = -1;

  // Implement Field interface

  // Override the default implementation to prepare the descendant primitive.
  @override
  bool prepareForUpdates(FKey fkey, int containerIndex, FieldOwner owner) {
    super.prepareForUpdates(fkey, containerIndex, owner);
    _containerIndex = containerIndex;
    _prepareDescendantsForUpdates();
    return isStructural;
  }

  @override
  void unprepareForUpdates() {
    super.unprepareForUpdates();
    _unprepareDescendantsForUpdates();
  }

  /// Prepare descendant primitives for updates.
  void _prepareDescendantsForUpdates() {
    // Short circuit for the case where the primitives are being used in freestyle fashion.
    // That is, they are participating in a model yet and hence we aren't trackig updates.
    if (notPreparedYet) {
      return;
    }

    // Prepare descendant primitive for updates
    if (_p != null) {
      var fieldPKey = PKey.fromPKey(pkey, _containerIndex);
      _p!.prepareForUpdates(fieldPKey, fieldHooks!, locator!);
    }
  }

  void _unprepareDescendantsForUpdates() {
    if (_p != null) {
      _p!.unprepareForUpdates();
    }
  }

  @override
  void ingestFullCborValue(CborValue value) {
    _unprepareDescendantsForUpdates();

    if (value is CborNull) {
      _p = null;
    } else if (value is! CborList || value.length != 2) {
      throw Exception('value is not a [kind, map] CborList');
    } else {
      var kind = value.elementAt(0);
      var fields = value.elementAt(1);
      if (kind is! CborSmallInt || fields is! CborMap) {
        throw Exception('value is not a [kind, map] CborList');
      }
      _p = PrimitiveFactory.createPrimitiveFromKind(pkey, kind.value, fields);
    }
  }

  @override
  void ingestPartialCborValue(CborValue value) {
    // The server sends a container field's whole new value - [kind, fields]
    // or null - whenever it changes, so a partial update replaces the child
    // exactly as a full one does (same as Any1DField/Any2DField). Merging into
    // the existing child was wrong when the kind changed, and threw when the
    // field was empty.
    ingestFullCborValue(value);
    onIngest();
  }


  @override
  CborValue egestCborValue() {
    if (_p == null) {
      return CborNull();
    }
    return CborList([CborSmallInt(_p!.kind), _p!.egestFullCborMap()]);
  }

  @override
  bool get isDefault => _p == null;

  // Object overrides

  @override
  String toString() {
    if (_p == null) {
      return "<empty>";
    }
    return _p!.describeType;
  }
}
