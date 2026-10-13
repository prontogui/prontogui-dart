// Copyright 2024-2026 ProntoGUI, LLC
// ProntoGUI™ is a trademark of ProntoGUI, LLC
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:prontogui/src/integer1d_field.dart';
import "pkey.dart";
import 'primitive_base.dart';
import 'notification.dart';
import 'any1d_field.dart';
import 'any2d_field.dart';
import 'integer_field.dart';
import 'primitive.dart';
import 'boolean_field.dart';
import 'table_grid.dart';
import 'column_settings.dart';
import 'fkey.dart';

/// A DataTable is StaticTable's grid data model plus interaction: pagination
/// (rowsPerPage / showFirstLastButtons), click-to-sort columns (driven by
/// ColumnSettings sortType / dateTimeFormat), and row selection
/// (selectionMode / selectedRows / OnSelectionChange). Sorting and paging are
/// client-side; only a selection change round-trips to the server. This was
/// Table's "paged" embodiment.
class DataTable extends PrimitiveBase implements TableGrid {
  DataTable({
    super.tag,
    super.backgroundColor,
    super.borderAll,
    super.borderBottom,
    super.borderColor,
    super.borderLeft,
    super.borderRight,
    super.borderTop,
    super.bottom,
    super.height,
    super.horizontalAlignment,
    super.left,
    super.marginAll,
    super.marginBottom,
    super.marginLeft,
    super.marginRight,
    super.marginTop,
    super.paddingAll,
    super.paddingBottom,
    super.paddingLeft,
    super.paddingRight,
    super.paddingTop,
    super.right,
    super.top,
    super.verticalAlignment,
    super.width,
    List<ColumnSettings> columnSettingsList = const [],
    List<Primitive> headerRow = const [],
    List<Primitive> modelRow = const [],
    List<List<Primitive>> rows = const [],
    int? rowsPerPage,
    int status = 0,
    List<int> selectedRows = const [],
    int selectionMode = 0,
    bool showFirstLastButtons = false,
  }) {
    _columnSettingsList = Any1DField.from(columnSettingsList);
    _headerRow = Any1DField.from(headerRow);
    _modelRow = Any1DField.from(modelRow);
    _rows = Any2DField.from(rows);
    _status = IntegerField.from(status);
    _selectedRows = Integer1DField.from(selectedRows);
    _selectionMode = IntegerField.from(selectionMode);
    this.rowsPerPage = rowsPerPage;
    this.showFirstLastButtons = showFirstLastButtons;
  }

  // Field storage
  late Any1DField _columnSettingsList;
  late Any1DField _headerRow;
  late Any1DField _modelRow;
  late Any2DField _rows;
  final _rowsPerPage = IntegerField();
  late Integer1DField _selectedRows;
  late IntegerField _selectionMode;
  final _showFirstLastButtons = BooleanField();
  late IntegerField _status;
  final _notificationsHandled = IntegerField();

  @override
  String get describeType => 'DataTable';

  // Field keys - fixed and append-only, matching golib's datatable.go.
  static const _fkColumnSettingsList = 100;
  static const _fkHeaderRow = 101;
  static const _fkModelRow = 102;
  static const _fkRows = 103;
  static const _fkSelectedRows = 104;
  static const _fkSelectionMode = 105;
  static const _fkRowsPerPage = 106;
  static const _fkShowFirstLastButtons = 107;

  @override
  void describeFields(List<FieldRef> fieldRefs) {
    fieldRefs.add(backgroundColorFieldRef());
    fieldRefs.add(borderAllFieldRef());
    fieldRefs.add(borderBottomFieldRef());
    fieldRefs.add(borderColorFieldRef());
    fieldRefs.add(borderLeftFieldRef());
    fieldRefs.add(borderRightFieldRef());
    fieldRefs.add(borderTopFieldRef());
    fieldRefs.add(bottomFieldRef());
    fieldRefs.add(FieldRef(
        _fkColumnSettingsList, 'ColumnSettingsList', _columnSettingsList));
    fieldRefs.add(FieldRef(_fkHeaderRow, 'HeaderRow', _headerRow));
    fieldRefs.add(heightFieldRef());
    fieldRefs.add(horizontalAlignmentFieldRef());
    fieldRefs.add(leftFieldRef());
    fieldRefs.add(marginAllFieldRef());
    fieldRefs.add(marginBottomFieldRef());
    fieldRefs.add(marginLeftFieldRef());
    fieldRefs.add(marginRightFieldRef());
    fieldRefs.add(marginTopFieldRef());
    fieldRefs.add(FieldRef(_fkModelRow, 'ModelRow', _modelRow));
    fieldRefs.add(FieldRef(
        fkNotificationsHandled, 'NotificationsHandled', _notificationsHandled));
    fieldRefs.add(paddingAllFieldRef());
    fieldRefs.add(paddingBottomFieldRef());
    fieldRefs.add(paddingLeftFieldRef());
    fieldRefs.add(paddingRightFieldRef());
    fieldRefs.add(paddingTopFieldRef());
    fieldRefs.add(rightFieldRef());
    fieldRefs.add(FieldRef(_fkRows, 'Rows', _rows));
    fieldRefs.add(FieldRef(_fkRowsPerPage, 'RowsPerPage', _rowsPerPage));
    fieldRefs.add(FieldRef(_fkSelectedRows, 'SelectedRows', _selectedRows));
    fieldRefs.add(FieldRef(_fkSelectionMode, 'SelectionMode', _selectionMode));
    fieldRefs.add(FieldRef(_fkShowFirstLastButtons, 'ShowFirstLastButtons',
        _showFirstLastButtons));
    fieldRefs.add(FieldRef(fkStatus, 'Status', _status));
    fieldRefs.add(tagFieldRef());
    fieldRefs.add(topFieldRef());
    fieldRefs.add(verticalAlignmentFieldRef());
    fieldRefs.add(widthFieldRef());
  }

  @override
  Primitive locateNextDescendant(PKeyLocator locator) =>
      locateTableGridDescendant(this, locator);

  @override
  String toString() => "";

  @override
  bool isNotificationHandled(int notificationType) =>
      (_notificationsHandled.value & Notify.bit(notificationType)) != 0;

  @override
  List<ColumnSettings> get columnSettingsList =>
      _columnSettingsList.value.cast<ColumnSettings>();
  @override
  set columnSettingsList(List<ColumnSettings> value) =>
      _columnSettingsList.value = value;

  @override
  List<Primitive> get headerRow => _headerRow.value;
  @override
  set headerRow(List<Primitive> headerRow) => _headerRow.value = headerRow;

  @override
  List<Primitive> get modelRow => _modelRow.value;
  @override
  set modelRow(List<Primitive> modelRow) => _modelRow.value = modelRow;

  @override
  List<List<Primitive>> get rows => _rows.value;
  @override
  set rows(List<List<Primitive>> rows) => _rows.value = rows;

  /// Rows-per-page count, or null if unset (show all rows on one page).
  int? get rowsPerPage => _rowsPerPage.isDefault ? null : _rowsPerPage.value;
  set rowsPerPage(int? value) => _rowsPerPage.value = value ?? 0;

  /// Whether the pager shows first/last page buttons.
  bool get showFirstLastButtons => _showFirstLastButtons.value;
  set showFirstLastButtons(bool value) => _showFirstLastButtons.value = value;

  /// The selected rows, as natural indices (positions in [rows] as sent -
  /// unaffected by the current visual sort order).
  List<int> get selectedRows => _selectedRows.value;
  set selectedRows(List<int> selectedRows) =>
      _selectedRows.value = selectedRows;

  /// The selection mode: 0 = None, 1 = Single, 2 = Multiple.
  int get selectionMode => _selectionMode.value;
  set selectionMode(int selectionMode) => _selectionMode.value = selectionMode;

  int get status => _status.value;
  set status(int status) {
    _status.value = status;
  }

  bool get enabled => status == 0;
  set enabled(bool enabled) {
    status = enabled ? 0 : 1;
  }

  bool get visible => status == 0 || status == 1;
  set visible(bool visible) {
    status = visible ? 0 : 2;
  }

  bool get hidden => status == 2;
  set hidden(bool hidden) {
    status = hidden ? 2 : 0;
  }

  bool get collapsed => status == 3;
  set collapsed(bool collapsed) {
    status = collapsed ? 3 : 0;
  }

  // CONVENIENCE METHODS

  /// Builds headerRow from a list of heading strings. Returns this for chaining.
  DataTable makeHeadings(List<String> headings) {
    headerRow = buildHeadingPrimitives(headings);
    return this;
  }

  DataTable insertRow(int index, List<Primitive> row) {
    _rows.insertRow(index, row);
    return this;
  }

  DataTable deleteRow(int index) {
    _rows.deleteRow(index);
    return this;
  }

  DataTable deleteAllRows() {
    _rows.value = [];
    return this;
  }

  int rowCount() => _rows.value.length;
}
