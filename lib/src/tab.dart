// Copyright 2024-2026 ProntoGUI, LLC
// ProntoGUI™ is a trademark of ProntoGUI, LLC
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'pkey.dart';
import 'primitive_base.dart';
import 'notification.dart';
import 'any_field.dart';
import 'boolean_field.dart';
import 'string_field.dart';
import 'integer_field.dart';
import 'primitive.dart';
import 'fkey.dart';

/// A Tab is one page of a Tabs primitive: a label, an optional icon, an
/// optional badge, a closeable flag, and a single content primitive shown
/// when the tab is selected. Mirrors golib's tab.go.
class Tab extends PrimitiveBase {
  Tab({
    super.tag,
    String label = '',
    Primitive? content,
    Primitive? icon,
    String badge = '',
    bool closeable = false,
    int status = 0,
  }) {
    _label = StringField.from(label);
    _content = AnyField.from(content);
    _icon = AnyField.from(icon);
    _badge = StringField.from(badge);
    _closeable = BooleanField.from(closeable);
    _status = IntegerField.from(status);
  }

  // Field storage
  late StringField _label;
  late AnyField _content;
  late AnyField _icon;
  late StringField _badge;
  late BooleanField _closeable;
  late IntegerField _status;
  final _notificationsHandled = IntegerField();

  @override
  String get describeType => 'Tab';

  // Field keys - fixed and append-only, matching golib's tab.go.
  static const _fkContent = 100;
  static const _fkIcon = 101;
  static const _fkLabel = 102;
  static const _fkBadge = 103;
  static const _fkCloseable = 104;

  @override
  void describeFields(List<FieldRef> fieldRefs) {
    fieldRefs.add(FieldRef(_fkBadge, 'Badge', _badge));
    fieldRefs.add(FieldRef(_fkCloseable, 'Closeable', _closeable));
    fieldRefs.add(FieldRef(_fkContent, 'Content', _content));
    fieldRefs.add(FieldRef(_fkIcon, 'Icon', _icon));
    fieldRefs.add(FieldRef(_fkLabel, 'Label', _label));
    fieldRefs.add(FieldRef(
        fkNotificationsHandled, 'NotificationsHandled', _notificationsHandled));
    fieldRefs.add(FieldRef(fkStatus, 'Status', _status));
    fieldRefs.add(tagFieldRef());
  }

  @override
  Primitive locateNextDescendant(PKeyLocator locator) {
    // Container fields alphabetical: Content (0), Icon (1).
    switch (locator.nextIndex()) {
      case 0:
        return content!;
      case 1:
        return icon!;
      default:
        throw Exception('PKey locator is out of bounds');
    }
  }

  @override
  String toString() => '';

  @override
  bool isNotificationHandled(int notificationType) =>
      (_notificationsHandled.value & Notify.bit(notificationType)) != 0;

  String get label => _label.value;
  set label(String value) => _label.value = value;

  Primitive? get content => _content.value;
  set content(Primitive? value) => _content.value = value;

  Primitive? get icon => _icon.value;
  set icon(Primitive? value) => _icon.value = value;

  /// The badge text ('' = no badge).
  String get badge => _badge.value;
  set badge(String value) => _badge.value = value;

  bool get closeable => _closeable.value;
  set closeable(bool value) => _closeable.value = value;

  /// 0 = Normal, 1 = Disabled (unselectable), 2 = Hidden, 3 = Collapsed
  /// (Hidden/Collapsed drop the tab from the bar).
  int get status => _status.value;
  set status(int value) => _status.value = value;

  bool get enabled => status == 0;
  set enabled(bool value) => status = value ? 0 : 1;
}
