// Copyright 2024-2026 ProntoGUI, LLC
// ProntoGUI™ is a trademark of ProntoGUI, LLC
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'primitive_base.dart';
import 'string_field.dart';
import 'integer_field.dart';
import 'color.dart';
import 'color_value_field.dart';
import 'double_field.dart';
import 'fkey.dart';

/// An icon to display on the screen.
class Icon extends PrimitiveBase {
  Icon(
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
      Color? color,
      String iconID = '',
      double? size,
      int status = 0}) {
    _iconID = StringField.from(iconID);
    _status = IntegerField.from(status);
    this.color = color;
    this.size = size;
  }

  // Field storage
  final _color = ColorValueField();
  late StringField _iconID;
  final _size = DoubleField();
  late IntegerField _status;

  @override
  String get describeType => 'Icon';

  // Field keys for icon's own fields (see firstOwnFKey in
  // fkey.dart). Fixed and append-only, matching golib field-for-field -
  // see fkey.dart's doc comment.
  static const _fkIconID = 100;
  static const _fkColor = 101;
  static const _fkSize = 102;

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
    fieldRefs.add(FieldRef(_fkColor, 'Color', _color));
    fieldRefs.add(heightFieldRef());
    fieldRefs.add(horizontalAlignmentFieldRef());
    fieldRefs.add(FieldRef(_fkIconID, 'IconID', _iconID));
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
    fieldRefs.add(FieldRef(_fkSize, 'Size', _size));
    fieldRefs.add(FieldRef(fkStatus, 'Status', _status));
    fieldRefs.add(tagFieldRef());
    fieldRefs.add(topFieldRef());
    fieldRefs.add(verticalAlignmentFieldRef());
    fieldRefs.add(widthFieldRef());
  }

  @override
  String toString() {
    return _iconID.value;
  }

  /// The Material ID of the icon to use.
  String get iconID => _iconID.value;
  set iconID(String id) {
    _iconID.value = id;
  }

  /// The icon's color, or null if unset.
  Color? get color => _color.isDefault ? null : _color.value;
  set color(Color? value) => _color.value = value ?? Colors.transparent;

  /// The icon's size, or null if unset.
  double? get size => _size.isDefault ? null : _size.value;
  set size(double? value) => _size.value = value ?? 0.0;

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
