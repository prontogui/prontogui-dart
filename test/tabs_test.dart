// Copyright 2024-2026 ProntoGUI, LLC
// ProntoGUI™ is a trademark of ProntoGUI, LLC
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:prontogui/prontogui.dart';
import 'package:prontogui/src/pkey.dart';
import 'package:test/test.dart';

void main() {
  group('Tab', () {
    test('defaults + describeType', () {
      var t = Tab();
      expect(t.label, '');
      expect(t.content, isNull);
      expect(t.icon, isNull);
      expect(t.badge, '');
      expect(t.closeable, isFalse);
      expect(t.describeType, 'Tab');
      expect(t.isNotificationHandled(Notify.close), isFalse);
    });

    test('fields round-trip', () {
      var c = Text(content: 'body');
      var t = Tab(label: 'Inbox', content: c, badge: '3', closeable: true);
      expect(t.label, 'Inbox');
      expect(t.content, c);
      expect(t.badge, '3');
      expect(t.closeable, isTrue);
    });

    test('locateNextDescendant: Content (0), Icon (1)', () {
      var c = Text(content: 'body');
      var ic = Icon(iconID: 'star');
      var t = Tab(content: c, icon: ic);
      expect(t.locateNextDescendant(PKeyLocator(PKey(0))), c);
      expect(t.locateNextDescendant(PKeyLocator(PKey(1))), ic);
    });
  });

  group('Tabs', () {
    test('defaults', () {
      var t = Tabs();
      expect(t.items, isEmpty);
      expect(t.selectedTab, 0);
      expect(t.tabOrientation, isNull);
      expect(t.scrollable, isFalse);
      expect(t.eagerContent, isFalse);
      expect(t.describeType, 'Tabs');
    });

    test('fields round-trip', () {
      var t = Tabs(
        items: [Tab(label: 'A'), Tab(label: 'B')],
        selectedTab: 1,
        tabOrientation: TabOrientation.left,
        tabLabelOrientation: TabLabelOrientation.rotatedCW,
        scrollable: true,
        eagerContent: true,
        animationPeriodMs: 200,
      );
      expect(t.items.length, 2);
      expect(t.selectedTab, 1);
      expect(t.tabOrientation, TabOrientation.left);
      expect(t.tabLabelOrientation, TabLabelOrientation.rotatedCW);
      expect(t.scrollable, isTrue);
      expect(t.eagerContent, isTrue);
      expect(t.animationPeriodMs, 200);

      t.selectedTab = 0;
      expect(t.selectedTab, 0);
    });

    test('locateNextDescendant reaches a tab', () {
      var tabB = Tab(label: 'B');
      var t = Tabs(items: [Tab(label: 'A'), tabB]);
      expect(t.locateNextDescendant(PKeyLocator(PKey(0, 1))), tabB);
    });
  });
}
