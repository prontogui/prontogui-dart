// Copyright 2024-2026 ProntoGUI, LLC
// ProntoGUI™ is a trademark of ProntoGUI, LLC
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:cbor/cbor.dart';
import 'pkey.dart';
import 'primitive.dart';
import 'primitive_base.dart';
import 'pkind.dart';

import 'button.dart';
import 'card.dart';
import 'check.dart';
import 'choice.dart';
import 'color_field.dart';
import 'column_settings.dart';
import 'component.dart';
import 'export_file.dart';
import 'folder.dart';
import 'folder_item.dart';
import 'folder_list.dart';
import 'dialog.dart';
import 'frame.dart';
import 'group.dart';
import 'panel.dart';
import 'icon.dart';
import 'image.dart';
import 'import_file.dart';
import 'list.dart';
import 'nothing.dart';
import 'numericfield.dart';
import 'snackbar.dart';
import 'static_table.dart';
import 'tab.dart';
import 'tabs.dart';
import 'data_table.dart';
import 'text.dart';
import 'textfield.dart';
import 'timer.dart';
import 'tristate.dart';
import 'view.dart';

typedef FactoryFunction = PrimitiveBase Function();

/// Kind -> constructor, replacing the pre-2.0 scheme of scanning a CBOR map's
/// field names for one that happened to be "distinctive" to a given
/// primitive type. That scheme depended on every primitive coincidentally
/// having a field that was always present at any value; this one just reads
/// the type off the wire directly (see pkind.dart).
final Map<PKind, FactoryFunction> _factoryFunctions = {
  pkindButton: () => Button(),
  pkindCard: () => Card(),
  pkindCheck: () => Check(),
  pkindChoice: () => Choice(),
  pkindColorField: () => ColorField(),
  pkindColumnSettings: () => ColumnSettings(),
  pkindComponent: () => Component(),
  pkindExportFile: () => ExportFile(),
  pkindFolder: () => Folder(),
  pkindFolderItem: () => FolderItem(),
  pkindFolderList: () => FolderList(),
  pkindFrame: () => Frame(),
  pkindGroup: () => Group(),
  pkindIcon: () => Icon(),
  pkindImage: () => Image(),
  pkindImportFile: () => ImportFile(),
  pkindList: () => ListP(),
  pkindNothing: () => Nothing(),
  pkindNumericField: () => NumericField(),
  pkindSnackbar: () => Snackbar(),
  pkindPanel: () => Panel(),
  pkindView: () => View(),
  pkindDialog: () => Dialog(),
  pkindStaticTable: () => StaticTable(),
  pkindDataTable: () => DataTable(),
  pkindTabs: () => Tabs(),
  pkindTab: () => Tab(),
  pkindText: () => Text(),
  pkindTextField: () => TextField(),
  pkindTimer: () => Timer(),
  pkindTristate: () => Tristate(),
};

/// The static object factory responsible for creating primitive-type objects.
abstract class PrimitiveFactory {
  /// Creates the appropriate primitive from the wire-format [kind] tag and
  /// the CBOR field map [cbor] carried alongside it.
  static Primitive createPrimitiveFromKind(
      PKey pkey, PKind kind, CborMap cbor) {
    if (kind == pkindNothing) {
      return Nothing();
    }

    var found = _factoryFunctions[kind];
    if (found == null) {
      throw Exception('primitive kind not recognized [$kind].');
    }

    var p = found.call();
    p.initializeFromCborMap(pkey, cbor);
    return p;
  }
}
