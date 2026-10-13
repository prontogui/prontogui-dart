// Copyright 2024-2026 ProntoGUI, LLC
// ProntoGUI™ is a trademark of ProntoGUI, LLC
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'pkey.dart';
import 'fkey.dart';

// Interface for objects that watch the model.
abstract class PrimitiveModelWatcher {
  void onFullModelUpdate();
  void onBeginPartialModelUpdate();
  void onPartialModelUpdate();
  void onTopLevelPrimitiveUpdate();
  void onSetField(PKey pkey, FKey fkey, bool structural,
      [int containerIndex = -1]);
  void onIngestField(PKey pkey, FKey fkey, bool structural,
      [int containerIndex = -1]);
}

/// Optional add-on interface for watchers that also want to be told when a
/// primitive emits a notification (a user interaction). Kept separate from
/// [PrimitiveModelWatcher] so existing watchers don't have to implement it.
abstract class NotificationWatcher {
  void onNotify(PKey pkey, int notificationType);
}
