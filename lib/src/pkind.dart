// Copyright 2024-2026 ProntoGUI, LLC
// ProntoGUI™ is a trademark of ProntoGUI, LLC
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

/// PKind identifies the concrete type of a primitive on the wire, replacing
/// the pre-2.0 scheme of inferring type by scanning field names ("duck
/// typing"). Every full-snapshot egest of a primitive (top-level full
/// updates, and nested primitives, which are always fully re-egested) is
/// tagged with its PKind.
///
/// PKind values must stay numerically identical to golib's key/pkind.go —
/// they are the shared vocabulary of the wire protocol. Each value below is
/// a fixed, permanent, explicitly assigned number. The current values
/// happen to fall in alphabetical order because that's how the initial
/// catalog was declared; that's a historical artifact, not a rule to
/// maintain. APPEND NEW KINDS AT THE END using the next unused number,
/// regardless of where the name would alphabetize. Never renumber or reuse
/// an existing value.
typedef PKind = int;

const int pkindInvalid = 0;
const int pkindCard = 1;
const int pkindCheck = 2;
const int pkindChoice = 3;
const int pkindComponent = 4;
const int pkindButton = 5;
const int pkindExportFile = 6;
const int pkindFolder = 7;
const int pkindFolderItem = 8;
const int pkindFrame = 9;
const int pkindGroup = 10;
const int pkindIcon = 11;
const int pkindImage = 12;
const int pkindImportFile = 13;
const int pkindList = 14;
const int pkindNothing = 15;
const int pkindNumericField = 16;
const int pkindStaticTable = 17; // was pkindTable

const int pkindText = 18;
const int pkindTextField = 19;
const int pkindTimer = 20;
const int pkindTristate = 21;

// ColumnSettings is a non-visual primitive: a per-column settings record
// (width, sort type, date/time format) for Table, held in a Table's
// columnSettingsList field the same way headerRow/modelRow/rows hold their
// child primitives. It's a primitive rather than a bespoke field type so it
// can reuse the existing nested-primitive egest/ingest machinery instead of
// inventing a new "array of records" wire shape - see table.dart's
// field-key block.
const int pkindColumnSettings = 22;

// Snackbar is a brief, transient message shown at the edge of the screen
// with an optional action. It was split out of Frame's "snackbar"
// embodiment into its own primitive - see snackbar.dart.
const int pkindSnackbar = 23;

// Panel, View, and Dialog were split out of Frame, which used to be all of
// them at once selected by an embodiment string. Frame (8) and Group (9) keep
// their numbers and are now the two simple fixed-direction containers (Frame
// vertical, Group horizontal). Panel adds FlowDirection, LayoutMethod, Title,
// Icon; View and Dialog add Showing + OnChange and are shown by the App as a
// full-screen route / a modal dialog. See panel.dart, view.dart, dialog.dart.
const int pkindPanel = 24;
const int pkindView = 25;
const int pkindDialog = 26;
const int pkindDataTable = 27;
const int pkindTabs = 28;
const int pkindTab = 29;
const int pkindFolderList = 30;
const int pkindColorField = 31;

/// Maps a primitive's [describeType] name (e.g. 'Card') to its PKind. Used by
/// PrimitiveBase to derive `kind` without requiring every primitive file to
/// declare it individually — describeType already exists per-primitive.
final Map<String, PKind> _typeNameToPKind = {
  'Button': pkindButton,
  'Card': pkindCard,
  'Check': pkindCheck,
  'Choice': pkindChoice,
  'Component': pkindComponent,
  'ExportFile': pkindExportFile,
  'Folder': pkindFolder,
  'FolderItem': pkindFolderItem,
  'Frame': pkindFrame,
  'Group': pkindGroup,
  'Icon': pkindIcon,
  'Image': pkindImage,
  'ImportFile': pkindImportFile,
  'List': pkindList,
  'Nothing': pkindNothing,
  'NumericField': pkindNumericField,
  'StaticTable': pkindStaticTable,
  'DataTable': pkindDataTable,
  'Tabs': pkindTabs,
  'Tab': pkindTab,
  'FolderList': pkindFolderList,
  'ColorField': pkindColorField,
  'Text': pkindText,
  'TextField': pkindTextField,
  'Timer': pkindTimer,
  'Tristate': pkindTristate,
  'ColumnSettings': pkindColumnSettings,
  'Snackbar': pkindSnackbar,
  'Panel': pkindPanel,
  'View': pkindView,
  'Dialog': pkindDialog,
};

/// Reverse of [_typeNameToPKind], used by PrimitiveFactory to dispatch
/// directly on kind instead of scanning field names.
final Map<PKind, String> _pkindToTypeName = {
  for (final entry in _typeNameToPKind.entries) entry.value: entry.key,
};

PKind pkindForTypeName(String typeName) {
  return _typeNameToPKind[typeName] ?? pkindInvalid;
}

String? typeNameForPKind(PKind kind) {
  return _pkindToTypeName[kind];
}
