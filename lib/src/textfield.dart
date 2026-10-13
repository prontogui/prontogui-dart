// Copyright 2024-2026 ProntoGUI, LLC
// ProntoGUI™ is a trademark of ProntoGUI, LLC
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'primitive_base.dart';
import 'notification.dart';
import 'integer_field.dart';
import 'string_field.dart';
import 'boolean_field.dart';
import 'enums.dart';
import 'text_style_fields.dart';
import 'color.dart';
import 'opt_field.dart';
import 'fkey.dart';

// An entry field that allows the user to enter text.
class TextField extends PrimitiveBase with TextStyleFieldsMixin {
  TextField(
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
      FocusSelection? focusSelection,
      bool hideText = false,
      String? hidingCharacter,
      int? maxDisplayLines,
      int? maxLength,
      int? maxLines,
      int? minDisplayLines,
      String textEntry = '',
      int status = 0}) {
    _textEntry = StringField.from(textEntry);
    _status = IntegerField.from(status);

    this.fontColor = fontColor;
    this.fontFamily = fontFamily;
    this.fontSize = fontSize;
    this.fontStyle = fontStyle;
    this.fontWeight = fontWeight;
    this.horizontalTextAlignment = horizontalTextAlignment;
    this.verticalTextAlignment = verticalTextAlignment;
    this.focusSelection = focusSelection;
    this.hideText = hideText;
    this.hidingCharacter = hidingCharacter;
    this.maxDisplayLines = maxDisplayLines;
    this.maxLength = maxLength;
    this.maxLines = maxLines;
    this.minDisplayLines = minDisplayLines;
  }

  // Field storage
  final _focusSelection = EnumOptField<FocusSelection>(FocusSelection.values);
  final _hideText = BooleanField();
  final _hidingCharacter = StringField();
  final _maxDisplayLines = IntegerField();
  final _maxLength = IntegerField();
  final _maxLines = IntegerField();
  final _minDisplayLines = IntegerField();
  late StringField _textEntry;
  late IntegerField _status;

  // Server -> App bitmask of handled notifications (see Notify.bit).
  final _notificationsHandled = IntegerField();

  @override
  String get describeType => 'TextField';

  // Field keys for textfield's own fields (see firstOwnFKey in
  // fkey.dart). Fixed and append-only, matching golib field-for-field -
  // see fkey.dart's doc comment.
  static const _fkTextEntry = 100;
  static const _fkFocusSelection = 101;
  static const _fkHideText = 102;
  static const _fkHidingCharacter = 103;
  static const _fkMaxDisplayLines = 104;
  static const _fkMaxLength = 105;
  static const _fkMaxLines = 106;
  static const _fkMinDisplayLines = 107;

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
    fieldRefs
        .add(FieldRef(_fkFocusSelection, 'FocusSelection', _focusSelection));
    fieldRefs.add(fontColorFieldRef());
    fieldRefs.add(fontFamilyFieldRef());
    fieldRefs.add(fontSizeFieldRef());
    fieldRefs.add(fontStyleFieldRef());
    fieldRefs.add(fontWeightFieldRef());
    fieldRefs.add(heightFieldRef());
    fieldRefs.add(FieldRef(_fkHideText, 'HideText', _hideText));
    fieldRefs
        .add(FieldRef(_fkHidingCharacter, 'HidingCharacter', _hidingCharacter));
    fieldRefs.add(horizontalAlignmentFieldRef());
    fieldRefs.add(horizontalTextAlignmentFieldRef());
    fieldRefs.add(leftFieldRef());
    fieldRefs.add(marginAllFieldRef());
    fieldRefs.add(marginBottomFieldRef());
    fieldRefs.add(marginLeftFieldRef());
    fieldRefs.add(marginRightFieldRef());
    fieldRefs.add(marginTopFieldRef());
    fieldRefs
        .add(FieldRef(_fkMaxDisplayLines, 'MaxDisplayLines', _maxDisplayLines));
    fieldRefs.add(FieldRef(_fkMaxLength, 'MaxLength', _maxLength));
    fieldRefs.add(FieldRef(_fkMaxLines, 'MaxLines', _maxLines));
    fieldRefs
        .add(FieldRef(_fkMinDisplayLines, 'MinDisplayLines', _minDisplayLines));
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
    fieldRefs.add(FieldRef(_fkTextEntry, 'TextEntry', _textEntry));
    fieldRefs.add(topFieldRef());
    fieldRefs.add(verticalAlignmentFieldRef());
    fieldRefs.add(verticalTextAlignmentFieldRef());
    fieldRefs.add(widthFieldRef());
  }

  @override
  String toString() {
    return _textEntry.value;
  }

  @override
  bool isNotificationHandled(int notificationType) =>
      (_notificationsHandled.value & Notify.bit(notificationType)) != 0;

  /// The initial text to show user and also the text entered by the user.
  String get textEntry => _textEntry.value;
  set textEntry(String textEntry) => _textEntry.value = textEntry;

  /// Which part of the entry is selected when it first gains focus. Null
  /// means unset/default (begin).
  FocusSelection? get focusSelection => _focusSelection.value;
  set focusSelection(FocusSelection? value) => _focusSelection.value = value;

  /// Whether the entered text is obscured (e.g. a password field).
  bool get hideText => _hideText.value;
  set hideText(bool value) => _hideText.value = value;

  /// The character used to obscure text when hideText is true, or null if
  /// unset.
  String? get hidingCharacter =>
      _hidingCharacter.isDefault ? null : _hidingCharacter.value;
  set hidingCharacter(String? value) => _hidingCharacter.value = value ?? '';

  /// The maximum number of lines to display, or null if unset.
  int? get maxDisplayLines =>
      _maxDisplayLines.isDefault ? null : _maxDisplayLines.value;
  set maxDisplayLines(int? value) => _maxDisplayLines.value = value ?? 0;

  /// The maximum number of characters allowed, or null if unset.
  int? get maxLength => _maxLength.isDefault ? null : _maxLength.value;
  set maxLength(int? value) => _maxLength.value = value ?? 0;

  /// The maximum number of lines allowed, or null if unset.
  int? get maxLines => _maxLines.isDefault ? null : _maxLines.value;
  set maxLines(int? value) => _maxLines.value = value ?? 0;

  /// The minimum number of lines to display, or null if unset.
  int? get minDisplayLines =>
      _minDisplayLines.isDefault ? null : _minDisplayLines.value;
  set minDisplayLines(int? value) => _minDisplayLines.value = value ?? 0;

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
