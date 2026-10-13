// Copyright 2024-2026 ProntoGUI, LLC
// ProntoGUI™ is a trademark of ProntoGUI, LLC
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:prontogui/src/any_field.dart';
import 'pkey.dart';
import 'primitive_base.dart';
import 'notification.dart';
import 'any1d_field.dart';
import 'boolean_field.dart';
import 'integer_field.dart';
import 'integer1d_field.dart';
import 'primitive.dart';
import 'fkey.dart';

/// A list is a collection of primitives that have a sequential-like relationship
/// and might be dynamic in quantity or kind.
///
/// Note: it is named ListP to avoid conflict with the Dart List class.
class ListP extends PrimitiveBase {
  ListP({
    super.tag,
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
    bool horizontal = false,
    List<Primitive> listItems = const [],
    Primitive? modelItem,
    List<int> selectedItems = const [],
    int selectionMode = 0,
    int status = 0,
  }) {
    _listItems = Any1DField.from(listItems);
    _modelItem = AnyField.from(modelItem);
    _selectedItems = Integer1DField.from(selectedItems);
    _selectionMode = IntegerField.from(selectionMode);
    _status = IntegerField.from(status);

    this.horizontal = horizontal;
  }

  // Field storage
  final _horizontal = BooleanField();
  late Any1DField _listItems;

  // The model item to use when embodifying list items.
  late AnyField _modelItem;

  // The indexes of the selected items.
  late Integer1DField _selectedItems;

  // The selection mode.
  late IntegerField _selectionMode;

  // Evnet for when selection has changed

  late IntegerField _status;

  // Server -> App bitmask of handled notifications (see Notify.bit).
  final _notificationsHandled = IntegerField();

  @override
  // Return the canonical type name for this primitive.  ListP is used specifically
  // in this library because List is a reserved word in Dart.
  String get describeType => 'List';

  // Field keys for list's own fields (see firstOwnFKey in
  // fkey.dart). Fixed and append-only, matching golib field-for-field -
  // see fkey.dart's doc comment.
  static const _fkListItems = 100;
  static const _fkModelItem = 101;
  static const _fkSelectedItems = 102;
  static const _fkSelectionMode = 103;
  static const _fkHorizontal = 104;

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
    fieldRefs.add(FieldRef(_fkHorizontal, 'Horizontal', _horizontal));
    fieldRefs.add(horizontalAlignmentFieldRef());
    fieldRefs.add(leftFieldRef());
    fieldRefs.add(FieldRef(_fkListItems, 'ListItems', _listItems));
    fieldRefs.add(marginAllFieldRef());
    fieldRefs.add(marginBottomFieldRef());
    fieldRefs.add(marginLeftFieldRef());
    fieldRefs.add(marginRightFieldRef());
    fieldRefs.add(marginTopFieldRef());
    fieldRefs.add(FieldRef(_fkModelItem, 'ModelItem', _modelItem));
    fieldRefs.add(FieldRef(
        fkNotificationsHandled, 'NotificationsHandled', _notificationsHandled));
    fieldRefs.add(paddingAllFieldRef());
    fieldRefs.add(paddingBottomFieldRef());
    fieldRefs.add(paddingLeftFieldRef());
    fieldRefs.add(paddingRightFieldRef());
    fieldRefs.add(paddingTopFieldRef());
    fieldRefs.add(rightFieldRef());
    fieldRefs.add(FieldRef(_fkSelectedItems, 'SelectedItems', _selectedItems));
    fieldRefs.add(FieldRef(_fkSelectionMode, 'SelectionMode', _selectionMode));
    fieldRefs.add(FieldRef(fkStatus, 'Status', _status));
    fieldRefs.add(tagFieldRef());
    fieldRefs.add(topFieldRef());
    fieldRefs.add(verticalAlignmentFieldRef());
    fieldRefs.add(widthFieldRef());
  }

  @override
  Primitive locateNextDescendant(PKeyLocator locator) {
    // The next index specifies which container field to access...
    var nextIndex = locator.nextIndex();
    switch (nextIndex) {
      case 0:
        return listItems[locator.nextIndex()];
      case 1:
        if (_modelItem.value == null) {
          throw Exception('PKey locator is out of bounds');
        }
        return _modelItem.value!;
      default:
        throw Exception('PKey locator is out of bounds');
    }
  }

  @override
  String toString() {
    return "";
  }

  @override
  bool isNotificationHandled(int notificationType) =>
      (_notificationsHandled.value & Notify.bit(notificationType)) != 0;

  /// The collection of primitives that make up the list.
  List<Primitive> get listItems => _listItems.value;
  set listItems(List<Primitive> listItems) => _listItems.value = listItems;

  /// Whether the list flows horizontally instead of vertically.
  bool get horizontal => _horizontal.value;
  set horizontal(bool value) => _horizontal.value = value;

  /// The currently selected item(s) or empty if none selected.
  List<int> get selectedItems {
    return _selectedItems.value;
  }

  set selectedItems(List<int> selectedItems) {
    _selectedItems.value = selectedItems;
  }

  /// The selection mode of the list, 0 = None, 1 = One Always Selected, 2 = One or None, 3 = Multiple
  /// 4 = Range Atleast One, 5 = Range Any or None at all.
  int get selectionMode => _selectionMode.value;
  set selectionMode(int selectionMode) => _selectionMode.value = selectionMode;

  /// The model primitive which all list items will be like.  It is mainly used to
  /// specify embodiment settings to use for all list items.
  Primitive? get modelItem {
    return _modelItem.value;
  }

  set modelItem(Primitive? p) {
    _modelItem.value = p;
  }

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
