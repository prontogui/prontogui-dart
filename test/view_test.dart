// Copyright 2024-2026 ProntoGUI, LLC
// ProntoGUI™ is a trademark of ProntoGUI, LLC
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:test/test.dart';
import 'package:prontogui/src/view.dart';
import 'package:prontogui/src/dialog.dart';
import 'package:prontogui/src/text.dart';
import 'package:prontogui/src/notification.dart';
import 'package:prontogui/src/pkey.dart';

void main() {
  group('View', () {
    test('defaults', () {
      final v = View();
      expect(v.items, isEmpty);
      expect(v.showing, isFalse);
      expect(v.describeType, 'View');
      expect(v.isNotificationHandled(Notify.change), isFalse);
    });

    test('showing round-trips', () {
      final v = View();
      v.showing = true;
      expect(v.showing, isTrue);
    });

    test('locate next descendant (Icon=0, Items=1)', () {
      final t = Text();
      final v = View(items: [t]);
      expect(v.locateNextDescendant(PKeyLocator(PKey(1, 0))), t);
    });
  });

  group('Dialog', () {
    test('defaults', () {
      final d = Dialog();
      expect(d.items, isEmpty);
      expect(d.showing, isFalse);
      expect(d.describeType, 'Dialog');
    });

    test('showing round-trips', () {
      final d = Dialog();
      d.showing = true;
      expect(d.showing, isTrue);
    });
  });
}
