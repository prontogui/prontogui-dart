// Copyright 2024-2026 ProntoGUI, LLC
// ProntoGUI™ is a trademark of ProntoGUI, LLC
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'pkey.dart';
import 'primitive_base.dart';
import 'notification.dart';
import 'any_field.dart';
import 'boolean_field.dart';
import 'double_field.dart';
import 'enum_field.dart';
import 'enums.dart';
import 'integer_field.dart';
import 'primitive.dart';
import 'fkey.dart';

/// A snackbar is a brief, transient message shown at the edge of the screen,
/// with an optional action.  It is shown by setting [showing] to true; the
/// app clears [showing] back to false once the message times out or the user
/// dismisses it.  (This was previously the "snackbar" embodiment of Frame.)
class Snackbar extends PrimitiveBase {
  Snackbar(
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
      Primitive? messageItem,
      Primitive? actionItem,
      SnackbarBehavior behavior = SnackbarBehavior.fixed,
      double durationSeconds = 0.0,
      bool showCloseIcon = false,
      bool showing = false,
      int status = 0}) {
    _actionItem = AnyField.from(actionItem);
    _messageItem = AnyField.from(messageItem);
    _durationSeconds = DoubleField.from(durationSeconds);
    _showCloseIcon = BooleanField.from(showCloseIcon);
    _showing = BooleanField.from(showing);
    _status = IntegerField.from(status);
    this.behavior = behavior;
  }

  // Field storage
  late AnyField _actionItem;
  final _behavior = EnumField<SnackbarBehavior>(SnackbarBehavior.values);
  late DoubleField _durationSeconds;
  late AnyField _messageItem;
  late BooleanField _showCloseIcon;
  late BooleanField _showing;
  late IntegerField _status;

  // Server -> App bitmask of handled notifications (see Notify.bit).
  final _notificationsHandled = IntegerField();

  @override
  String get describeType => 'Snackbar';

  // Field keys for snackbar's own fields (see firstOwnFKey in fkey.dart).
  // Fixed and append-only, matching golib field-for-field - see fkey.dart's
  // doc comment.
  static const _fkActionItem = 100;
  static const _fkMessageItem = 101;
  static const _fkBehavior = 102;
  static const _fkDurationSeconds = 103;
  static const _fkShowCloseIcon = 104;
  static const _fkShowing = 105;

  @override
  void describeFields(List<FieldRef> fieldRefs) {
    fieldRefs.add(FieldRef(_fkActionItem, 'ActionItem', _actionItem));
    fieldRefs.add(backgroundColorFieldRef());
    fieldRefs.add(FieldRef(_fkBehavior, 'Behavior', _behavior));
    fieldRefs.add(borderAllFieldRef());
    fieldRefs.add(borderBottomFieldRef());
    fieldRefs.add(borderColorFieldRef());
    fieldRefs.add(borderLeftFieldRef());
    fieldRefs.add(borderRightFieldRef());
    fieldRefs.add(borderTopFieldRef());
    fieldRefs.add(bottomFieldRef());
    fieldRefs
        .add(FieldRef(_fkDurationSeconds, 'DurationSeconds', _durationSeconds));
    fieldRefs.add(heightFieldRef());
    fieldRefs.add(horizontalAlignmentFieldRef());
    fieldRefs.add(leftFieldRef());
    fieldRefs.add(marginAllFieldRef());
    fieldRefs.add(marginBottomFieldRef());
    fieldRefs.add(marginLeftFieldRef());
    fieldRefs.add(marginRightFieldRef());
    fieldRefs.add(marginTopFieldRef());
    fieldRefs.add(FieldRef(_fkMessageItem, 'MessageItem', _messageItem));
    fieldRefs.add(FieldRef(
        fkNotificationsHandled, 'NotificationsHandled', _notificationsHandled));
    fieldRefs.add(paddingAllFieldRef());
    fieldRefs.add(paddingBottomFieldRef());
    fieldRefs.add(paddingLeftFieldRef());
    fieldRefs.add(paddingRightFieldRef());
    fieldRefs.add(paddingTopFieldRef());
    fieldRefs.add(rightFieldRef());
    fieldRefs.add(FieldRef(_fkShowCloseIcon, 'ShowCloseIcon', _showCloseIcon));
    fieldRefs.add(FieldRef(_fkShowing, 'Showing', _showing));
    fieldRefs.add(FieldRef(fkStatus, 'Status', _status));
    fieldRefs.add(tagFieldRef());
    fieldRefs.add(topFieldRef());
    fieldRefs.add(verticalAlignmentFieldRef());
    fieldRefs.add(widthFieldRef());
  }

  @override
  Primitive locateNextDescendant(PKeyLocator locator) {
    // The next index specifies which container field to access. The order
    // here must match the order the container fields (ActionItem,
    // MessageItem) appear in describeFields above.
    var nextIndex = locator.nextIndex();
    Primitive? item;
    switch (nextIndex) {
      case 0:
        item = actionItem;
      case 1:
        item = messageItem;
      default:
        throw Exception('PKey locator is out of bounds');
    }

    if (item == null) {
      throw Exception('PKey locator refers to non-existant item');
    }
    return item;
  }

  @override
  String toString() {
    return "";
  }

  @override
  bool isNotificationHandled(int notificationType) =>
      (_notificationsHandled.value & Notify.bit(notificationType)) != 0;

  /// The optional action item of the snackbar (typically a Button).
  Primitive? get actionItem => _actionItem.value;
  set actionItem(Primitive? item) => _actionItem.value = item;

  /// The message item of the snackbar (typically a Text).
  Primitive? get messageItem => _messageItem.value;
  set messageItem(Primitive? item) => _messageItem.value = item;

  /// How the snackbar behaves:  fixed to the bottom edge, or floating.
  SnackbarBehavior get behavior => _behavior.value;
  set behavior(SnackbarBehavior value) => _behavior.value = value;

  /// How long the snackbar stays visible, in seconds.  A value of 0 means
  /// use the app's default duration.
  double get durationSeconds => _durationSeconds.value;
  set durationSeconds(double value) => _durationSeconds.value = value;

  /// Whether the snackbar shows a close icon.
  bool get showCloseIcon => _showCloseIcon.value;
  set showCloseIcon(bool value) => _showCloseIcon.value = value;

  /// True if the snackbar is being shown, or should be shown, on the screen.
  /// The app clears this back to false once the message times out or the
  /// user dismisses it.
  bool get showing => _showing.value;
  set showing(bool showing) => _showing.value = showing;

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
