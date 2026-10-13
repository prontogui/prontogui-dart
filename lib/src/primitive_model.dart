// Copyright 2024-2026 ProntoGUI, LLC
// ProntoGUI™ is a trademark of ProntoGUI, LLC
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:cbor/cbor.dart';
import 'pkey.dart';
import 'fkey.dart';
import 'primitive.dart';
import 'primitive_factory.dart';
import 'primitive_model_watcher.dart';
import 'primitive_locator.dart';
import 'field_hooks.dart';
import 'protocol.dart';

class PrimitiveModel implements PrimitiveLocator, FieldHooks {
  List<Primitive> _topPrimitives = [];
  final List<PrimitiveModelWatcher> _watchers = [];

  /// The GUI generation this model reflects. As the App: set from each full
  /// update the server sends, and echoed back on every outbound partial update
  /// so the server can reject a batch built against a previous GUI. As the
  /// dartlib server: bumped by setGUI (see prontogui.dart).
  int _guiEpoch = 0;
  @override
  int get guiEpoch => _guiEpoch;
  set guiEpoch(int v) => _guiEpoch = v;

  /// The list of objects watching this model.
  List<PrimitiveModelWatcher> get watchers =>
      List<PrimitiveModelWatcher>.unmodifiable(_watchers);

  /// Returns true if the model is empty.
  bool get isEmpty {
    return _topPrimitives.isEmpty;
  }

  // List of top-level primitives comprising the GUI.
  List<Primitive> get topPrimitives {
    return _topPrimitives;
  }

  set topPrimitives(List<Primitive> primitives) {
    _unprepareForUpdates();
    _topPrimitives = primitives;
    _prepareForUpdates();
    onFullModelUpdate();
  }

  void addWatcher(PrimitiveModelWatcher watcher) {
    // Already in the list of watchers?
    for (var w in _watchers) {
      if (w == watcher) {
        return;
      }
    }
    _watchers.add(watcher);
  }

  void removeWatcher(PrimitiveModelWatcher watcher) {
    _watchers.remove(watcher);
  }

  void onFullModelUpdate() {
    for (var w in _watchers) {
      w.onFullModelUpdate();
    }
  }

  void onBeginPartialModelUpdate() {
    for (var w in _watchers) {
      w.onBeginPartialModelUpdate();
    }
  }

  void onPartialModelUpdate() {
    for (var w in _watchers) {
      w.onPartialModelUpdate();
    }
  }

  void onTopLevelPrimitiveUpdate() {
    for (var w in _watchers) {
      w.onTopLevelPrimitiveUpdate();
    }
  }

  void _prepareForUpdates() {
    var i = 0;
    for (var p in _topPrimitives) {
      p.prepareForUpdates(PKey(i), this, this);
      i++;
    }
  }

  void _unprepareForUpdates() {
    for (var p in _topPrimitives) {
      p.unprepareForUpdates();
    }
  }

  /// Walks [pkey] down the tree and returns the primitive it addresses, or null
  /// if it doesn't resolve against the current tree. A stale pkey (e.g. an
  /// update queued against a previous model) is an expected input, not a fault,
  /// so this degrades to null rather than throwing.
  @override
  Primitive? locatePrimitive(PKey pkey) {
    if (pkey.indices.isEmpty) {
      return null;
    }

    var locator = PKeyLocator(pkey);

    var nextIndex = locator.nextIndex();
    if (nextIndex < 0 || nextIndex >= topPrimitives.length) {
      return null;
    }

    Primitive? next = topPrimitives[nextIndex];

    try {
      while (next != null && !locator.located()) {
        next = next.locateNextDescendant(locator);
      }
    } catch (_) {
      // locateNextDescendant asserts on an out-of-range level - treat as
      // unresolvable.
      return null;
    }

    return next;
  }

  @override
  void onSetField(PKey pkey, FKey fkey, bool structural,
      [int containerIndex = -1]) {
    for (var w in _watchers) {
      w.onSetField(pkey, fkey, structural, containerIndex);
    }
  }

  @override
  void onIngestField(PKey pkey, FKey fkey, bool structural,
      [int containerIndex = -1]) {
    for (var w in _watchers) {
      w.onIngestField(pkey, fkey, structural, containerIndex);
    }
  }

  @override
  void onNotify(PKey pkey, int notificationType) {
    for (var w in _watchers) {
      if (w is NotificationWatcher) {
        (w as NotificationWatcher).onNotify(pkey, notificationType);
      }
    }
  }

  /// Ingests a full or partial update from a CBOR value and notifies listeners.
  List<Primitive>? ingestCborUpdate(CborValue v) {
    // Ignore if its an empty (nil) update
    if (v is CborNull) {
      return null;
    }

    assert(v is CborList);

    var l = v as CborList;

    var version = l.elementAt(0);
    if (version is! CborSmallInt || version.value != protocolVersion) {
      throw Exception(
          'unsupported protocol version ${version is CborSmallInt ? version.value : version}.  This library speaks version $protocolVersion');
    }

    var fullUpdate = l.elementAt(1) as CborBool;
    var epoch = (l.elementAt(2) as CborInt).toInt();
    var updateList = l.sublist(3);

    if (fullUpdate.value) {
      _guiEpoch = epoch;
      _ingestFullUpdate(updateList);
      return null;
    } else {
      if (epoch != _guiEpoch) {
        // A partial update built against a different GUI generation - stale.
        return const [];
      }
      return _ingestPartialUpdate(updateList);
    }
  }

  /// Ingests a partial update from a CBOR value and notifies listeners.
  /// If the update ends up being a full update then an exception is thrown.
  List<Primitive> ingestPartialUpdateOnly(CborValue v) {
    var p = ingestCborUpdate(v);
    if (p == null) {
      throw Exception(
          'A full update was received.  Only a partial update is allowed.');
    }
    return p;
  }

  CborMap egestCborUpdate(bool fullUpdate, List<FKey> fkeys) {
    return CborMap({});
  }

  /// Ingests a full update from a list of CBOR values and notifies listeners.
  ///
  /// This method is used internally by the class.
  void _ingestFullUpdate(List<CborValue> l) {
    final numPrimitives = l.length;
    final List<Primitive> newTopPrimitives = [];
    final pkey = PKey();

    for (var i = 0; i < numPrimitives; i++) {
      var wrapped = l.elementAt(i);

      if (wrapped is! CborList || wrapped.length != 2) {
        throw Exception('element is not a [kind, map] CborList');
      }

      var kind = wrapped.elementAt(0);
      var cbor = wrapped.elementAt(1);
      if (kind is! CborSmallInt || cbor is! CborMap) {
        throw Exception('element is not a [kind, map] CborList');
      }

      newTopPrimitives.add(PrimitiveFactory.createPrimitiveFromKind(
          PKey.fromPKey(pkey, i), kind.value, cbor));
    }
    topPrimitives = newTopPrimitives;

    onFullModelUpdate();
  }

  /// Ingests a partial update from a list of CBOR values.  Listeners are notified as each
  /// updated primitive dictates.
  ///
  /// This method is used internally by the class.
  List<Primitive> _ingestPartialUpdate(List<CborValue> l) {
    onBeginPartialModelUpdate();

    final numPrimitives = l.length;
    bool topLevelUpdated = false;
    var updatedPrimitives = <Primitive>[];

    for (var i = 0; i < numPrimitives; i += 2) {
      var pkey = PKey.fromCbor(l.elementAt(i));
      var cbor = l.elementAt(i + 1);
      if (cbor is! CborMap) {
        throw Exception('element is not a CborMap');
      }

      var p = locatePrimitive(pkey);
      if (p == null) {
        throw Exception('primitive cannot be located');
      }

      p.ingestPartialCborMap(cbor);

      if (!topLevelUpdated) {
        topLevelUpdated = (pkey.indices.length == 1);
      }

      updatedPrimitives.add(p);
    }

    if (topLevelUpdated) {
      onTopLevelPrimitiveUpdate();
    }

    onPartialModelUpdate();

    return updatedPrimitives;
  }
}
