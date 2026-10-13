// Copyright 2024-2026 ProntoGUI, LLC
// ProntoGUI™ is a trademark of ProntoGUI, LLC
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:prontogui/prontogui.dart';
import 'package:test/test.dart';

void main() {
  group('StaticTable', () {
    test('initial values are set correctly', () {
      var table = StaticTable(
        rows: [
          [Text(), Text()],
          [Text(), Text()]
        ],
        status: 1,
      );
      table.makeHeadings(['Column1', 'Column2']);

      expect(table.headerRow.length, 2);
      var h1 = table.headerRow[0] as Text;
      var h2 = table.headerRow[1] as Text;
      expect(h1.content, 'Column1');
      expect(h2.content, 'Column2');
      expect(table.rows.length, 2);
      expect(table.status, 1);
    });

    test('insertRow inserts a row at the correct index', () {
      var table = StaticTable(
        rows: [
          [Text(), Text()],
          [Text(), Text()]
        ],
      );

      var newRow = [Text(), Text()];
      table.insertRow(1, newRow);

      expect(table.rows.length, 3);
      expect(table.rows[1], newRow);
    });

    test('deleteRow deletes a row at the correct index', () {
      var table = StaticTable(
        rows: [
          [Text(), Text()],
          [Text(), Text()]
        ],
      );

      table.deleteRow(0);

      expect(table.rows.length, 1);
    });

    test('deleteAllRows deletes all rows', () {
      var table = StaticTable(
        rows: [
          [Text(), Text()],
          [Text(), Text()]
        ],
      );

      table.deleteAllRows();

      expect(table.rows.length, 0);
    });

    test('rowCount returns the correct number of rows', () {
      var table = StaticTable(
        rows: [
          [Text(), Text()],
          [Text(), Text()]
        ],
      );

      expect(table.rowCount(), 2);
    });

    test('status can be updated', () {
      var table = StaticTable(
        rows: [
          [Text(), Text()],
          [Text(), Text()]
        ],
        status: 0,
      );

      table.status = 2;

      expect(table.status, 2);
    });
  });
}
