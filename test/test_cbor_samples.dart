// Copyright 2024-2026 ProntoGUI, LLC
// ProntoGUI™ is a trademark of ProntoGUI, LLC
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
//
// Field keys here mirror each primitive's fixed field-key assignment (see
// lib/src/fkey.dart and e.g. lib/src/button.dart): common fields (the box
// model; Status is NOT common - it's per-primitive, etc.) always use the
// same fixed number from fkey.dart; each primitive's own fields use that
// primitive's own fixed literal, starting at 100. cborForXXX/
// distinctCborForXXX return bare field maps (no PKind wrapper) for use as
// the `fields` half of a [kind, fields] pair, or as an argument straight to
// initializeFromCborMap.

import 'package:cbor/cbor.dart';
import 'package:prontogui/src/pkind.dart';

// A nested primitive is always egested/ingested as [kind, fields] on the 2.0
// wire format (see pkind.dart) — these fixtures embed sample field maps as
// direct children of AnyField/Any1DField/Any2DField, so they need the same
// wrapping a real primitive's egest would produce.
CborList _wrapButton(CborMap fields) {
  return CborList([CborSmallInt(pkindButton), fields]);
}

CborList _wrapNothing() {
  return CborList([CborSmallInt(pkindNothing), CborMap({})]);
}

CborMap cborEmpty() {
  return CborMap({});
}

// Button: Label=101, Status=103 (own fields; see button.dart)
CborMap cborForButton(String label, int status) {
  return CborMap({
    CborSmallInt(101): CborString(label), // Label
    CborSmallInt(0): CborSmallInt(status), // Status
  });
}

// Text: Content=100 (own field; see text.dart)
CborMap partialCborForText(String content) {
  return CborMap({
    CborSmallInt(100): CborString(content), // Content
  });
}

// Button: Status=103, Style=106 (own fields; see button.dart). Style 1 =
// outlined (see ButtonStyle in enums.dart).
CborMap cborForButtonAsOutlined() {
  return CborMap({
    CborSmallInt(0): const CborSmallInt(0), // Status
    CborSmallInt(103): const CborSmallInt(1), // Style = outlined
  });
}

// Check: Checked=100, Label=101 (own fields; see check.dart)
CborMap cborForCheck(String label) {
  return CborMap({
    CborSmallInt(101): const CborBool(true), // Checked
    CborSmallInt(102): CborString(label), // Label
  });
}

// Choice: Choice=100, Choices=102 (own fields; see choice.dart)
CborMap cborForChoice() {
  return CborMap({
    CborSmallInt(100): CborString('A'), // Choice
    CborSmallInt(102): CborList([CborString('A'), CborString('B')]), // Choices
  });
}

// Frame: Items=100 (own field; see frame.dart)
CborMap cborForFrame() {
  var btn1 = _wrapButton(cborForButton('Press Me!', 0));
  var btn2 = _wrapButton(cborForButton('Click Here! (disable)', 1));

  return CborMap({
    CborSmallInt(100): CborList([btn1, btn2]), // Items
  });
}

// Group: Items=100 (own field; see group.dart)
CborMap cborForGroup() {
  var btn1 = _wrapButton(cborForButton('Press Me!', 0));
  var btn2 = _wrapButton(cborForButton('Click Here! (disable)', 1));

  return CborMap({
    CborSmallInt(100): CborList([btn1, btn2]), // Items
  });
}

CborList cborForAny1DField() {
  var btn1 = _wrapButton(cborForButton('Press Me!', 0));
  var btn2 = _wrapButton(cborForButton('Click Here! (disable)', 1));

  return CborList([btn1, btn2]);
}

// List: ListItems=100 (own field; see list.dart)
CborMap cborForList() {
  return CborMap({
    CborSmallInt(100): cborForAny1DField(), // ListItems
  });
}

CborList cborForAny2DField() {
  var btnR0C0 = _wrapButton(cborForButton('Press Me!', 0));
  var btnR0C1 = _wrapButton(cborForButton('Click Here! (disable)', 1));
  var btnR1C0 = _wrapButton(cborForButton('STOP', 2));
  var btnR1C1 = _wrapButton(cborForButton('START', 2));

  var row0 = CborList([btnR0C0, btnR0C1]);
  var row1 = CborList([btnR1C0, btnR1C1]);

  return CborList([row0, row1]);
}

// StaticTable: Rows=102 (own field; see static_table.dart)
CborMap cborForStaticTable() {
  return CborMap({
    CborSmallInt(103): cborForAny2DField(), // Rows
  });
}

// Button: Label=101 (own field)
CborMap distinctCborForButton() {
  return CborMap({
    CborSmallInt(101): CborString('a button'), // Label
  });
}

// Group: Items=100 (own field)
CborMap distinctCborForGroup() {
  return CborMap({
    CborSmallInt(100): CborList([]), // Items
  });
}

// Frame: Items=100 (own field)
CborMap distinctCborForFrame() {
  return CborMap({
    CborSmallInt(100): CborList([]), // Items
  });
}

// Panel / View / Dialog: Items=100 (own field)
CborMap distinctCborForPanel() {
  return CborMap({
    CborSmallInt(101): CborList([]), // Items
  });
}

CborMap distinctCborForView() {
  return CborMap({
    CborSmallInt(101): CborList([]), // Items
  });
}

CborMap distinctCborForDialog() {
  return CborMap({
    CborSmallInt(101): CborList([]), // Items
  });
}

// Text: Content=100 (own field)
CborMap distinctCborForText() {
  return CborMap({
    CborSmallInt(100):
        CborString('Excepteur sint occaecat cupidatat'), // Content
  });
}

// Choice: Choice=100 (own field)
CborMap distinctCborForChoice() {
  return CborMap({
    CborSmallInt(100): CborString(''), // Choice
  });
}

// Check: Checked=100 (own field)
CborMap distinctCborForCheck() {
  return CborMap({
    CborSmallInt(101): const CborBool(false), // Checked
  });
}

// Tristate: State=102 (own field)
CborMap distinctCborForTristate() {
  return CborMap({
    CborSmallInt(102): const CborSmallInt(0), // State
  });
}

// List: ListItems=100 (own field)
CborMap distinctCborForList() {
  return CborMap({
    CborSmallInt(100): CborList([]), // ListItems
  });
}

// TextField: TextEntry=101 (own field)
CborMap distinctCborForTextField() {
  return CborMap({
    CborSmallInt(100): CborString(''), // TextEntry
  });
}

// ExportFile: Completed=101 (own field)
CborMap distinctCborForExportFile() {
  return CborMap({
    CborSmallInt(101): const CborBool(true), // Completed
  });
}

// ImportFile: Completed=101 (own field)
CborMap distinctCborForImportFile() {
  return CborMap({
    CborSmallInt(101): const CborBool(true), // Completed
  });
}

// StaticTable / DataTable: Rows=102 (own field)
CborMap distinctCborForStaticTable() {
  return CborMap({
    CborSmallInt(103): CborList([]), // Rows
  });
}

CborMap distinctCborForDataTable() {
  return CborMap({
    CborSmallInt(103): CborList([]), // Rows
  });
}

// Component: Content=100 (own field), a nested [kind, fields] primitive
CborMap distinctCborForComponent() {
  return CborMap({
    CborSmallInt(100):
        CborList([CborSmallInt(pkindText), distinctCborForText()]), // Content
  });
}

// Tabs: Items=100 (own field)
CborMap distinctCborForTabs() {
  return CborMap({
    CborSmallInt(100): CborList([]), // Items
  });
}

// Tab: Label=100 (own field)
CborMap distinctCborForTab() {
  return CborMap({
    CborSmallInt(102): CborString('a tab'), // Label
  });
}

// FolderList: Items=100 (own field; see folder_list.dart)
CborMap distinctCborForFolderList() {
  return CborMap({
    CborSmallInt(100): CborList([]), // Items
  });
}

// ColorField: ColorEntry=100 (own field; see color_field.dart)
CborMap distinctCborForColorField() {
  return CborMap({
    CborSmallInt(100): CborString('#FF3366CC'), // ColorEntry
  });
}

// Snackbar: Showing=105 (own field; see snackbar.dart)
CborMap distinctCborForSnackbar() {
  return CborMap({
    CborSmallInt(105): const CborBool(false), // Showing
  });
}

// Timer: PeriodMs=100 (own field)
CborMap distinctCborForTimer() {
  return CborMap({
    CborSmallInt(100): const CborSmallInt(200), // PeriodMs
  });
}

// Folder: Open=100 (own field)
CborMap distinctCborForFolder() {
  return CborMap({
    CborSmallInt(101): const CborBool(false), // Open
  });
}

// FolderItem: Item=100 (own field). Item holds a Nothing placeholder here,
// so it needs the same [kind, fields] wrapping any nested primitive's egest
// would produce.
CborMap distinctCborForFolderItem() {
  return CborMap({
    CborSmallInt(100): _wrapNothing(), // Item
  });
}
