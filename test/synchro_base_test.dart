// Copyright 2024-2026 ProntoGUI, LLC
// ProntoGUI™ is a trademark of ProntoGUI, LLC
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:test/test.dart';
import 'package:prontogui/src/pkey.dart';
import 'package:prontogui/src/synchro_base.dart';

void main() {
  group('SynchroBase', () {
    List<PKey> sent(SynchroBase s) => [
          for (final u in s.pendingUpdates)
            if (!u.coalesced) u.pkey
        ];

    bool has(List<PKey> pkeys, PKey pkey) => pkeys.any(pkey.isEqualTo);

    test('a structural set supersedes only its own container', () {
      final s = SynchroBase(null, false, true);
      s.onSetField(PKey(0, 1), 100, false); // child in container 1 (replaced)
      s.onSetField(PKey(0, 1, 3), 100, false); // its descendant
      s.onSetField(PKey(0, 0, 0), 100, false); // child in container 0
      s.onSetField(PKey(0, 2, 0, 0), 100, false); // child in container 2

      s.onSetField(PKey(0), 101, true, 1); // replace container 1

      final pkeys = sent(s);
      expect(has(pkeys, PKey(0, 1)), isFalse);
      expect(has(pkeys, PKey(0, 1, 3)), isFalse);
      expect(has(pkeys, PKey(0, 0, 0)), isTrue);
      expect(has(pkeys, PKey(0, 2, 0, 0)), isTrue);
      expect(has(pkeys, PKey(0)), isTrue);
    });

    test('a structural set without a container index supersedes all', () {
      final s = SynchroBase(null, false, true);
      s.onSetField(PKey(0, 0, 0), 100, false);
      s.onSetField(PKey(0, 2, 0, 0), 100, false);
      s.onSetField(PKey(0), 101, true);
      expect(sent(s).length, equals(1));
    });
  });
}
