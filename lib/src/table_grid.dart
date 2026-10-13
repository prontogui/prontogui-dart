// Copyright 2024-2026 ProntoGUI, LLC
// ProntoGUI™ is a trademark of ProntoGUI, LLC
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'pkey.dart';
import 'primitive.dart';
import 'text.dart';
import 'column_settings.dart';

/// The grid data model shared by StaticTable and DataTable: a header row, an
/// optional per-column model (template) row, the 2-D array of cell
/// primitives, and per-column settings.
abstract interface class TableGrid {
  List<ColumnSettings> get columnSettingsList;
  set columnSettingsList(List<ColumnSettings> value);

  List<Primitive> get headerRow;
  set headerRow(List<Primitive> value);

  List<Primitive> get modelRow;
  set modelRow(List<Primitive> value);

  List<List<Primitive>> get rows;
  set rows(List<List<Primitive>> value);
}

/// Resolves a pkey into one of a table grid's child primitives. Container
/// fields are visited in alphabetical order: ColumnSettingsList (0),
/// HeaderRow (1), ModelRow (2), Rows (3).
Primitive locateTableGridDescendant(TableGrid g, PKeyLocator locator) {
  switch (locator.nextIndex()) {
    case 0:
      return g.columnSettingsList[locator.nextIndex()];
    case 1:
      return g.headerRow[locator.nextIndex()];
    case 2:
      return g.modelRow[locator.nextIndex()];
    case 3:
      var rowIndex = locator.nextIndex();
      var colIndex = locator.nextIndex();
      return g.rows[rowIndex][colIndex];
    default:
      throw Exception('PKey locator is out of bounds');
  }
}

/// Builds a HeaderRow of Text primitives from heading strings. Used by
/// StaticTable.makeHeadings / DataTable.makeHeadings (which return their
/// concrete type for chaining).
List<Primitive> buildHeadingPrimitives(List<String> headings) =>
    List<Primitive>.generate(
        headings.length, (col) => Text(content: headings[col]),
        growable: false);

/// Read-only convenience for any table grid.
extension TableGridExtras on TableGrid {
  /// The header row as a list of strings (via each primitive's string form).
  List<String> get headings => List<String>.generate(headerRow.length, (i) {
        var p = headerRow[i];
        return p is Text ? p.toString() : '';
      });

  set headings(List<String> value) => headerRow = buildHeadingPrimitives(value);
}
