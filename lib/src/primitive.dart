// Copyright 2024-2026 ProntoGUI, LLC
// ProntoGUI™ is a trademark of ProntoGUI, LLC
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:cbor/cbor.dart';
import 'pkey.dart';
import 'fkey.dart';
import 'field_hooks.dart';
import 'primitive_locator.dart';
import 'pkind.dart';
import 'color.dart';
import 'alignment.dart';

// Interface for Primitives.
abstract class Primitive {
  /// The path to this primitive.
  PKey get pkey;

  /// Prepare this primitive for updates, where [pkey] is the path to this primitive,
  /// [fieldHooks] is the interface to call when fields of this primitive are updated,
  /// and [locator] is the interface for locating other primitives.
  void prepareForUpdates(
      PKey pkey, FieldHooks fieldHooks, PrimitiveLocator locator);

  /// Unprepare this primitive for updates.  Subsequent updates to fields will not
  /// call the previous onset function, not will this primitive have a valid PKey.
  void unprepareForUpdates();

  /// Returns the next primitive that is a direct descendant of this primitive.
  /// A caller presumes there is a next descendant, otherwise an exception is thrown.
  Primitive locateNextDescendant(PKeyLocator locator);

  /// Egests a full update from this primitive as a CborMap.
  CborMap egestFullCborMap();

  /// Egests a partial update from this primitive as a CborMap.
  /// Only the fields specified in [fkeys] will be included in the map.
  /// It is assumed that [fkeys] is a subset of the fields of this primitive, otherwise
  /// an assertion is thrown.
  CborMap egestPartialCborMap(List<FKey> fkeys);

  /// Initialize from a CborMap.  This includes creating new child primitives.
  void ingestFullCborMap(CborMap cbor);

  /// Update field values by ingesting them from a CborMap. The map can only contain
  /// updates for pre-existing child primmitives.  New children are not created.
  void ingestPartialCborMap(CborMap cbor);

  /// Returns the canonical type of this primitive.
  String get describeType;

  /// Identifies this primitive's concrete type on the wire (see PKind).
  /// Whoever egests a full snapshot of this primitive pairs this with
  /// egestFullCborMap as [kind, fields] instead of a bare map.
  PKind get kind;

  /// Returns the name of the field at [fkey] on this specific primitive, or
  /// null if there is no such field. Field keys are scoped per PKind (see
  /// fkey.dart), so the same integer means a different field on a different
  /// primitive type — code that needs to reason about "the Xxx field" (e.g.
  /// classifying which field changes are user-generated events) has to go
  /// through a primitive instance to resolve a key to a name; there is no
  /// longer a global fkey->name registry to consult directly.
  String? fieldNameForKey(FKey fkey);

  /// True if the primitive has not been prepared yet for updates.
  bool get notPreparedYet;

  /// An arbitrary tag to keep around with this primitive.
  String get tag;
  set tag(String tag);

  // Common box-model/positioning/appearance fields, replacing the pre-2.0
  // embodiment-properties scheme. Each is nullable: null means unset/default
  // (the underlying wire field is genuinely omitted from full updates — see
  // PrimitiveBase and Field.isDefault), matching how this API always worked
  // even when these were parsed out of the embodiment string on the App
  // side rather than being real fields.
  Color? get backgroundColor;
  set backgroundColor(Color? value);
  double? get borderAll;
  set borderAll(double? value);
  double? get borderBottom;
  set borderBottom(double? value);
  Color? get borderColor;
  set borderColor(Color? value);
  double? get borderLeft;
  set borderLeft(double? value);
  double? get borderRight;
  set borderRight(double? value);
  double? get borderTop;
  set borderTop(double? value);
  double? get bottom;
  set bottom(double? value);
  double? get height;
  set height(double? value);
  HorizontalAlignment? get horizontalAlignment;
  set horizontalAlignment(HorizontalAlignment? value);
  double? get left;
  set left(double? value);
  double? get marginAll;
  set marginAll(double? value);
  double? get marginBottom;
  set marginBottom(double? value);
  double? get marginLeft;
  set marginLeft(double? value);
  double? get marginRight;
  set marginRight(double? value);
  double? get marginTop;
  set marginTop(double? value);
  double? get paddingAll;
  set paddingAll(double? value);
  double? get paddingBottom;
  set paddingBottom(double? value);
  double? get paddingLeft;
  set paddingLeft(double? value);
  double? get paddingRight;
  set paddingRight(double? value);
  double? get paddingTop;
  set paddingTop(double? value);
  double? get right;
  set right(double? value);
  double? get top;
  set top(double? value);
  VerticalAlignment? get verticalAlignment;
  set verticalAlignment(VerticalAlignment? value);
  double? get width;
  set width(double? value);
}
