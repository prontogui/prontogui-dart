// Copyright 2024-2026 ProntoGUI, LLC
// ProntoGUI™ is a trademark of ProntoGUI, LLC
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'pkey.dart';
import 'primitive_base.dart';
import 'notification.dart';
import 'any_field.dart';
import 'any1d_field.dart';
import 'integer_field.dart';
import 'integer1d_field.dart';
import 'primitive.dart';
import 'fkey.dart';

/// A FolderList presents a collection of Folder / FolderItem primitives as an
/// indented, expand/collapse tree. It was List's "folder-list" embodiment
/// before the Embodiment field was removed. modelFolder / modelItem supply
/// per-row templates for folders and leaf items respectively. Mirrors golib's
/// folderlist.go.
class FolderList extends PrimitiveBase {
  FolderList({
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
    List<Primitive> items = const [],
    Primitive? modelFolder,
    Primitive? modelItem,
    List<int> selectedItems = const [],
    int selectionMode = 0,
    int status = 0,
  }) {
    _items = Any1DField.from(items);
    _modelFolder = AnyField.from(modelFolder);
    _modelItem = AnyField.from(modelItem);
    _selectedItems = Integer1DField.from(selectedItems);
    _selectionMode = IntegerField.from(selectionMode);
    _status = IntegerField.from(status);
  }

  // Field storage
  late Any1DField _items;
  late AnyField _modelFolder;
  late AnyField _modelItem;
  late Integer1DField _selectedItems;
  late IntegerField _selectionMode;
  late IntegerField _status;

  // Server -> App bitmask of handled notifications (see Notify.bit).
  final _notificationsHandled = IntegerField();

  @override
  String get describeType => 'FolderList';

  // Field keys for folderList's own fields (see firstOwnFKey in fkey.dart).
  // Fixed and append-only, matching golib's folderlist.go.
  static const _fkItems = 100;
  static const _fkModelFolder = 101;
  static const _fkModelItem = 102;
  static const _fkSelectedItems = 103;
  static const _fkSelectionMode = 104;

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
    fieldRefs.add(FieldRef(_fkItems, 'Items', _items));
    fieldRefs.add(leftFieldRef());
    fieldRefs.add(marginAllFieldRef());
    fieldRefs.add(marginBottomFieldRef());
    fieldRefs.add(marginLeftFieldRef());
    fieldRefs.add(marginRightFieldRef());
    fieldRefs.add(marginTopFieldRef());
    fieldRefs.add(FieldRef(_fkModelFolder, 'ModelFolder', _modelFolder));
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
    // Container fields alphabetical: Items (0), ModelFolder (1), ModelItem (2).
    switch (locator.nextIndex()) {
      case 0:
        return items[locator.nextIndex()];
      case 1:
        if (_modelFolder.value == null) {
          throw Exception('PKey locator is out of bounds');
        }
        return _modelFolder.value!;
      case 2:
        if (_modelItem.value == null) {
          throw Exception('PKey locator is out of bounds');
        }
        return _modelItem.value!;
      default:
        throw Exception('PKey locator is out of bounds');
    }
  }

  @override
  String toString() => '';

  @override
  bool isNotificationHandled(int notificationType) =>
      (_notificationsHandled.value & Notify.bit(notificationType)) != 0;

  /// The Folder / FolderItem primitives in the tree.
  List<Primitive> get items => _items.value;
  set items(List<Primitive> value) => _items.value = value;

  /// The per-row template for folder rows.
  Primitive? get modelFolder => _modelFolder.value;
  set modelFolder(Primitive? p) => _modelFolder.value = p;

  /// The per-row template for leaf item rows.
  Primitive? get modelItem => _modelItem.value;
  set modelItem(Primitive? p) => _modelItem.value = p;

  /// The selected row indices, or empty if none selected.
  List<int> get selectedItems => _selectedItems.value;
  set selectedItems(List<int> value) => _selectedItems.value = value;

  /// The selection mode: 0 = None, 1 = One Always Selected, 2 = One or None,
  /// 3 = Multiple, 4 = Range Atleast One, 5 = Range Any or None.
  int get selectionMode => _selectionMode.value;
  set selectionMode(int value) => _selectionMode.value = value;

  /// The status of the primitive: 0 = Normal, 1 = Disabled, 2 = Hidden, 3 = Collapsed.
  int get status => _status.value;
  set status(int status) {
    _status.value = status;
  }

  bool get enabled => status == 0;
  set enabled(bool enabled) {
    status = enabled ? 0 : 1;
  }

  bool get visible => status == 0 || status == 1;
  set visible(bool visible) {
    status = visible ? 0 : 2;
  }

  bool get hidden => status == 2;
  set hidden(bool hidden) {
    status = hidden ? 2 : 0;
  }

  bool get collapsed => status == 3;
  set collapsed(bool collapsed) {
    status = collapsed ? 3 : 0;
  }
}
