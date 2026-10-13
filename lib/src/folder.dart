// Copyright 2024-2026 ProntoGUI, LLC
// ProntoGUI™ is a trademark of ProntoGUI, LLC
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'pkey.dart';
import 'primitive_base.dart';
import 'notification.dart';
import 'any_field.dart';
import 'boolean_field.dart';
import 'integer_field.dart';
import 'primitive.dart';
import 'enum_field.dart';
import 'enums.dart';
import 'fkey.dart';

/// A folder represents a container in a hierarchical list structure. It contains
/// a label item (any primitive) and a level indicating its depth in the hierarchy.
/// The Open field controls whether items logically "inside" this folder are shown.
class Folder extends PrimitiveBase {
  Folder({
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
    bool open = false,
    FolderIcons? folderIcons,
    Primitive? labelItem,
    int level = 0,
    int status = 0,
  }) {
    _open = BooleanField.from(open);
    _labelItem = AnyField.from(labelItem);
    _level = IntegerField.from(level);
    _status = IntegerField.from(status);

    this.folderIcons = folderIcons;
  }

  // Field storage
  late BooleanField _open;
  final _folderIcons = EnumField<FolderIcons>(FolderIcons.values);
  late AnyField _labelItem;
  late IntegerField _level;
  late IntegerField _status;

  // Server -> App bitmask of handled notifications (see Notify.bit).
  final _notificationsHandled = IntegerField();

  @override
  String get describeType => 'Folder';

  // Field keys for folder's own fields (see firstOwnFKey in
  // fkey.dart). Fixed and append-only, matching golib field-for-field -
  // see fkey.dart's doc comment.
  static const _fkLabelItem = 100;
  static const _fkOpen = 101;
  static const _fkLevel = 102;
  static const _fkFolderIcons = 103;

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
    fieldRefs.add(FieldRef(_fkOpen, 'Open', _open));
    fieldRefs.add(FieldRef(_fkFolderIcons, 'FolderIcons', _folderIcons));
    fieldRefs.add(heightFieldRef());
    fieldRefs.add(horizontalAlignmentFieldRef());
    fieldRefs.add(FieldRef(_fkLabelItem, 'LabelItem', _labelItem));
    fieldRefs.add(leftFieldRef());
    fieldRefs.add(FieldRef(_fkLevel, 'Level', _level));
    fieldRefs.add(marginAllFieldRef());
    fieldRefs.add(marginBottomFieldRef());
    fieldRefs.add(marginLeftFieldRef());
    fieldRefs.add(marginRightFieldRef());
    fieldRefs.add(marginTopFieldRef());
    fieldRefs.add(FieldRef(
        fkNotificationsHandled, 'NotificationsHandled', _notificationsHandled));
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
    fieldRefs.add(widthFieldRef());
  }

  @override
  Primitive locateNextDescendant(PKeyLocator locator) {
    var nextIndex = locator.nextIndex();
    switch (nextIndex) {
      case 0:
        if (_labelItem.value == null) {
          throw Exception('PKey locator is out of bounds');
        }
        return _labelItem.value!;
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

  /// Whether the folder is open/expanded (showing its children).
  bool get open => _open.value;
  set open(bool open) => _open.value = open;

  /// The icon style used to indicate expand/collapse state. Null means
  /// unset/default (chevron).
  FolderIcons? get folderIcons =>
      _folderIcons.isDefault ? null : _folderIcons.value;
  set folderIcons(FolderIcons? value) =>
      _folderIcons.value = value ?? FolderIcons.chevron;

  /// An optional primitive that visually represents the folder in the list.
  Primitive? get labelItem => _labelItem.value;
  set labelItem(Primitive? labelItem) => _labelItem.value = labelItem;

  /// The depth level of this folder in the hierarchy.
  int get level => _level.value;
  set level(int level) => _level.value = level;

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
