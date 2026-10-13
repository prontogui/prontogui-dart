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

/// A ColorField is a text entry for a colour value, formatted as "#AARRGGBB",
/// with a popup colour picker. It was NumericField's "color" embodiment before
/// the Embodiment field was removed. Set allowEmptyValue to permit a blank
/// value. Mirrors golib's colorfield.go.
class ColorField extends PrimitiveBase with TextStyleFieldsMixin {
  ColorField(
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
      String colorEntry = '',
      FocusSelection? focusSelection,
      int status = 0}) {
    _colorEntry = StringField.from(colorEntry);
    _status = IntegerField.from(status);

    this.fontColor = fontColor;
    this.fontFamily = fontFamily;
    this.fontSize = fontSize;
    this.fontStyle = fontStyle;
    this.fontWeight = fontWeight;
    this.horizontalTextAlignment = horizontalTextAlignment;
    this.verticalTextAlignment = verticalTextAlignment;
    this.allowEmptyValue = allowEmptyValue;
    this.focusSelection = focusSelection;
  }

  // Field storage
  final _allowEmptyValue = BooleanField();
  late StringField _colorEntry;
  final _focusSelection = EnumOptField<FocusSelection>(FocusSelection.values);
  late IntegerField _status;

  // Server -> App bitmask of handled notifications (see Notify.bit).
  final _notificationsHandled = IntegerField();

  @override
  String get describeType => 'ColorField';

  // Field keys for colorfield's own fields (see firstOwnFKey in fkey.dart).
  // Fixed and append-only, matching golib's colorfield.go.
  static const _fkColorEntry = 100;
  static const _fkAllowEmptyValue = 101;
  static const _fkFocusSelection = 102;

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
    fieldRefs.add(FieldRef(_fkColorEntry, 'ColorEntry', _colorEntry));
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
    fieldRefs.add(verticalTextAlignmentFieldRef());
    fieldRefs.add(widthFieldRef());
  }

  @override
  String toString() => _colorEntry.value;

  @override
  bool isNotificationHandled(int notificationType) =>
      (_notificationsHandled.value & Notify.bit(notificationType)) != 0;

  /// The colour value, formatted "#AARRGGBB" (or "" when empty).
  String get colorEntry => _colorEntry.value;
  set colorEntry(String value) => _colorEntry.value = value;

  /// Whether a blank value is permitted.
  bool get allowEmptyValue => _allowEmptyValue.value;
  set allowEmptyValue(bool value) => _allowEmptyValue.value = value;

  /// Which part of the entry is selected when it first gains focus. Null
  /// means unset/default (begin).
  FocusSelection? get focusSelection => _focusSelection.value;
  set focusSelection(FocusSelection? value) => _focusSelection.value = value;

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
