// Copyright 2024-2026 ProntoGUI, LLC
// ProntoGUI™ is a trademark of ProntoGUI, LLC
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'primitive_base.dart';
import 'notification.dart';
import 'text_style_fields.dart';
import 'string_field.dart';
import 'integer_field.dart';
import 'enum_field.dart';
import 'strings1d_field.dart';
import 'color.dart';
import 'enums.dart';
import 'fkey.dart';

/// A choice is a user selection from a set of choices.  It is often represented using a pull-down list.
///
/// An initial choice is provided by [choice] parameter which maps to a value contained [choices].
/// Optional labels for each choice are supplied using [choiceLabels], where each label corresponds
/// to the associated element in [choices].
class Choice extends PrimitiveBase with TextStyleFieldsMixin {
  Choice(
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
      String choice = '',
      List<String> choices = const [],
      List<String> choiceLabels = const [],
      int status = 0,
      ChoiceStyle? style}) {
    _choice = StringField.from(choice);
    _choices = Strings1DField.from(choices);
    _choiceLabels = Strings1DField.from(choiceLabels);
    _status = IntegerField.from(status);
    this.style = style;

    this.fontColor = fontColor;
    this.fontFamily = fontFamily;
    this.fontSize = fontSize;
    this.fontStyle = fontStyle;
    this.fontWeight = fontWeight;
    this.horizontalTextAlignment = horizontalTextAlignment;
    this.verticalTextAlignment = verticalTextAlignment;
  }

  // Field storage
  late StringField _choice;
  late Strings1DField _choices;
  late Strings1DField _choiceLabels;
  late IntegerField _status;
  final _style = EnumField<ChoiceStyle>(ChoiceStyle.values);

  // Server -> App bitmask of handled notifications (see Notify.bit).
  final _notificationsHandled = IntegerField();

  @override
  String get describeType => 'Choice';

  // Field keys for choice's own fields (see firstOwnFKey in
  // fkey.dart). Fixed and append-only, matching golib field-for-field -
  // see fkey.dart's doc comment.
  static const _fkChoice = 100;
  static const _fkChoiceLabels = 101;
  static const _fkChoices = 102;
  static const _fkStyle = 103;

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
    fieldRefs.add(FieldRef(_fkChoice, 'Choice', _choice));
    fieldRefs.add(FieldRef(_fkChoiceLabels, 'ChoiceLabels', _choiceLabels));
    fieldRefs.add(FieldRef(_fkChoices, 'Choices', _choices));
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
    fieldRefs.add(FieldRef(_fkStyle, 'Style', _style));
    fieldRefs.add(tagFieldRef());
    fieldRefs.add(topFieldRef());
    fieldRefs.add(verticalAlignmentFieldRef());
    fieldRefs.add(verticalTextAlignmentFieldRef());
    fieldRefs.add(widthFieldRef());
  }

  @override
  String toString() {
    return _choice.value;
  }

  @override
  bool isNotificationHandled(int notificationType) =>
      (_notificationsHandled.value & Notify.bit(notificationType)) != 0;

  /// The selected choice or empty if none chosen.
  String get choice => _choice.value;
  set choice(String choice) => _choice.value = choice;

  /// The set of valid choices to choose from.
  List<String> get choices => _choices.value;
  set choices(List<String> choices) => _choices.value = choices;

  /// The optional associated labels for each item in choices.
  List<String> get choiceLabels => _choiceLabels.value;
  set choiceLabels(List<String> choices) => _choiceLabels.value = choices;

  /// The index (0, 1, ..) of selected choice or -1 if choice is empty.  This is a covenvenience
  /// function as an alternative to Choice().  The canonical storage of choice remains a string.
  /// Also used to set the selected choice or empty if none chosen or if index is out of range.
  int get choiceIndex => _choices.value.indexOf(_choice.value);
  set choiceIndex(int index) {
    if (index >= 0 && index < _choices.value.length) {
      _choice.value = _choices.value[index];
    } else {
      _choice.value = '';
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

  /// The visual style. Null means unset (dropdown).
  ChoiceStyle? get style => _style.isDefault ? null : _style.value;
  set style(ChoiceStyle? value) => _style.value = value ?? ChoiceStyle.dropdown;

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

  /// Returns whether or not the choice is valid.
  bool get isChoiceValid {
    return choices.contains(choice);
  }

  /// Returns the label to display for a given choice.
}
