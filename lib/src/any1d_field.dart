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

/// A field that holds a one-dimensional array of primitives.
class Any1DField extends FieldBase implements Field {
  Any1DField()
      : _pa = List<Primitive>.unmodifiable([]),
        super.structural();

  Any1DField.from(List<Primitive> pa) : _pa = List<Primitive>.unmodifiable(pa);

  /// Storage of this field's value.
  late List<Primitive> _pa;

  /// The value of this field.  When setting the value, a copy of the input
  /// list is made.  When getting the value, a copy of the internal list is
  /// returned.
  List<Primitive> get value => _pa;
  set value(List<Primitive> pa) {
    _unprepareDescendantsForUpdates();
    _pa = List<Primitive>.unmodifiable(pa);
    _prepareDescendantsForUpdates();
    onSet();
  }

  @override
  bool get isStructural => true;

  /// This field's position among its primitive's container fields - see
  /// PrimitiveBase.prepareForUpdates.
  int _containerIndex = -1;

  // Implement Field interface

  // Override the default implementation to prepare the descendant primitives.
  @override
  bool prepareForUpdates(FKey fkey, int containerIndex, FieldOwner owner) {
    super.prepareForUpdates(fkey, containerIndex, owner);
    _containerIndex = containerIndex;
    _prepareDescendantsForUpdates();
    return isStructural;
  }

  /// Prepare descendant primitives for updates.
  void _prepareDescendantsForUpdates() {
    // Short circuit for the case where the primitives are being used in freestyle fashion.
    // That is, they are participating in a model yet and hence we aren't trackig updates.
    if (notPreparedYet) {
      return;
    }

    // Prepare each individual descendant primitives for updates

    var fieldPKey = PKey.fromPKey(pkey, _containerIndex);

    for (var i = 0; i < _pa.length; i++) {
      // Add another level representing the array index of primitive
      _pa[i].prepareForUpdates(
          PKey.fromPKey(fieldPKey, i), fieldHooks!, locator!);
    }
  }

  void _unprepareDescendantsForUpdates() {
    for (var i = 0; i < _pa.length; i++) {
      _pa[i].unprepareForUpdates();
    }
  }

  @override
  void ingestFullCborValue(CborValue value) {
    _ingest(value);
  }

  @override
  void ingestPartialCborValue(CborValue value) {
    _ingest(value);
    onIngest();
  }

  void _ingest(CborValue value) {
    if (value is! CborList) {
      throw Exception(
          'Any1DField:ingestFullCborValue - value is not a CborList');
    }

    var newArray = List<Primitive>.generate(value.length, (index) {
      var wrapped = value.elementAt(index);

      if (wrapped is! CborList || wrapped.length != 2) {
        throw Exception('element is not a [kind, map] CborList');
      }

      var kind = wrapped.elementAt(0);
      var cbor = wrapped.elementAt(1);
      if (kind is! CborSmallInt || cbor is! CborMap) {
        throw Exception('element is not a [kind, map] CborList');
      }

      return PrimitiveFactory.createPrimitiveFromKind(
          PKey.fromPKey(pkey, index), kind.value, cbor);
    });

    _unprepareDescendantsForUpdates();
    _pa = List<Primitive>.unmodifiable(newArray);
    _prepareDescendantsForUpdates();
  }

  @override
  CborValue egestCborValue() {
    var update = <CborValue>[];

    for (var p in _pa) {
      update.add(CborList([CborSmallInt(p.kind), p.egestFullCborMap()]));
    }

    return CborList(update);
  }

  @override
  bool get isDefault => _pa.isEmpty;

  // Object overrides

  @override
  String toString() {
    if (_pa.isEmpty) {
      return '<Empty>';
    }

    return 'Array [${_pa.length} primitives] with types: ${List<String>.generate(_pa.length, (index) => _pa[index].describeType).join(', ')}';
  }
}
