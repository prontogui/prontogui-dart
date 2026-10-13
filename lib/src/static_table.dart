// Copyright 2024-2026 ProntoGUI, LLC
// ProntoGUI™ is a trademark of ProntoGUI, LLC
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import "pkey.dart";
import 'primitive_base.dart';
import 'any1d_field.dart';
import 'any2d_field.dart';
import 'integer_field.dart';
import 'primitive.dart';
import 'table_grid.dart';
import 'color.dart';
import 'color_value_field.dart';
import 'column_settings.dart';
import 'opt_field.dart';
import 'fkey.dart';

/// A StaticTable displays a 2-D array of primitives in a read-only grid, with
/// optional inside-border (grid) lines. For pagination, click-to-sort
/// columns, or row selection, use DataTable. This was the default embodiment
/// of the old Table primitive.
class StaticTable extends PrimitiveBase implements TableGrid {
  StaticTable({
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
    double? insideBorderAll,
    double? insideBorderBottom,
    Color? insideBorderColor,
    double? insideBorderHorizontals,
    double? insideBorderLeft,
    double? insideBorderRight,
    double? insideBorderTop,
    double? insideBorderVerticals,
    List<Primitive> modelRow = const [],
    List<List<Primitive>> rows = const [],
    int status = 0,
  }) {
    _columnSettingsList = Any1DField.from(columnSettingsList);
    _headerRow = Any1DField.from(headerRow);
    _modelRow = Any1DField.from(modelRow);
    _rows = Any2DField.from(rows);
    _status = IntegerField.from(status);
    this.insideBorderAll = insideBorderAll;
    this.insideBorderBottom = insideBorderBottom;
    this.insideBorderColor = insideBorderColor;
    this.insideBorderHorizontals = insideBorderHorizontals;
    this.insideBorderLeft = insideBorderLeft;
    this.insideBorderRight = insideBorderRight;
    this.insideBorderTop = insideBorderTop;
    this.insideBorderVerticals = insideBorderVerticals;
  }

  // Field storage
  late Any1DField _columnSettingsList;
  late Any1DField _headerRow;
  final _insideBorderAll = DoubleOptField();
  final _insideBorderBottom = DoubleOptField();
  final _insideBorderColor = ColorValueField();
  final _insideBorderHorizontals = DoubleOptField();
  final _insideBorderLeft = DoubleOptField();
  final _insideBorderRight = DoubleOptField();
  final _insideBorderTop = DoubleOptField();
  final _insideBorderVerticals = DoubleOptField();
  late Any1DField _modelRow;
  late Any2DField _rows;
  late IntegerField _status;

  @override
  String get describeType => 'StaticTable';

  // Field keys - fixed and append-only, matching golib's statictable.go.
  static const _fkColumnSettingsList = 100;
  static const _fkHeaderRow = 101;
  static const _fkModelRow = 102;
  static const _fkRows = 103;
  static const _fkInsideBorderAll = 104;
  static const _fkInsideBorderBottom = 105;
  static const _fkInsideBorderColor = 106;
  static const _fkInsideBorderHorizontals = 107;
  static const _fkInsideBorderLeft = 108;
  static const _fkInsideBorderRight = 109;
  static const _fkInsideBorderTop = 110;
  static const _fkInsideBorderVerticals = 111;

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
    fieldRefs
        .add(FieldRef(_fkInsideBorderAll, 'InsideBorderAll', _insideBorderAll));
    fieldRefs.add(FieldRef(
        _fkInsideBorderBottom, 'InsideBorderBottom', _insideBorderBottom));
    fieldRefs.add(FieldRef(
        _fkInsideBorderColor, 'InsideBorderColor', _insideBorderColor));
    fieldRefs.add(FieldRef(_fkInsideBorderHorizontals,
        'InsideBorderHorizontals', _insideBorderHorizontals));
    fieldRefs.add(
        FieldRef(_fkInsideBorderLeft, 'InsideBorderLeft', _insideBorderLeft));
    fieldRefs.add(FieldRef(
        _fkInsideBorderRight, 'InsideBorderRight', _insideBorderRight));
    fieldRefs
        .add(FieldRef(_fkInsideBorderTop, 'InsideBorderTop', _insideBorderTop));
    fieldRefs.add(FieldRef(_fkInsideBorderVerticals, 'InsideBorderVerticals',
        _insideBorderVerticals));
    fieldRefs.add(leftFieldRef());
    fieldRefs.add(marginAllFieldRef());
    fieldRefs.add(marginBottomFieldRef());
    fieldRefs.add(marginLeftFieldRef());
    fieldRefs.add(marginRightFieldRef());
    fieldRefs.add(marginTopFieldRef());
    fieldRefs.add(FieldRef(_fkModelRow, 'ModelRow', _modelRow));
    fieldRefs.add(paddingAllFieldRef());
    fieldRefs.add(paddingBottomFieldRef());
    fieldRefs.add(paddingLeftFieldRef());
    fieldRefs.add(paddingRightFieldRef());
    fieldRefs.add(paddingTopFieldRef());
    fieldRefs.add(rightFieldRef());
    fieldRefs.add(FieldRef(_fkRows, 'Rows', _rows));
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

  /// The per-column settings (width, sort type, date/time format). Entries
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

  double? get insideBorderAll => _insideBorderAll.value;
  set insideBorderAll(double? value) => _insideBorderAll.value = value;

  double? get insideBorderBottom => _insideBorderBottom.value;
  set insideBorderBottom(double? value) => _insideBorderBottom.value = value;

  Color? get insideBorderColor =>
      _insideBorderColor.isDefault ? null : _insideBorderColor.value;
  set insideBorderColor(Color? value) =>
      _insideBorderColor.value = value ?? Colors.transparent;

  double? get insideBorderHorizontals => _insideBorderHorizontals.value;
  set insideBorderHorizontals(double? value) =>
      _insideBorderHorizontals.value = value;

  double? get insideBorderLeft => _insideBorderLeft.value;
  set insideBorderLeft(double? value) => _insideBorderLeft.value = value;

  double? get insideBorderRight => _insideBorderRight.value;
  set insideBorderRight(double? value) => _insideBorderRight.value = value;

  double? get insideBorderTop => _insideBorderTop.value;
  set insideBorderTop(double? value) => _insideBorderTop.value = value;

  double? get insideBorderVerticals => _insideBorderVerticals.value;
  set insideBorderVerticals(double? value) =>
      _insideBorderVerticals.value = value;

  bool get isInsideBorder =>
      !_insideBorderAll.isDefault ||
      !_insideBorderBottom.isDefault ||
      !_insideBorderHorizontals.isDefault ||
      !_insideBorderLeft.isDefault ||
      !_insideBorderRight.isDefault ||
      !_insideBorderTop.isDefault ||
      !_insideBorderVerticals.isDefault;

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
  StaticTable makeHeadings(List<String> headings) {
    headerRow = buildHeadingPrimitives(headings);
    return this;
  }

  StaticTable insertRow(int index, List<Primitive> row) {
    _rows.insertRow(index, row);
    return this;
  }

  StaticTable deleteRow(int index) {
    _rows.deleteRow(index);
    return this;
  }

  StaticTable deleteAllRows() {
    _rows.value = [];
    return this;
  }

  int rowCount() => _rows.value.length;
}
