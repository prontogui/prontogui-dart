// Copyright 2024-2026 ProntoGUI, LLC
// ProntoGUI™ is a trademark of ProntoGUI, LLC
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:prontogui/prontogui.dart';
import 'package:test/test.dart';

void main() {
  group('Notify', () {
    test('codes match golib NotificationType', () {
      expect(Notify.press, 0);
      expect(Notify.release, 1);
      expect(Notify.change, 2);
      expect(Notify.complete, 3);
      expect(Notify.selectionChange, 4);
      expect(Notify.tick, 5);
      expect(Notify.close, 6);
      expect(Notify.submit, 7);
    });

    test('submit is momentary, change coalesces', () {
      expect(Notify.isMomentary(Notify.submit), isTrue);
      expect(Notify.isMomentary(Notify.change), isFalse);
      expect(Notify.bit(Notify.submit), 128);
    });
  });
}
