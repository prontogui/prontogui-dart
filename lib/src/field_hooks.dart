// Copyright 2024-2026 ProntoGUI, LLC
// ProntoGUI™ is a trademark of ProntoGUI, LLC
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'pkey.dart';
import 'fkey.dart';

/// Hooks to provide all fields for them to notify when they are updated,
/// get timestamps for event fields, etc.
/// For a structural set (a container field's children replaced),
/// [containerIndex] is that container's index, so a receiver can supersede
/// pending updates under that container only; -1 otherwise.
abstract class FieldHooks {
  void onSetField(PKey pkey, FKey fkey, bool structural,
      [int containerIndex = -1]);
  void onIngestField(PKey pkey, FKey fkey, bool structural,
      [int containerIndex = -1]);

  /// Called when a primitive emits a notification (see PrimitiveBase.notify).
  void onNotify(PKey pkey, int notificationType);
}

/// A null implementation of [FieldHooks] that does nothing.  Primarily used
/// for testing purposes.
class NullFieldHooks implements FieldHooks {
  @override
  void onSetField(PKey pkey, FKey fkey, bool structural,
      [int containerIndex = -1]) {
    // Do nothing.
  }

  @override
  void onIngestField(PKey pkey, FKey fkey, bool structural,
      [int containerIndex = -1]) {
    // Do nothing.
  }

  @override
  void onNotify(PKey pkey, int notificationType) {
    // Do nothing.
  }
}
