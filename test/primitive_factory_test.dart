// Copyright 2024-2026 ProntoGUI, LLC
// ProntoGUI™ is a trademark of ProntoGUI, LLC
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:test/test.dart';
import 'package:prontogui/src/primitive_factory.dart';
import 'package:prontogui/src/pkey.dart';
import 'package:prontogui/src/pkind.dart';
import 'package:prontogui/src/button.dart';
import 'package:prontogui/src/check.dart';
import 'package:prontogui/src/choice.dart';
import 'package:prontogui/src/color_field.dart';
import 'package:prontogui/src/component.dart';
import 'package:prontogui/src/export_file.dart';
import 'package:prontogui/src/folder.dart';
import 'package:prontogui/src/folder_item.dart';
import 'package:prontogui/src/folder_list.dart';
import 'package:prontogui/src/dialog.dart';
import 'package:prontogui/src/frame.dart';
import 'package:prontogui/src/group.dart';
import 'package:prontogui/src/panel.dart';
import 'package:prontogui/src/view.dart';
import 'package:prontogui/src/import_file.dart';
import 'package:prontogui/src/list.dart';
import 'package:prontogui/src/snackbar.dart';
import 'package:prontogui/src/static_table.dart';
import 'package:prontogui/src/data_table.dart';
import 'package:prontogui/src/tabs.dart';
import 'package:prontogui/src/tab.dart';
import 'package:prontogui/src/text.dart';
import 'package:prontogui/src/textfield.dart';
import 'package:prontogui/src/timer.dart';
import 'package:prontogui/src/tristate.dart';
import 'test_cbor_samples.dart';

// Now that primitive type is read directly off the wire as a PKind tag (see
// pkind.dart) rather than inferred by scanning field names, these tests
// exercise createPrimitiveFromKind directly: does each PKind dispatch to the
// right constructor? The field maps themselves are just sample data — their
// content doesn't drive dispatch anymore, only the PKind does.
void main() {
  final pkey = PKey(1);

  test('Create a Button primitive.', () {
    var p = PrimitiveFactory.createPrimitiveFromKind(
        pkey, pkindButton, distinctCborForButton());
    expect(p, isA<Button>());
    expect(p.describeType, equals('Button'));
  });

  test('Create a Check primitive.', () {
    var p = PrimitiveFactory.createPrimitiveFromKind(
        pkey, pkindCheck, distinctCborForCheck());
    expect(p, isA<Check>());
    expect(p.describeType, equals('Check'));
  });

  test('Create a Choice primitive.', () {
    var p = PrimitiveFactory.createPrimitiveFromKind(
        pkey, pkindChoice, distinctCborForChoice());
    expect(p, isA<Choice>());
    expect(p.describeType, equals('Choice'));
  });

  test('Create an ExportFile primitive.', () {
    var p = PrimitiveFactory.createPrimitiveFromKind(
        pkey, pkindExportFile, distinctCborForExportFile());
    expect(p, isA<ExportFile>());
    expect(p.describeType, equals('ExportFile'));
  });

  test('Create a Folder primitive.', () {
    var p = PrimitiveFactory.createPrimitiveFromKind(
        pkey, pkindFolder, distinctCborForFolder());
    expect(p, isA<Folder>());
    expect(p.describeType, equals('Folder'));
  });

  test('Create a FolderItem primitive.', () {
    var p = PrimitiveFactory.createPrimitiveFromKind(
        pkey, pkindFolderItem, distinctCborForFolderItem());
    expect(p, isA<FolderItem>());
    expect(p.describeType, equals('FolderItem'));
  });

  test('Create a FolderList primitive.', () {
    var p = PrimitiveFactory.createPrimitiveFromKind(
        pkey, pkindFolderList, distinctCborForFolderList());
    expect(p, isA<FolderList>());
    expect(p.describeType, equals('FolderList'));
  });

  test('Create a ColorField primitive.', () {
    var p = PrimitiveFactory.createPrimitiveFromKind(
        pkey, pkindColorField, distinctCborForColorField());
    expect(p, isA<ColorField>());
    expect(p.describeType, equals('ColorField'));
  });

  test('Create a Component primitive.', () {
    var p = PrimitiveFactory.createPrimitiveFromKind(
        pkey, pkindComponent, distinctCborForComponent());
    expect(p, isA<Component>());
    expect(p.describeType, equals('Component'));
    expect((p as Component).content, isA<Text>());
  });

  test('Create a Frame primitive.', () {
    var p = PrimitiveFactory.createPrimitiveFromKind(
        pkey, pkindFrame, distinctCborForFrame());
    expect(p, isA<Frame>());
    expect(p.describeType, equals('Frame'));
  });

  test('Create a Group primitive.', () {
    var p = PrimitiveFactory.createPrimitiveFromKind(
        pkey, pkindGroup, distinctCborForGroup());
    expect(p, isA<Group>());
    expect(p.describeType, equals('Group'));
  });

  test('Create a Panel primitive.', () {
    var p = PrimitiveFactory.createPrimitiveFromKind(
        pkey, pkindPanel, distinctCborForPanel());
    expect(p, isA<Panel>());
    expect(p.describeType, equals('Panel'));
  });

  test('Create a View primitive.', () {
    var p = PrimitiveFactory.createPrimitiveFromKind(
        pkey, pkindView, distinctCborForView());
    expect(p, isA<View>());
    expect(p.describeType, equals('View'));
  });

  test('Create a Dialog primitive.', () {
    var p = PrimitiveFactory.createPrimitiveFromKind(
        pkey, pkindDialog, distinctCborForDialog());
    expect(p, isA<Dialog>());
    expect(p.describeType, equals('Dialog'));
  });

  test('Create an ImportFile primitive.', () {
    var p = PrimitiveFactory.createPrimitiveFromKind(
        pkey, pkindImportFile, distinctCborForImportFile());
    expect(p, isA<ImportFile>());
    expect(p.describeType, equals('ImportFile'));
  });

  test('Create a ListP primitive.', () {
    var p = PrimitiveFactory.createPrimitiveFromKind(
        pkey, pkindList, distinctCborForList());
    expect(p, isA<ListP>());
    expect(p.describeType, equals('List'));
  });

  test('Create a Snackbar primitive.', () {
    var p = PrimitiveFactory.createPrimitiveFromKind(
        pkey, pkindSnackbar, distinctCborForSnackbar());
    expect(p, isA<Snackbar>());
    expect(p.describeType, equals('Snackbar'));
  });

  test('Create a StaticTable primitive.', () {
    var p = PrimitiveFactory.createPrimitiveFromKind(
        pkey, pkindStaticTable, distinctCborForStaticTable());
    expect(p, isA<StaticTable>());
    expect(p.describeType, equals('StaticTable'));
  });

  test('Create a DataTable primitive.', () {
    var p = PrimitiveFactory.createPrimitiveFromKind(
        pkey, pkindDataTable, distinctCborForDataTable());
    expect(p, isA<DataTable>());
    expect(p.describeType, equals('DataTable'));
  });

  test('Create a Tabs primitive.', () {
    var p = PrimitiveFactory.createPrimitiveFromKind(
        pkey, pkindTabs, distinctCborForTabs());
    expect(p, isA<Tabs>());
    expect(p.describeType, equals('Tabs'));
  });

  test('Create a Tab primitive.', () {
    var p = PrimitiveFactory.createPrimitiveFromKind(
        pkey, pkindTab, distinctCborForTab());
    expect(p, isA<Tab>());
    expect(p.describeType, equals('Tab'));
  });

  test('Create a Text primitive.', () {
    var p = PrimitiveFactory.createPrimitiveFromKind(
        pkey, pkindText, distinctCborForText());
    expect(p, isA<Text>());
    expect(p.describeType, equals('Text'));
  });

  test('Create a TextField primitive.', () {
    var p = PrimitiveFactory.createPrimitiveFromKind(
        pkey, pkindTextField, distinctCborForTextField());
    expect(p, isA<TextField>());
    expect(p.describeType, equals('TextField'));
  });

  test('Create a Timer primitive.', () {
    var p = PrimitiveFactory.createPrimitiveFromKind(
        pkey, pkindTimer, distinctCborForTimer());
    expect(p, isA<Timer>());
    expect(p.describeType, equals('Timer'));
  });

  test('Create a Tristate primitive.', () {
    var p = PrimitiveFactory.createPrimitiveFromKind(
        pkey, pkindTristate, distinctCborForTristate());
    expect(p, isA<Tristate>());
    expect(p.describeType, equals('Tristate'));
  });

  test('Unrecognized PKind throws.', () {
    expect(
        () => PrimitiveFactory.createPrimitiveFromKind(
            pkey, 9999, distinctCborForCheck()),
        throwsException);
  });
}
