// Copyright 2024-2026 ProntoGUI, LLC
// ProntoGUI™ is a trademark of ProntoGUI, LLC
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:prontogui/prontogui.dart';
import 'package:prontogui/src/pkey.dart';
import 'package:test/test.dart';

void main() {
  group('DataTable', () {
    test('defaults + describeType', () {
      var t = DataTable();
      expect(t.rows, isEmpty);
      expect(t.rowsPerPage, isNull);
      expect(t.selectionMode, 0);
      expect(t.showFirstLastButtons, isFalse);
      expect(t.describeType, 'DataTable');
      expect(t.isNotificationHandled(Notify.selectionChange), isFalse);
    });

    test('interaction fields round-trip', () {
      var t = DataTable(
        rows: [
          [Text()],
          [Text()]
        ],
        rowsPerPage: 10,
        selectionMode: 2,
        showFirstLastButtons: true,
        selectedRows: [1],
      );
      expect(t.rowsPerPage, 10);
      expect(t.selectionMode, 2);
      expect(t.showFirstLastButtons, isTrue);
      expect(t.selectedRows, [1]);

      t.selectedRows = [0, 1];
      expect(t.selectedRows, [0, 1]);
    });

    test('makeHeadings chains and headings reads back', () {
      var t = DataTable().makeHeadings(['A', 'B']);
      expect(t.headerRow.length, 2);
      expect(t.headings, ['A', 'B']);
    });

    test('locateNextDescendant reaches a cell', () {
      var b = Text(content: 'r1c1');
      var t = DataTable(rows: [
        [Text(), Text()],
        [Text(), b]
      ]);
      // field 3 = Rows, then row 1, col 1
      var d = t.locateNextDescendant(PKeyLocator(PKey(3, 1, 1)));
      expect(d, b);
    });
  });
}
