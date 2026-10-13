// Copyright 2024-2026 ProntoGUI, LLC
// ProntoGUI™ is a trademark of ProntoGUI, LLC
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

/// Notification type codes sent App → server when the user interacts with a
/// primitive. Values are fixed and append-only and must stay numerically
/// identical to golib's NotificationType. See NOTIFICATIONS.md.
class Notify {
  Notify._();

  static const int press = 0;
  static const int release = 1;
  static const int change = 2;
  static const int complete = 3;
  static const int selectionChange = 4;
  static const int tick = 5;
  static const int close = 6;

  /// The user pressed Enter in a TextField or NumericField (always, even if
  /// unchanged). Focus leaving does not submit. The value is already current -
  /// it travels with each [change].
  static const int submit = 7;

  /// The bit this type occupies in a primitive's NotificationsHandled bitmask.
  static int bit(int type) => 1 << type;

  /// Momentary notifications flush the outbound batch immediately; the rest
  /// coalesce and flush on the next frame (see NOTIFICATIONS.md §4).
  static bool isMomentary(int type) =>
      type == press ||
      type == release ||
      type == complete ||
      type == close ||
      type == submit;
}
