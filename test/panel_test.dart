// Copyright 2024-2026 ProntoGUI, LLC
// ProntoGUI™ is a trademark of ProntoGUI, LLC
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:test/test.dart';
import 'package:prontogui/src/panel.dart';
import 'package:prontogui/src/icon.dart';
import 'package:prontogui/src/text.dart';
import 'package:prontogui/src/enums.dart';
import 'package:prontogui/src/pkey.dart';

void main() {
  group('Panel', () {
    test('should initialize with default values', () {
      final panel = Panel();
      expect(panel.items, isEmpty);
      expect(panel.title, '');
      expect(panel.icon, isNull);
      expect(panel.flowDirection, isNull);
      expect(panel.layoutMethod, isNull);
      expect(panel.describeType, 'Panel');
    });

    test('should initialize with provided values', () {
      final t = Text();
      final panel = Panel(
        items: [t],
        title: 'T',
        flowDirection: FlowDirection.leftToRight,
        layoutMethod: LayoutMethod.positioned,
      );
      expect(panel.items, contains(t));
      expect(panel.title, 'T');
      // topToBottom is the enum default and reads back as null; leftToRight is
      // distinguishable.
      expect(panel.flowDirection, FlowDirection.leftToRight);
      expect(panel.layoutMethod, LayoutMethod.positioned);
    });

    test('should locate next descendant (Icon=0, Items=1)', () {
      final icon = Icon();
      final t1 = Text();
      final t2 = Text();
      final panel = Panel(icon: icon, items: [t1, t2]);

      // Container field 0 is Icon.
      expect(panel.locateNextDescendant(PKeyLocator(PKey(0))), icon);

      // Container field 1 is Items; second index selects the item.
      expect(panel.locateNextDescendant(PKeyLocator(PKey(1, 1))), t2);
    });
  });
}
