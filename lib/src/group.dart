// Copyright 2024-2026 ProntoGUI, LLC
// ProntoGUI™ is a trademark of ProntoGUI, LLC
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'pkey.dart';
import 'primitive_base.dart';
import 'any1d_field.dart';
import 'integer_field.dart';
import 'primitive.dart';
import 'enum_field.dart';
import 'enums.dart';
import 'fkey.dart';

/// A group is a related set of primitives, such as a group of buttons, that is
/// static in type and quantity.  If a dynamic number of primitives is desired
/// then consider using a List primitive instead.
class Group extends PrimitiveBase {
  Group(
      {super.tag,
      super.backgroundColor,
      super.borderAll,
      super.borderBottom,
      super.borderColor,
      super.borderLeft,
      super.borderRight,
      super.borderTop,
      super.bottom,
      super.height,
      super.horizontalAlignment,
      super.left,
      super.marginAll,
      super.marginBottom,
      super.marginLeft,
      super.marginRight,
      super.marginTop,
      super.paddingAll,
      super.paddingBottom,
      super.paddingLeft,
      super.paddingRight,
      super.paddingTop,
      super.right,
      super.top,
      super.verticalAlignment,
      super.width,
      List<Primitive> items = const [],
      HorizontalItemAlignment? horizontalItemAlignment,
      VerticalItemAlignment? verticalItemAlignment,
      int status = 0}) {
    _items = Any1DField.from(items);
    _status = IntegerField.from(status);
    this.horizontalItemAlignment = horizontalItemAlignment;
    this.verticalItemAlignment = verticalItemAlignment;
  }

  // Field storage
  late Any1DField _items;
  final _horizontalItemAlignment =
      EnumField<HorizontalItemAlignment>(HorizontalItemAlignment.values);
  late IntegerField _status;
  final _verticalItemAlignment =
      EnumField<VerticalItemAlignment>(VerticalItemAlignment.values);

  @override
  String get describeType => 'Group';

  // Field keys for group's own fields (see firstOwnFKey in
  // fkey.dart). Fixed and append-only, matching golib field-for-field -
  // see fkey.dart's doc comment.
  static const _fkItems = 100;
  static const _fkHorizontalItemAlignment = 101;
  static const _fkVerticalItemAlignment = 102;

  @override
  void describeFields(List<FieldRef> fieldRefs) {
    fieldRefs.add(backgroundColorFieldRef());
    fieldRefs.add(borderAllFieldRef());
    fieldRefs.add(borderBottomFieldRef());
    fieldRefs.add(borderColorFieldRef());
    fieldRefs.add(borderLeftFieldRef());
    fieldRefs.add(borderRightFieldRef());
    fieldRefs.add(borderTopFieldRef());
    fieldRefs.add(bottomFieldRef());
    fieldRefs.add(FieldRef(_fkItems, 'Items', _items));
    fieldRefs.add(heightFieldRef());
    fieldRefs.add(horizontalAlignmentFieldRef());
    fieldRefs.add(FieldRef(_fkHorizontalItemAlignment,
        'HorizontalItemAlignment', _horizontalItemAlignment));
    fieldRefs.add(leftFieldRef());
    fieldRefs.add(marginAllFieldRef());
    fieldRefs.add(marginBottomFieldRef());
    fieldRefs.add(marginLeftFieldRef());
    fieldRefs.add(marginRightFieldRef());
    fieldRefs.add(marginTopFieldRef());
    fieldRefs.add(paddingAllFieldRef());
    fieldRefs.add(paddingBottomFieldRef());
    fieldRefs.add(paddingLeftFieldRef());
    fieldRefs.add(paddingRightFieldRef());
    fieldRefs.add(paddingTopFieldRef());
    fieldRefs.add(rightFieldRef());
    fieldRefs.add(FieldRef(fkStatus, 'Status', _status));
    fieldRefs.add(tagFieldRef());
    fieldRefs.add(topFieldRef());
    fieldRefs.add(verticalAlignmentFieldRef());
    fieldRefs.add(FieldRef(_fkVerticalItemAlignment, 'VerticalItemAlignment',
        _verticalItemAlignment));
    fieldRefs.add(widthFieldRef());
  }

  @override
  Primitive locateNextDescendant(PKeyLocator locator) {
    // The next index specifies which container field to access...
    var nextIndex = locator.nextIndex();
    if (nextIndex != 0) {
      throw Exception('PKey locator is out of bounds');
    }

    // The next index thereafter specifies which primitive to access...
    return items[locator.nextIndex()];
  }

  @override
  String toString() {
    return "";
  }

  /// The collection of primitives that make up the group.
  List<Primitive> get items => _items.value;
  set items(List<Primitive> items) => _items.value = items;

  /// How items flow horizontally within the group. Null means unset/default
  /// (left).
  HorizontalItemAlignment? get horizontalItemAlignment =>
      _horizontalItemAlignment.isDefault
          ? null
          : _horizontalItemAlignment.value;
  set horizontalItemAlignment(HorizontalItemAlignment? value) =>
      _horizontalItemAlignment.value = value ?? HorizontalItemAlignment.left;

  /// How items flow vertically within the group. Null means unset/default
  /// (top).
  VerticalItemAlignment? get verticalItemAlignment =>
      _verticalItemAlignment.isDefault ? null : _verticalItemAlignment.value;
  set verticalItemAlignment(VerticalItemAlignment? value) =>
      _verticalItemAlignment.value = value ?? VerticalItemAlignment.top;

  /// The status of the primitive: 0 = Normal, 1 = Disabled, 2 = Hidden, 3 = Collapsed.
  ///
  /// Normal status: the primitive is visible and works as normal.
  /// Disabled status: the primitive is visible but is disable from user interaction.
  /// Hidden status: the primitive is hidden and disabled from user interaction. The
  ///    primitive stills takes up the same space on the screen.
  /// Collapsed: the primitive is hidden and disable from user interaction. It also
  ///    doesn't consume any space on the screen.
  int get status => _status.value;
  set status(int status) {
    _status.value = status;
  }

  /// The enabled status of the primitive. This is derived from the Status field.
  /// Setting this to true will set Status to 0 (visible & enabled)
  /// and setting this to false will set Status to 1 (disabled).
  ///
  /// Note: this is a helper method to make it easier to work with the status field.  The
  /// canonical storage is still with the status field.
  bool get enabled => status == 0;
  set enabled(bool enabled) {
    status = enabled ? 0 : 1;
  }

  /// The visibility of the primitive. This is derived from the Status field.
  /// Setting this to true will set Status to 0 (visible & enabled)and setting
  /// this to false will set Status to 2 (hidden).
  ///
  /// Note: this is a helper method to make it easier to work with the status field.  The
  /// canonical storage is still with the status field.
  bool get visible => status == 0 || status == 1;
  set visible(bool visible) {
    status = visible ? 0 : 2;
  }

  /// The hidden status of the primitive.  This is derived from the Status field.
  /// Setting this to true will set Status to 2 (hidden) and setting
  /// this to false will set Status to 0 (visible and enabled).
  ///
  /// Note: this is a helper method to make it easier to work with the status field.  The
  /// canonical storage is still with the status field.
  bool get hidden => status == 2;
  set hidden(bool hidden) {
    status = hidden ? 2 : 0;
  }

  /// The collapsed status of the primitive. This is derived from the Status field.
  /// Setting this to true will set Status to 3 (hidden & collapsed )and setting
  /// this to false will set Status to 0 (visible).
  ///
  /// Note: this is a helper method to make it easier to work with the status field.  The
  /// canonical storage is still with the status field.
  bool get collapsed => status == 3;
  set collapsed(bool collapsed) {
    status = collapsed ? 3 : 0;
  }
}
