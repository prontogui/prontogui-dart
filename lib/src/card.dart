// Copyright 2024-2026 ProntoGUI, LLC
// ProntoGUI™ is a trademark of ProntoGUI, LLC
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'pkey.dart';
import 'primitive_base.dart';
import 'any_field.dart';
import 'primitive.dart';
import 'integer_field.dart';
import 'enum_field.dart';
import 'enums.dart';
import 'fkey.dart';

/// A group is a related set of primitives, such as a group of buttons, that is
/// static in type and quantity.  If a dynamic number of primitives is desired
/// then consider using a List primitive instead.
class Card extends PrimitiveBase {
  Card(
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
      Primitive? leadingItem,
      Primitive? mainItem,
      Primitive? subItem,
      Primitive? trailingItem,
      int status = 0,
      CardStyle? style}) {
    _leadingItem = AnyField.from(leadingItem);
    _mainItem = AnyField.from(mainItem);
    _subItem = AnyField.from(subItem);
    _trailingItem = AnyField.from(trailingItem);
    _status = IntegerField.from(status);
    this.style = style;
  }

  // Field storage
  late AnyField _leadingItem;
  late AnyField _mainItem;
  late AnyField _subItem;
  late AnyField _trailingItem;
  late IntegerField _status;
  final _style = EnumField<CardStyle>(CardStyle.values);

  @override
  String get describeType => 'Card';

  // Field keys for card's own fields (see firstOwnFKey in
  // fkey.dart). Fixed and append-only, matching golib field-for-field -
  // see fkey.dart's doc comment.
  static const _fkLeadingItem = 100;
  static const _fkMainItem = 101;
  static const _fkSubItem = 102;
  static const _fkTrailingItem = 103;
  static const _fkStyle = 104;

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
    fieldRefs.add(heightFieldRef());
    fieldRefs.add(horizontalAlignmentFieldRef());
    fieldRefs.add(FieldRef(_fkLeadingItem, 'LeadingItem', _leadingItem));
    fieldRefs.add(leftFieldRef());
    fieldRefs.add(FieldRef(_fkMainItem, 'MainItem', _mainItem));
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
    fieldRefs.add(FieldRef(_fkStyle, 'Style', _style));
    fieldRefs.add(FieldRef(_fkSubItem, 'SubItem', _subItem));
    fieldRefs.add(tagFieldRef());
    fieldRefs.add(topFieldRef());
    fieldRefs.add(FieldRef(_fkTrailingItem, 'TrailingItem', _trailingItem));
    fieldRefs.add(verticalAlignmentFieldRef());
    fieldRefs.add(widthFieldRef());
  }

  @override
  Primitive locateNextDescendant(PKeyLocator locator) {
    // The next index specifies which container field to access...
    var nextIndex = locator.nextIndex();
    Primitive? item;
    switch (nextIndex) {
      case 0:
        item = leadingItem;
      case 1:
        item = mainItem;
      case 2:
        item = subItem;
      case 3:
        item = trailingItem;
      default:
        throw Exception('PKey locator is out of bounds');
    }

    if (item == null) {
      throw Exception('PKey locator refers to non-existant item');
    }
    return item;
  }

  @override
  String toString() {
    return "";
  }

  /// The leading item of the card (typically an icon but can be other simple primitive).
  Primitive? get leadingItem => _leadingItem.value;
  set leadingItem(Primitive? item) => _leadingItem.value = item;

  /// The main item of the card (typically a title text but can be other simple primitive).
  Primitive? get mainItem => _mainItem.value;
  set mainItem(Primitive? item) => _mainItem.value = item;

  /// The sub item of the card (typically a sub-title text but can be other simple primitive).
  Primitive? get subItem => _subItem.value;
  set subItem(Primitive? item) => _subItem.value = item;

  /// The trailing item of the card (typically an icon or button but can be other simple primitive).
  Primitive? get trailingItem => _trailingItem.value;
  set trailingItem(Primitive? item) => _trailingItem.value = item;

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

  /// The visual style. Null means unset (card).
  CardStyle? get style => _style.isDefault ? null : _style.value;
  set style(CardStyle? value) => _style.value = value ?? CardStyle.card;

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
