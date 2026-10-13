// Copyright 2024-2026 ProntoGUI, LLC
// ProntoGUI™ is a trademark of ProntoGUI, LLC
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:prontogui/prontogui.dart';
import 'package:prontogui/src/pkey.dart';
import 'package:test/test.dart';

void main() {
  group('FolderList', () {
    test('defaults + describeType', () {
      var fl = FolderList();
      expect(fl.items, isEmpty);
      expect(fl.modelFolder, isNull);
      expect(fl.modelItem, isNull);
      expect(fl.selectedItems, isEmpty);
      expect(fl.selectionMode, 0);
      expect(fl.status, 0);
      expect(fl.describeType, 'FolderList');
      expect(fl.isNotificationHandled(Notify.selectionChange), isFalse);
    });

    test('fields round-trip', () {
      var mf = Text(content: 'folder');
      var mi = Text(content: 'item');
      var fl = FolderList(
        items: [Folder(), FolderItem()],
        modelFolder: mf,
        modelItem: mi,
        selectedItems: [0],
        selectionMode: 1,
      );
      expect(fl.items.length, 2);
      expect(fl.modelFolder, mf);
      expect(fl.modelItem, mi);
      expect(fl.selectedItems, [0]);
      expect(fl.selectionMode, 1);

      fl.selectedItems = [1];
      expect(fl.selectedItems, [1]);
    });

    test('locateNextDescendant: Items (0), ModelFolder (1), ModelItem (2)', () {
      var f = Folder();
      var mf = Text(content: 'folder');
      var mi = Text(content: 'item');
      var fl = FolderList(items: [f], modelFolder: mf, modelItem: mi);
      expect(fl.locateNextDescendant(PKeyLocator(PKey(0, 0))), f);
      expect(fl.locateNextDescendant(PKeyLocator(PKey(1))), mf);
      expect(fl.locateNextDescendant(PKeyLocator(PKey(2))), mi);
    });

    test('locateNextDescendant throws when out of bounds', () {
      var fl = FolderList();
      expect(
          () => fl.locateNextDescendant(PKeyLocator(PKey(3))), throwsException);
    });
  });
}
