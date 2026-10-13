// Copyright 2024-2026 ProntoGUI, LLC
// ProntoGUI™ is a trademark of ProntoGUI, LLC
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'pkey.dart';
import 'primitive.dart';
import 'primitive_base.dart';
import 'notification.dart';
import 'boolean_field.dart';
import 'string_field.dart';
import 'integer_field.dart';
import 'any_field.dart';
import 'enum_field.dart';
import 'enums.dart';
import 'text_style_fields.dart';
import 'color.dart';
import 'opt_field.dart';
import 'fkey.dart';

/// A check provides a yes/no, on/off, 1/0, kind of choice to the user.
/// It is often represented with a check box like you would see on a form.
class Check extends PrimitiveBase with TextStyleFieldsMixin {
  Check(
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
      Color? fontColor,
      String? fontFamily,
      double? fontSize,
      FontStyle? fontStyle,
      FontWeight? fontWeight,
      HorizontalTextAlignment? horizontalTextAlignment,
      VerticalTextAlignment? verticalTextAlignment,
      bool checked = false,
      CheckBoxPosition? checkBoxPosition,
      Color? checkedBackgroundColor,
      String label = '',
      Primitive? labelItem,
      LabelItemPosition? labelItemPosition,
      int status = 0,
      CheckStyle? style}) {
    _checked = BooleanField.from(checked);
    _label = StringField.from(label);
    _labelItem = AnyField.from(labelItem);
    _status = IntegerField.from(status);
    this.style = style;
    this.fontColor = fontColor;
    this.fontFamily = fontFamily;
    this.fontSize = fontSize;
    this.fontStyle = fontStyle;
    this.fontWeight = fontWeight;
    this.horizontalTextAlignment = horizontalTextAlignment;
    this.verticalTextAlignment = verticalTextAlignment;
    this.checkBoxPosition = checkBoxPosition;
    this.checkedBackgroundColor = checkedBackgroundColor;
    this.labelItemPosition = labelItemPosition;
  }

  // Field storage
  late BooleanField _checked;
  final _checkBoxPosition =
      EnumOptField<CheckBoxPosition>(CheckBoxPosition.values);
  final _checkedBackgroundColor = ColorOptField();
  late StringField _label;
  late AnyField _labelItem;
  final _labelItemPosition =
      EnumOptField<LabelItemPosition>(LabelItemPosition.values);
  late IntegerField _status;
  final _style = EnumField<CheckStyle>(CheckStyle.values);

  // Server → App bitmask of which notifications have a handler (see Notify.bit).
  final _notificationsHandled = IntegerField();

  @override
  String get describeType => 'Check';

  // Field keys for check's own fields (see firstOwnFKey in
  // fkey.dart). Fixed and append-only, matching golib field-for-field -
  // see fkey.dart's doc comment.
  static const _fkLabelItem = 100;
  static const _fkChecked = 101;
  static const _fkLabel = 102;
  static const _fkCheckBoxPosition = 103;
  static const _fkLabelItemPosition = 104;
  static const _fkCheckedBackgroundColor = 105;
  static const _fkStyle = 106;

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
    fieldRefs.add(
        FieldRef(_fkCheckBoxPosition, 'CheckBoxPosition', _checkBoxPosition));
    fieldRefs.add(FieldRef(_fkChecked, 'Checked', _checked));
    fieldRefs.add(FieldRef(_fkCheckedBackgroundColor, 'CheckedBackgroundColor',
        _checkedBackgroundColor));
    fieldRefs.add(fontColorFieldRef());
    fieldRefs.add(fontFamilyFieldRef());
    fieldRefs.add(fontSizeFieldRef());
    fieldRefs.add(fontStyleFieldRef());
    fieldRefs.add(fontWeightFieldRef());
    fieldRefs.add(heightFieldRef());
    fieldRefs.add(horizontalAlignmentFieldRef());
    fieldRefs.add(horizontalTextAlignmentFieldRef());
    fieldRefs.add(FieldRef(_fkLabel, 'Label', _label));
    fieldRefs.add(FieldRef(_fkLabelItem, 'LabelItem', _labelItem));
    fieldRefs.add(FieldRef(
        _fkLabelItemPosition, 'LabelItemPosition', _labelItemPosition));
    fieldRefs.add(leftFieldRef());
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
    fieldRefs.add(FieldRef(_fkStyle, 'Style', _style));
    fieldRefs.add(tagFieldRef());
    fieldRefs.add(topFieldRef());
    fieldRefs.add(verticalAlignmentFieldRef());
    fieldRefs.add(verticalTextAlignmentFieldRef());
    fieldRefs.add(widthFieldRef());
  }

  @override
  Primitive locateNextDescendant(PKeyLocator locator) {
    // The next index specifies which container field to access...
    var nextIndex = locator.nextIndex();
    switch (nextIndex) {
      case 0:
        return _labelItem.value!;
      default:
        throw Exception('PKey locator is out of bounds');
    }
  }

  @override
  String toString() {
    return _label.value;
  }

  /// The check state is Yes, On, 1, etc., and false if the check state is No, Off, 0, etc.
  bool get checked => _checked.value;
  set checked(bool checked) => _checked.value = checked;

  @override
  bool isNotificationHandled(int notificationType) =>
      (_notificationsHandled.value & Notify.bit(notificationType)) != 0;

  /// Where the checkbox is drawn relative to its label. Null means unset/
  /// default (top).
  CheckBoxPosition? get checkBoxPosition => _checkBoxPosition.value;
  set checkBoxPosition(CheckBoxPosition? value) =>
      _checkBoxPosition.value = value;

  /// The background color to use when checked is true, or null if unset -
  /// meaning the "toggle-button" embodiment should fall back to its own
  /// default checked-background color.
  Color? get checkedBackgroundColor => _checkedBackgroundColor.value;
  set checkedBackgroundColor(Color? value) =>
      _checkedBackgroundColor.value = value;

  /// The text label to display.
  String get label => _label.value;
  set label(String label) => _label.value = label;

  /// The alternate label primitive to display. If specified then it supercedes label field.
  Primitive? get labelItem => _labelItem.value;
  set labelItem(Primitive? value) => _labelItem.value = value;

  /// Where labelItem is positioned relative to label. Null means unset/
  /// default (top).
  LabelItemPosition? get labelItemPosition => _labelItemPosition.value;
  set labelItemPosition(LabelItemPosition? value) =>
      _labelItemPosition.value = value;

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

  /// The visual style. Null means unset (checkbox).
  CheckStyle? get style => _style.isDefault ? null : _style.value;
  set style(CheckStyle? value) => _style.value = value ?? CheckStyle.checkbox;

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

  /// Cycles to the next state.
  void nextState() {
    checked = !checked;
  }
}
