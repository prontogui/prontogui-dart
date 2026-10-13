// Copyright 2024-2026 ProntoGUI, LLC
// ProntoGUI™ is a trademark of ProntoGUI, LLC
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'primitive_base.dart';
import 'notification.dart';
import 'string_field.dart';
import 'integer_field.dart';
import 'boolean_field.dart';
import 'strings1d_field.dart';
import 'enum_field.dart';
import 'enums.dart';
import 'text_style_fields.dart';
import 'color.dart';
import 'opt_field.dart';
import 'fkey.dart';

// An entry field that allows the user to enter numeric values.
class NumericField extends PrimitiveBase with TextStyleFieldsMixin {
  NumericField(
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
      bool allowEmptyValue = false,
      int? displayDecimalPlaces,
      DisplayNegativeFormat? displayNegativeFormat,
      bool displayThousandths = false,
      FocusSelection? focusSelection,
      double? maxValue,
      double? minValue,
      String numericEntry = '',
      List<String>? popupChoices,
      String? popupChooserIcon,
      int status = 0}) {
    _numericEntry = StringField.from(numericEntry);
    _status = IntegerField.from(status);

    this.fontColor = fontColor;
    this.fontFamily = fontFamily;
    this.fontSize = fontSize;
    this.fontStyle = fontStyle;
    this.fontWeight = fontWeight;
    this.horizontalTextAlignment = horizontalTextAlignment;
    this.verticalTextAlignment = verticalTextAlignment;
    this.allowEmptyValue = allowEmptyValue;
    this.displayDecimalPlaces = displayDecimalPlaces;
    this.displayNegativeFormat = displayNegativeFormat;
    this.displayThousandths = displayThousandths;
    this.focusSelection = focusSelection;
    this.maxValue = maxValue;
    this.minValue = minValue;
    this.popupChoices = popupChoices;
    this.popupChooserIcon = popupChooserIcon;
  }

  // The numeric value, as text, that was entered by user.
  final _allowEmptyValue = BooleanField();
  final _displayDecimalPlaces = IntegerOptField();
  final _displayNegativeFormat =
      EnumField<DisplayNegativeFormat>(DisplayNegativeFormat.values);
  final _displayThousandths = BooleanField();
  final _focusSelection = EnumOptField<FocusSelection>(FocusSelection.values);
  final _maxValue = DoubleOptField();
  final _minValue = DoubleOptField();
  late StringField _numericEntry;
  final _popupChoices = Strings1DField();
  final _popupChooserIcon = StringField();
  late IntegerField _status;

  // Server -> App bitmask of handled notifications (see Notify.bit).
  final _notificationsHandled = IntegerField();

  @override
  String get describeType => 'NumericField';

  // Field keys for numericfield's own fields (see firstOwnFKey in
  // fkey.dart). Fixed and append-only, matching golib field-for-field -
  // see fkey.dart's doc comment.
  static const _fkNumericEntry = 100;
  static const _fkAllowEmptyValue = 101;
  static const _fkDisplayDecimalPlaces = 102;
  static const _fkDisplayNegativeFormat = 103;
  static const _fkDisplayThousandths = 104;
  static const _fkFocusSelection = 105;
  static const _fkMaxValue = 106;
  static const _fkMinValue = 107;
  static const _fkPopupChoices = 108;
  static const _fkPopupChooserIcon = 109;

  @override
  void describeFields(List<FieldRef> fieldRefs) {
    fieldRefs
        .add(FieldRef(_fkAllowEmptyValue, 'AllowEmptyValue', _allowEmptyValue));
    fieldRefs.add(backgroundColorFieldRef());
    fieldRefs.add(borderAllFieldRef());
    fieldRefs.add(borderBottomFieldRef());
    fieldRefs.add(borderColorFieldRef());
    fieldRefs.add(borderLeftFieldRef());
    fieldRefs.add(borderRightFieldRef());
    fieldRefs.add(borderTopFieldRef());
    fieldRefs.add(bottomFieldRef());
    fieldRefs.add(FieldRef(_fkDisplayDecimalPlaces, 'DisplayDecimalPlaces',
        _displayDecimalPlaces));
    fieldRefs.add(FieldRef(_fkDisplayNegativeFormat, 'DisplayNegativeFormat',
        _displayNegativeFormat));
    fieldRefs.add(FieldRef(
        _fkDisplayThousandths, 'DisplayThousandths', _displayThousandths));
    fieldRefs
        .add(FieldRef(_fkFocusSelection, 'FocusSelection', _focusSelection));
    fieldRefs.add(fontColorFieldRef());
    fieldRefs.add(fontFamilyFieldRef());
    fieldRefs.add(fontSizeFieldRef());
    fieldRefs.add(fontStyleFieldRef());
    fieldRefs.add(fontWeightFieldRef());
    fieldRefs.add(heightFieldRef());
    fieldRefs.add(horizontalAlignmentFieldRef());
    fieldRefs.add(horizontalTextAlignmentFieldRef());
    fieldRefs.add(leftFieldRef());
    fieldRefs.add(marginAllFieldRef());
    fieldRefs.add(marginBottomFieldRef());
    fieldRefs.add(marginLeftFieldRef());
    fieldRefs.add(marginRightFieldRef());
    fieldRefs.add(marginTopFieldRef());
    fieldRefs.add(FieldRef(_fkMaxValue, 'MaxValue', _maxValue));
    fieldRefs.add(FieldRef(_fkMinValue, 'MinValue', _minValue));
    fieldRefs.add(FieldRef(_fkNumericEntry, 'NumericEntry', _numericEntry));
    fieldRefs.add(FieldRef(
        fkNotificationsHandled, 'NotificationsHandled', _notificationsHandled));
    fieldRefs.add(paddingAllFieldRef());
    fieldRefs.add(paddingBottomFieldRef());
    fieldRefs.add(paddingLeftFieldRef());
    fieldRefs.add(paddingRightFieldRef());
    fieldRefs.add(paddingTopFieldRef());
    fieldRefs.add(FieldRef(_fkPopupChoices, 'PopupChoices', _popupChoices));
    fieldRefs.add(
        FieldRef(_fkPopupChooserIcon, 'PopupChooserIcon', _popupChooserIcon));
    fieldRefs.add(rightFieldRef());
    fieldRefs.add(FieldRef(fkStatus, 'Status', _status));
    fieldRefs.add(tagFieldRef());
    fieldRefs.add(topFieldRef());
    fieldRefs.add(verticalAlignmentFieldRef());
    fieldRefs.add(verticalTextAlignmentFieldRef());
    fieldRefs.add(widthFieldRef());
  }

  @override
  String toString() {
    return _numericEntry.value;
  }

  @override
  bool isNotificationHandled(int notificationType) =>
      (_notificationsHandled.value & Notify.bit(notificationType)) != 0;

  /// The initial numeric text to show user and, also, the text entered by the user.
  String get numericEntry => _numericEntry.value;
  set numericEntry(String numericEntry) => _numericEntry.value = numericEntry;

  /// Whether the field may be left empty (no numeric value entered).
  bool get allowEmptyValue => _allowEmptyValue.value;
  set allowEmptyValue(bool value) => _allowEmptyValue.value = value;

  /// How many fractional digits to display when not editing: n >= 0 shows
  /// exactly n digits, -n shows up to n digits (trailing zeros dropped), and
  /// null (unset) shows the value as entered.
  int? get displayDecimalPlaces => _displayDecimalPlaces.value;
  set displayDecimalPlaces(int? value) => _displayDecimalPlaces.value = value;

  /// How a negative value is displayed. Null means unset/default (absolute).
  DisplayNegativeFormat? get displayNegativeFormat =>
      _displayNegativeFormat.isDefault ? null : _displayNegativeFormat.value;
  set displayNegativeFormat(DisplayNegativeFormat? value) =>
      _displayNegativeFormat.value = value ?? DisplayNegativeFormat.absolute;

  /// Whether thousandths separators are displayed.
  bool get displayThousandths => _displayThousandths.value;
  set displayThousandths(bool value) => _displayThousandths.value = value;

  /// Which part of the entry is selected when it first gains focus. Null
  /// means unset/default (begin).
  FocusSelection? get focusSelection => _focusSelection.value;
  set focusSelection(FocusSelection? value) => _focusSelection.value = value;

  /// The maximum allowed value, or null if unset.
  double? get maxValue => _maxValue.value;
  set maxValue(double? value) => _maxValue.value = value;

  /// The minimum allowed value, or null if unset.
  double? get minValue => _minValue.value;
  set minValue(double? value) => _minValue.value = value;

  /// The list of choices to show in a popup chooser, or null if unset.
  List<String>? get popupChoices =>
      _popupChoices.isDefault ? null : _popupChoices.value;
  set popupChoices(List<String>? value) => _popupChoices.value = value ?? [];

  /// The Material icon ID for the popup-chooser button, or null if unset
  /// (the App picks a default). Only meaningful when [popupChoices] is set.
  String? get popupChooserIcon =>
      _popupChooserIcon.isDefault ? null : _popupChooserIcon.value;
  set popupChooserIcon(String? value) => _popupChooserIcon.value = value ?? '';

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
