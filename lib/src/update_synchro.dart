// Copyright 2024-2026 ProntoGUI, LLC
// ProntoGUI™ is a trademark of ProntoGUI, LLC
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:cbor/cbor.dart';
import 'synchro_base.dart';
import 'pkey.dart';

import 'primitive.dart';
import 'primitive_locator.dart';
import 'protocol.dart';

/// Tracks update to a primitive model and produces full or partial updates
/// which are ready for sending over a communication link.
class UpdateSynchro extends SynchroBase {
  UpdateSynchro(
      this.locator, super.fieldFilter, super.trackOnIngest, super.trackOnSet);

  /// The object used to locate a primitive in the model.
  PrimitiveLocator locator;

  /// Get a partial update based on pending updates tracked so far.
  /// The pending updates are cleared.
  CborList getPartialUpdate() {
    var updateList = List<CborValue>.empty(growable: true);

    // Protocol says:  first item is the protocol version, second is false,
    // indicating a partial update. Partial-update entries target an
    // already-existing primitive by pkey, so (unlike full updates) they
    // carry no PKind tag — the receiver already knows what type lives there.
    updateList.add(const CborSmallInt(protocolVersion));
    updateList.add(const CborBool(false));
    // The GUI epoch this batch was built against - the server rejects the
    // whole batch if it no longer matches (see PrimitiveModel.guiEpoch).
    updateList.add(CborSmallInt(locator.guiEpoch));

    // For every pending update...
    for (var update in pendingUpdates) {
      if (update.coalesced) {
        continue;
      }

      var p = locator.locatePrimitive(update.pkey);
      if (p == null) {
        // The primitive was removed from the tree between the change being
        // recorded and this flush - drop the stale entry.
        continue;
      }

      updateList.add(update.pkey.toCbor());
      updateList.add(p.egestPartialCborMap(update.fields));
    }

    // ...then every queued notification, as [pkey, typeCode] pairs. An integer
    // payload marks a notification; a map payload marks a field update (see
    // NOTIFICATIONS.md §6).
    for (var n in pendingNotifications) {
      updateList.add(n.pkey.toCbor());
      updateList.add(CborSmallInt(n.type));
    }

    clearPendingUpdates();

    return CborList(updateList);
  }

  /// Gets a full update consisting of all top-level primitives.
  CborList getFullUpdate() {
    var updateList = List<CborValue>.empty(growable: true);

    // Protocol says:  first item is the protocol version, second is true,
    // indicating a full update.
    updateList.add(const CborSmallInt(protocolVersion));
    updateList.add(const CborBool(true));
    updateList.add(CborSmallInt(locator.guiEpoch));

    var i = 0;

    // Scan list of top-level primitives (where PKey = [i])
    Primitive? next;
    while (true) {
      next = locator.locatePrimitive(PKey(i++));
      if (next == null) {
        break;
      }
      updateList
          .add(CborList([CborSmallInt(next.kind), next.egestFullCborMap()]));
    }

    clearPendingUpdates();

    return CborList(updateList);
  }
}
