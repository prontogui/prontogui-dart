// Copyright 2024-2026 ProntoGUI, LLC
// ProntoGUI™ is a trademark of ProntoGUI, LLC
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'pkey.dart';
import 'fkey.dart';
import 'primitive_model_watcher.dart';

/// Represents a pending update to a primitive.
class PrimitiveUpdate {
  PrimitiveUpdate(this.pkey, this.fields) : coalesced = false;

  /// PKey of the primitive being updated.
  final PKey pkey;

  /// Subset of fields being updated.
  late List<FKey> fields;

  /// True if this update will be coalesced with a parent update.
  late bool coalesced;

  /// Appends a field to the list of fields being updated.
  void appendField(FKey fkey) {
    for (var field in fields) {
      if (field == fkey) {
        return;
      }
    }
    fields.add(fkey);
  }
}

/// Base support for all Synchro objects.
class SynchroBase implements PrimitiveModelWatcher {
  SynchroBase(this.fieldFilter, this.trackOnIngest, this.trackOnSet);

  // List of updates to be applied.
  final List<PrimitiveUpdate> pendingUpdates = [];

  // Notifications queued to send in the next partial update, alongside
  // pendingUpdates. Deduplicated per (pkey, type) so repeated coalescing
  // notifications (Change, Tick) collapse to one (see NOTIFICATIONS.md §4).
  final List<({PKey pkey, int type})> pendingNotifications = [];

  /// Queues a notification to be sent with the next partial update.
  void queueNotification(PKey pkey, int type) {
    for (final n in pendingNotifications) {
      if (n.type == type && n.pkey.isEqualTo(pkey)) {
        return;
      }
    }
    pendingNotifications.add((pkey: pkey, type: type));
  }

  /// Set of fields to filter updates by.  If this is null, all fields are tracked
  /// for updates.  If this is non-null, only fields in this list are tracked.
  final Set<FKey>? fieldFilter;

  /// True if this synchro should track updates made by ingestion.
  final bool trackOnIngest;

  /// True if this synchro should track updates made by field setters.
  final bool trackOnSet;

  @override
  void onFullModelUpdate() {
    clearPendingUpdates();
  }

  @override
  void onBeginPartialModelUpdate() {}

  @override
  void onPartialModelUpdate() {}

  @override
  void onTopLevelPrimitiveUpdate() {}

  @override
  void onSetField(PKey pkey, FKey fkey, bool structural,
      [int containerIndex = -1]) {
    if (trackOnSet) {
      _handleOnField(pkey, fkey, structural, containerIndex);
    }
  }

  @override
  void onIngestField(PKey pkey, FKey fkey, bool structural,
      [int containerIndex = -1]) {
    if (trackOnIngest) {
      _handleOnField(pkey, fkey, structural, containerIndex);
    }
  }

  void _handleOnField(
      PKey pkey, FKey fkey, bool structural, int containerIndex) {
    // Filtering by field?
    if (fieldFilter != null && !fieldFilter!.contains(fkey)) {
      return;
    }

    var existingUpdate = _findUpdate(pkey);
    if (existingUpdate != null) {
      existingUpdate.appendField(fkey);
    } else {
      var newUpdate = PrimitiveUpdate(pkey, [fkey]);
      pendingUpdates.add(newUpdate);
    }

    // A structural set re-sends a container field's whole contents, which
    // supersedes pending updates under THAT container only - pending updates
    // under the primitive's other containers must still be sent.
    if (structural) {
      if (containerIndex >= 0) {
        _ignoreUpdatesUnder(PKey.fromPKey(pkey, containerIndex));
      } else {
        _ignoreDescendantUpdates(pkey);
      }
    }
  }

  /// Clears all pending updates and notifications.
  void clearPendingUpdates() {
    pendingUpdates.clear();
    pendingNotifications.clear();
  }

  /// Finds an update in the list of pending updates.
  PrimitiveUpdate? _findUpdate(PKey pkey) {
    for (var update in pendingUpdates) {
      if (update.pkey.isEqualTo(pkey)) {
        return update;
      }
    }
    return null;
  }

  /// Marks updates at or below [prefix] as coalesced (an AnyField's child
  /// sits exactly at its container's prefix).
  void _ignoreUpdatesUnder(PKey prefix) {
    for (var update in pendingUpdates) {
      if (update.pkey.isEqualTo(prefix) || update.pkey.descendsFrom(prefix)) {
        update.coalesced = true;
      }
    }
  }

  /// Marks all updates descending from a given PKey as coalesced.
  void _ignoreDescendantUpdates(PKey pkey) {
    for (var update in pendingUpdates) {
      if (update.pkey.descendsFrom(pkey)) {
        update.coalesced = true;
      }
    }
  }
}
