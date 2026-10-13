// Copyright 2024-2026 ProntoGUI, LLC
// ProntoGUI™ is a trademark of ProntoGUI, LLC
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'pkey.dart';
import 'primitive.dart';
import 'primitive_base.dart';
import 'notification.dart';
import 'integer_field.dart';
import 'string_field.dart';
import 'any_field.dart';
import 'enums.dart';
import 'text_style_fields.dart';
import 'color.dart';
import 'opt_field.dart';
import 'fkey.dart';

// A choice presented to the user that give three possible states:  Affirmative (Yes, On, 1, etc.),
// Negative (No, Off, 0, etc.), and Indeterminate.
class Tristate extends PrimitiveBase with TextStyleFieldsMixin {
  Tristate(
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
      CheckBoxPosition? checkBoxPosition,
      int state = 0,
      String label = '',
      Primitive? labelItem,
      LabelItemPosition? labelItemPosition,
      int status = 0}) {
    _state = IntegerField.from(state);
    _label = StringField.from(label);
    _labelItem = AnyField.from(labelItem);
    _status = IntegerField.from(status);

    this.fontColor = fontColor;
    this.fontFamily = fontFamily;
    this.fontSize = fontSize;
    this.fontStyle = fontStyle;
    this.fontWeight = fontWeight;
    this.horizontalTextAlignment = horizontalTextAlignment;
    this.verticalTextAlignment = verticalTextAlignment;
    this.checkBoxPosition = checkBoxPosition;
    this.labelItemPosition = labelItemPosition;
  }

  // Field storage
  final _checkBoxPosition =
      EnumOptField<CheckBoxPosition>(CheckBoxPosition.values);
  late IntegerField _state;
  late StringField _label;
  late AnyField _labelItem;
  final _labelItemPosition =
      EnumOptField<LabelItemPosition>(LabelItemPosition.values);
  late IntegerField _status;

  // Server -> App bitmask of handled notifications (see Notify.bit).
  final _notificationsHandled = IntegerField();

  @override
  String get describeType => 'Tristate';

  // Field keys for tristate's own fields (see firstOwnFKey in
  // fkey.dart). Fixed and append-only, matching golib field-for-field -
  // see fkey.dart's doc comment.
  static const _fkLabelItem = 100;
  static const _fkLabel = 101;
  static const _fkState = 102;
  static const _fkCheckBoxPosition = 103;
  static const _fkLabelItemPosition = 104;

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
    fieldRefs.add(FieldRef(_fkState, 'State', _state));
    fieldRefs.add(FieldRef(fkStatus, 'Status', _status));
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

  @override
  bool isNotificationHandled(int notificationType) =>
      (_notificationsHandled.value & Notify.bit(notificationType)) != 0;

  /// The state of the option (0 = Negative, 1 = Affirmative, and -1 = Indeterminate).
  int get state => _state.value;
  set state(int state) => _state.value = state;

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

  /// Where the checkbox is drawn relative to its label. Null means unset/
  /// default (top).
  CheckBoxPosition? get checkBoxPosition => _checkBoxPosition.value;
  set checkBoxPosition(CheckBoxPosition? value) =>
      _checkBoxPosition.value = value;

  /// Alternative getter of state represented as nullable boolean.
  bool? get stateAsBool {
    switch (state) {
      case 0:
        return false;
      case 1:
        return true;
      case 2:
        return null;
      default:
        assert(false);
    }
    return null;
  }

  /// Alternative setter of state using a nullable boolean.  Calling this function also
  /// sets the state field appropriately.
  set stateAsBool(bool? boolState) {
    if (boolState == null) {
      state = 2;
    } else if (boolState) {
      state = 1;
    } else {
      state = 0;
    }
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

  /// Cycles to the next state.
  void nextState() {
    switch (state) {
      case 0:
        state = 1;
      case 1:
        state = 2;
      case 2:
        state = 0;
      default:
        state = 0;
    }
  }
}
