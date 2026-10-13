// Copyright 2024-2026 ProntoGUI, LLC
// ProntoGUI™ is a trademark of ProntoGUI, LLC
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:cbor/cbor.dart';
import 'field.dart';
import 'pkey.dart';
import 'fkey.dart';
import 'field_hooks.dart';
import 'field_owner.dart';
import 'primitive.dart';
import 'primitive_locator.dart';
import 'string_field.dart';
import 'double_field.dart';
import 'color_value_field.dart';
import 'color.dart';
import 'enum_field.dart';
import 'alignment.dart';
import 'pkind.dart';
import 'log.dart';
import 'opt_field.dart';

class FieldRef {
  FieldRef(this.fkey, this.name, this.field);

  // The field's key, scoped to the primitive that declares it (see FKey in
  // fkey.dart) — no longer a global registry lookup, since the same integer
  // means different things on different primitives now that keys are scoped
  // per PKind.
  FKey fkey;

  // The field's name, carried here (rather than in a global registry) for
  // debugging/introspection only. The wire format uses fkey, never name.
  String name;

  Field field;
}

/// The base class for all primitives.
abstract class PrimitiveBase implements Primitive, FieldOwner {
  PrimitiveBase({
    String tag = '',
    Color? backgroundColor,
    double? borderAll,
    double? borderBottom,
    Color? borderColor,
    double? borderLeft,
    double? borderRight,
    double? borderTop,
    double? bottom,
    double? height,
    HorizontalAlignment? horizontalAlignment,
    double? left,
    double? marginAll,
    double? marginBottom,
    double? marginLeft,
    double? marginRight,
    double? marginTop,
    double? paddingAll,
    double? paddingBottom,
    double? paddingLeft,
    double? paddingRight,
    double? paddingTop,
    double? right,
    double? top,
    VerticalAlignment? verticalAlignment,
    double? width,
  }) {
    this.tag = tag;
    this.backgroundColor = backgroundColor;
    this.borderAll = borderAll;
    this.borderBottom = borderBottom;
    this.borderColor = borderColor;
    this.borderLeft = borderLeft;
    this.borderRight = borderRight;
    this.borderTop = borderTop;
    this.bottom = bottom;
    this.height = height;
    this.horizontalAlignment = horizontalAlignment;
    this.left = left;
    this.marginAll = marginAll;
    this.marginBottom = marginBottom;
    this.marginLeft = marginLeft;
    this.marginRight = marginRight;
    this.marginTop = marginTop;
    this.paddingAll = paddingAll;
    this.paddingBottom = paddingBottom;
    this.paddingLeft = paddingLeft;
    this.paddingRight = paddingRight;
    this.paddingTop = paddingTop;
    this.right = right;
    this.top = top;
    this.verticalAlignment = verticalAlignment;
    this.width = width;
  }

  // The PKey of this primitive.
  PKey _pkey = PKey();

  // Cached field refs.
  List<FieldRef>? __cachedFieldRefs;

  // Common fields for all primitives
  final _tag = StringField();

  // Common box-model/positioning/appearance fields, replacing the
  // pre-2.0 embodiment-properties scheme (see primitive.dart for the public,
  // nullable-at-the-boundary API these back).
  final _backgroundColor = ColorValueField();
  final _borderAll = DoubleOptField();
  final _borderBottom = DoubleOptField();
  final _borderColor = ColorValueField();
  final _borderLeft = DoubleOptField();
  final _borderRight = DoubleOptField();
  final _borderTop = DoubleOptField();
  final _bottom = DoubleOptField();
  final _height = DoubleField();
  final _horizontalAlignment =
      EnumField<HorizontalAlignment>(HorizontalAlignment.values);
  final _left = DoubleOptField();
  final _marginAll = DoubleOptField();
  final _marginBottom = DoubleOptField();
  final _marginLeft = DoubleOptField();
  final _marginRight = DoubleOptField();
  final _marginTop = DoubleOptField();
  final _paddingAll = DoubleOptField();
  final _paddingBottom = DoubleOptField();
  final _paddingLeft = DoubleOptField();
  final _paddingRight = DoubleOptField();
  final _paddingTop = DoubleOptField();
  final _right = DoubleOptField();
  final _top = DoubleOptField();
  final _verticalAlignment =
      EnumField<VerticalAlignment>(VerticalAlignment.values);
  final _width = DoubleField();

  // Sub-classed primitives must implement this method to describe their type
  // and fields: the common fields (Tag/Embodiment and the box-model/
  // positioning/appearance ones), added via the parameterless xxxFieldRef()
  // helpers below, always at their fixed shared key (see fkey.dart); and the
  // primitive's own fields, added with a locally-declared fixed literal
  // FKey starting at firstOwnFKey. A primitive's own-field numbers must
  // match golib's assignment for the same primitive field-for-field — see
  // fkey.dart's doc comment for why these can no longer be independently
  // re-derived by each language.
  void describeFields(List<FieldRef> fieldRefs);

  // Common-field helpers for subclasses: [_embodiment]/[_tag] and the common
  // box-model/positioning/appearance fields are private to this file (Dart
  // privacy is per-library-file, not per-class), so a primitive declared
  // elsewhere can't build a FieldRef for them directly. These take no fkey
  // parameter - a common field's key is the same fixed number on every
  // primitive (see fkey.dart), not something each primitive computes for
  // itself the way it does for its own fields.
  FieldRef tagFieldRef() => FieldRef(fkTag, 'Tag', _tag);
  FieldRef backgroundColorFieldRef() =>
      FieldRef(fkBackgroundColor, 'BackgroundColor', _backgroundColor);
  FieldRef borderAllFieldRef() =>
      FieldRef(fkBorderAll, 'BorderAll', _borderAll);
  FieldRef borderBottomFieldRef() =>
      FieldRef(fkBorderBottom, 'BorderBottom', _borderBottom);
  FieldRef borderColorFieldRef() =>
      FieldRef(fkBorderColor, 'BorderColor', _borderColor);
  FieldRef borderLeftFieldRef() =>
      FieldRef(fkBorderLeft, 'BorderLeft', _borderLeft);
  FieldRef borderRightFieldRef() =>
      FieldRef(fkBorderRight, 'BorderRight', _borderRight);
  FieldRef borderTopFieldRef() =>
      FieldRef(fkBorderTop, 'BorderTop', _borderTop);
  FieldRef bottomFieldRef() => FieldRef(fkBottom, 'Bottom', _bottom);
  FieldRef heightFieldRef() => FieldRef(fkHeight, 'Height', _height);
  FieldRef horizontalAlignmentFieldRef() => FieldRef(
      fkHorizontalAlignment, 'HorizontalAlignment', _horizontalAlignment);
  FieldRef leftFieldRef() => FieldRef(fkLeft, 'Left', _left);
  FieldRef marginAllFieldRef() =>
      FieldRef(fkMarginAll, 'MarginAll', _marginAll);
  FieldRef marginBottomFieldRef() =>
      FieldRef(fkMarginBottom, 'MarginBottom', _marginBottom);
  FieldRef marginLeftFieldRef() =>
      FieldRef(fkMarginLeft, 'MarginLeft', _marginLeft);
  FieldRef marginRightFieldRef() =>
      FieldRef(fkMarginRight, 'MarginRight', _marginRight);
  FieldRef marginTopFieldRef() =>
      FieldRef(fkMarginTop, 'MarginTop', _marginTop);
  FieldRef paddingAllFieldRef() =>
      FieldRef(fkPaddingAll, 'PaddingAll', _paddingAll);
  FieldRef paddingBottomFieldRef() =>
      FieldRef(fkPaddingBottom, 'PaddingBottom', _paddingBottom);
  FieldRef paddingLeftFieldRef() =>
      FieldRef(fkPaddingLeft, 'PaddingLeft', _paddingLeft);
  FieldRef paddingRightFieldRef() =>
      FieldRef(fkPaddingRight, 'PaddingRight', _paddingRight);
  FieldRef paddingTopFieldRef() =>
      FieldRef(fkPaddingTop, 'PaddingTop', _paddingTop);
  FieldRef rightFieldRef() => FieldRef(fkRight, 'Right', _right);
  FieldRef topFieldRef() => FieldRef(fkTop, 'Top', _top);
  FieldRef verticalAlignmentFieldRef() =>
      FieldRef(fkVerticalAlignment, 'VerticalAlignment', _verticalAlignment);
  FieldRef widthFieldRef() => FieldRef(fkWidth, 'Width', _width);

  List<FieldRef> get _fieldRefs {
    // Build list of field refs on demand and cache it.
    if (__cachedFieldRefs == null) {
      var fieldRefs = List<FieldRef>.empty(growable: true);
      describeFields(fieldRefs);
      __cachedFieldRefs = fieldRefs;
    }

    return __cachedFieldRefs!;
  }

  @override
  String? fieldNameForKey(FKey fkey) {
    for (final fr in _fieldRefs) {
      if (fr.fkey == fkey) {
        return fr.name;
      }
    }
    return null;
  }

  /// The tag to keep around with this primitive.
  @override
  String get tag => _tag.value;
  @override
  set tag(String tag) {
    _tag.value = tag;
  }

  // Common box-model/positioning/appearance fields - see primitive.dart
  // for what null means for each.

  @override
  Color? get backgroundColor =>
      _backgroundColor.isDefault ? null : _backgroundColor.value;
  @override
  set backgroundColor(Color? value) =>
      _backgroundColor.value = value ?? Colors.transparent;

  @override
  double? get borderAll => _borderAll.value;
  @override
  set borderAll(double? value) => _borderAll.value = value;

  @override
  double? get borderBottom => _borderBottom.value;
  @override
  set borderBottom(double? value) => _borderBottom.value = value;

  @override
  Color? get borderColor => _borderColor.isDefault ? null : _borderColor.value;
  @override
  set borderColor(Color? value) =>
      _borderColor.value = value ?? Colors.transparent;

  @override
  double? get borderLeft => _borderLeft.value;
  @override
  set borderLeft(double? value) => _borderLeft.value = value;

  @override
  double? get borderRight => _borderRight.value;
  @override
  set borderRight(double? value) => _borderRight.value = value;

  @override
  double? get borderTop => _borderTop.value;
  @override
  set borderTop(double? value) => _borderTop.value = value;

  @override
  double? get bottom => _bottom.value;
  @override
  set bottom(double? value) => _bottom.value = value;

  @override
  double? get height => _height.isDefault ? null : _height.value;
  @override
  set height(double? value) => _height.value = value ?? 0.0;

  @override
  HorizontalAlignment? get horizontalAlignment =>
      _horizontalAlignment.isDefault ? null : _horizontalAlignment.value;
  @override
  set horizontalAlignment(HorizontalAlignment? value) =>
      _horizontalAlignment.value = value ?? HorizontalAlignment.left;

  @override
  double? get left => _left.value;
  @override
  set left(double? value) => _left.value = value;

  @override
  double? get marginAll => _marginAll.value;
  @override
  set marginAll(double? value) => _marginAll.value = value;

  @override
  double? get marginBottom => _marginBottom.value;
  @override
  set marginBottom(double? value) => _marginBottom.value = value;

  @override
  double? get marginLeft => _marginLeft.value;
  @override
  set marginLeft(double? value) => _marginLeft.value = value;

  @override
  double? get marginRight => _marginRight.value;
  @override
  set marginRight(double? value) => _marginRight.value = value;

  @override
  double? get marginTop => _marginTop.value;
  @override
  set marginTop(double? value) => _marginTop.value = value;

  @override
  double? get paddingAll => _paddingAll.value;
  @override
  set paddingAll(double? value) => _paddingAll.value = value;

  @override
  double? get paddingBottom => _paddingBottom.value;
  @override
  set paddingBottom(double? value) => _paddingBottom.value = value;

  @override
  double? get paddingLeft => _paddingLeft.value;
  @override
  set paddingLeft(double? value) => _paddingLeft.value = value;

  @override
  double? get paddingRight => _paddingRight.value;
  @override
  set paddingRight(double? value) => _paddingRight.value = value;

  @override
  double? get paddingTop => _paddingTop.value;
  @override
  set paddingTop(double? value) => _paddingTop.value = value;

  @override
  double? get right => _right.value;
  @override
  set right(double? value) => _right.value = value;

  @override
  double? get top => _top.value;
  @override
  set top(double? value) => _top.value = value;

  @override
  VerticalAlignment? get verticalAlignment =>
      _verticalAlignment.isDefault ? null : _verticalAlignment.value;
  @override
  set verticalAlignment(VerticalAlignment? value) =>
      _verticalAlignment.value = value ?? VerticalAlignment.top;

  @override
  double? get width => _width.isDefault ? null : _width.value;
  @override
  set width(double? value) => _width.value = value ?? 0.0;

  /// Derived from [describeType] via a lookup table (see pkind.dart) so that
  /// individual primitive subclasses don't each need to declare their own
  /// kind — describeType already exists on every one of them.
  @override
  PKind get kind => pkindForTypeName(describeType);

  void initializeFromCborMap(PKey pkey, CborMap cbor) {
    _pkey = pkey;
    ingestFullCborMap(cbor);
  }

  @override
  PKey get pkey => _pkey;

  @override
  Primitive locateNextDescendant(PKeyLocator locator) {
    throw Exception(
        'locateNextDescendant not implemented for this primitive because it doesn\'t have descendants.');
  }

  Field? findField(FKey fkey) {
    for (var fieldRef in _fieldRefs) {
      if (fieldRef.fkey == fkey) {
        return fieldRef.field;
      }
    }
    return null;
  }

  // Set while prepared for updates. Every field of this primitive reaches
  // these through the FieldOwner back-pointer rather than storing its own copy.
  FieldHooks? _fieldHooks;
  PrimitiveLocator? _locator;

  @override
  FieldHooks? get fieldHooks => _fieldHooks;

  @override
  PrimitiveLocator? get locator => _locator;

  @override
  void prepareForUpdates(
      PKey pkey, FieldHooks fieldHooks, PrimitiveLocator locator) {
    _pkey = pkey;
    _fieldHooks = fieldHooks;
    _locator = locator;

    // containerIndex counts only the container fields (in field-ref order) -
    // it becomes the pkey level for that field's descendants, and must line up
    // with the primitive's locateNextDescendant.
    var containerIndex = 0;
    for (var fieldRef in _fieldRefs) {
      if (fieldRef.field
          .prepareForUpdates(fieldRef.fkey, containerIndex, this)) {
        containerIndex++;
      }
    }
  }

  @override
  void unprepareForUpdates() {
    _pkey = PKey();
    _fieldHooks = null;
    _locator = null;

    for (var fieldRef in _fieldRefs) {
      fieldRef.field.unprepareForUpdates();
    }
  }

  /// Emits [notificationType] (a Notify.* code) to the server — but only if the
  /// server has a handler for it (see [isNotificationHandled]). Embodiments
  /// call this from their gesture handlers. See NOTIFICATIONS.md §5.
  void notify(int notificationType) {
    final hooks = _fieldHooks;
    if (hooks == null) return;
    if (!isNotificationHandled(notificationType)) return;
    hooks.onNotify(_pkey, notificationType);
  }

  /// Whether the server has registered a handler for [notificationType] on this
  /// primitive, per its NotificationsHandled bitmask. Primitives that don't
  /// support notifications always return false.
  bool isNotificationHandled(int notificationType) => false;

  /// Egests a full update from this primitive as a CborMap.
  ///
  /// A field sitting at its zero/default value is omitted: a freshly
  /// constructed primitive already starts at that same zero value, so
  /// omitting it here and leaving it out are indistinguishable to the
  /// receiver. This is what makes full updates cheap now that type no longer
  /// has to be inferred from which fields are present (see PKind) — the two
  /// changes are the same change.
  @override
  CborMap egestFullCborMap() {
    Map<CborValue, CborValue> update = {};

    for (var field in _fieldRefs) {
      if (field.field.isDefault) {
        continue;
      }
      update[CborSmallInt(field.fkey)] = field.field.egestCborValue();
    }

    return CborMap(update);
  }

  /// Egests a partial update from this primitive as a CborMap.
  /// Only the fields specified in [fkeys] will be included in the map.
  /// It is assumed that [fkeys] is a subset of the fields of this primitive, otherwise
  /// an assertion is thrown.
  @override
  CborMap egestPartialCborMap(List<FKey> fkeys) {
    Map<CborValue, CborValue> update = {};

    for (var fkey in fkeys) {
      var field = findField(fkey);
      assert(field != null);

      update[CborSmallInt(fkey)] = field!.egestCborValue();
    }

    return CborMap(update);
  }

  @override
  void ingestFullCborMap(CborMap cbor) {
    for (var item in cbor.entries) {
      var k = item.key;

      if (k is! CborSmallInt) {
        throw 'key is not an integer field key';
      }

      var field = findField(k.value);
      if (field == null) {
        // An unrecognized field key is expected, not an error: the sender
        // may be running a newer library version that added a field this
        // build doesn't know about yet. Skip just that field rather than
        // failing the whole update - field keys are permanent and
        // append-only (see fkey.dart's doc comment) specifically so this
        // stays safe to ignore rather than a sign of corruption.
        logger.w(
            'ignoring unrecognized field key ${k.value} for primitive of type $describeType - sender may be running a newer library version');
        continue;
      }

      field.ingestFullCborValue(item.value);
    }
  }

  @override
  void ingestPartialCborMap(CborMap cbor) {
    for (var item in cbor.entries) {
      var k = item.key;

      if (k is! CborSmallInt) {
        throw 'key is not an integer field key';
      }

      var fkey = k.value;
      var field = findField(fkey);
      if (field == null) {
        logger.w(
            'ignoring unrecognized field key $fkey for primitive of type $describeType - sender may be running a newer library version');
        continue;
      }

      field.ingestPartialCborValue(item.value);
    }
  }

  @override
  bool get notPreparedYet => _pkey.isEmpty;

  // Returns the index of this primitive in a parent container specified by [parentLevel] as follows:
  // parentLevel = 0, immediate parent container
  // parentLevel = 1, grandparent
  // parentLevel = 2, great grandparent
  // And so on.
  //
  // It returns -1 if parentLevel is a negative number or is invalid given the depth where the primitive belongs.
  int indexOf(int parentLevel) {
    int len = _pkey.length;

    if (parentLevel >= 0 && parentLevel < len) {
      return _pkey.indexAtLevel(len - parentLevel - 1);
    }

    return -1;
  }

  /// Returns a pretty-printed string representation of this primitive.
  String prettyPrint() {
    var pp = '$describeType\n  pkey : ${_pkey.toString()}';
    for (var field in _fieldRefs) {
      pp += '\n  ${field.name} : ${field.field.toString()}';
    }
    return pp;
  }

  // Default implementation of toString() for all primitives returns an empty string.
  @override
  String toString() {
    return '';
  }
}
