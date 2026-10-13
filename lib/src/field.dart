// Copyright 2024-2026 ProntoGUI, LLC
// ProntoGUI™ is a trademark of ProntoGUI, LLC
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:cbor/cbor.dart';
import 'fkey.dart';
import 'field_owner.dart';

/// A field is a single piece of data or setting of a Primitive that can be updated.
abstract interface class Field {
  /// Prepare this field for updates. [fkey] is the field key; [containerIndex]
  /// is meaningful only for container fields (they use it as a pkey level for
  /// their descendants), scalar fields ignore it; [owner] is the primitive this
  /// field belongs to (its pkey, hooks and locator are reached through it).
  /// Returns true if the field is a container of primitives.
  bool prepareForUpdates(FKey fkey, int containerIndex, FieldOwner owner);

  /// Unprepare this field for updates.  Subsequent updates to the field will not
  /// call the previous onset function, not will this field have a valid PKey or FKey.
  void unprepareForUpdates();

  /// Egest the field's value as a CBOR value.
  CborValue egestCborValue();

  /// Ingest a CBOR value into the field.  The update must only apply to pre-existing
  /// child primitives and no additional children can be created.  An exception is
  /// thrown if there is a problem ingesting the value.
  ///
  /// Note:  for atomic field types, this method is equivalent to ingestFullCborValue.
  void ingestPartialCborValue(CborValue value);

  /// Injest a CBOR value into the field.  An exception is thrown if there is a
  /// problem ingesting the value.  If this field contains primitive children, they
  /// will be replaced entirely by the new value.  An exception is
  /// thrown if there is a problem ingesting the value.
  ///
  /// Note:  for atomic field types, this method is equivalent to ingestPartialCborValue.
  void ingestFullCborValue(CborValue value);

  /// True if the field currently holds its zero/default value. A full-update
  /// egest omits any field for which this is true — safe because a freshly
  /// constructed primitive already starts at that same zero value, so
  /// omitting it and leaving it out are indistinguishable to the receiver.
  /// Partial updates never consult this: they always egest exactly the
  /// fields explicitly marked as changed, regardless of value, since that's
  /// the only mechanism for communicating "this was reset to its default."
  ///
  /// For an optional field (OptField) the default is null (unset), not the
  /// zero value: a set 0 is not the default and is always sent, and an unset
  /// field is egested in a partial update as CBOR null.
  bool get isDefault;
}
