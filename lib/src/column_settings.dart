// Copyright 2024-2026 ProntoGUI, LLC
// ProntoGUI™ is a trademark of ProntoGUI, LLC
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'primitive_base.dart';
import 'string_field.dart';
import 'enum_field.dart';
import 'double_field.dart';
import 'enums.dart';

/// A non-visual primitive: a per-column settings record for Table, held in
/// a Table's columnSettingsList field the same way headerRow/modelRow/rows
/// hold their child primitives (see table.dart). It's deliberately minimal
/// - no common box-model/positioning/appearance fields, no text styling, no
/// tag/embodiment/status - because it's data, not something rendered on its
/// own. Mirrors golib's columnsettings.go.
class ColumnSettings extends PrimitiveBase {
  ColumnSettings({double? width, SortType? sortType, String? dateTimeFormat}) {
    _width.value = width ?? 0.0;
    _sortType.value = sortType ?? SortType.none;
    _dateTimeFormat.value = dateTimeFormat ?? '';
  }

  // Field storage. Initialized here, not in the constructor body:
  // PrimitiveBase's constructor assigns `width`, which this class overrides
  // to use _width, so _width must exist before that constructor runs.
  final _width = DoubleField();
  final _sortType = EnumField<SortType>.from(SortType.values, SortType.none);
  final _dateTimeFormat = StringField();

  @override
  String get describeType => 'ColumnSettings';

  // Field keys for columnSettings' own fields (see firstOwnFKey in
  // fkey.dart). Fixed and append-only, matching golib field-for-field -
  // see fkey.dart's doc comment.
  static const _fkDateTimeFormat = 100;
  static const _fkSortType = 101;
  static const _fkWidth = 102;

  @override
  void describeFields(List<FieldRef> fieldRefs) {
    fieldRefs
        .add(FieldRef(_fkDateTimeFormat, 'DateTimeFormat', _dateTimeFormat));
    fieldRefs.add(FieldRef(_fkSortType, 'SortType', _sortType));
    fieldRefs.add(FieldRef(_fkWidth, 'Width', _width));
  }

  @override
  String toString() {
    return '';
  }

  /// The width of the column, or null if unset. Shadows PrimitiveBase's
  /// common-layout `width` (which this primitive doesn't use - it has no
  /// CommonLayoutFields role of its own) with its own field/FKey; see
  /// _fkWidth above.
  @override
  double? get width => _width.isDefault ? null : _width.value;
  @override
  set width(double? value) => _width.value = value ?? 0.0;

  /// How the column sorts, or null if unset.
  SortType? get sortType => _sortType.isDefault ? null : _sortType.value;
  set sortType(SortType? value) => _sortType.value = value ?? SortType.none;

  /// The date/time format string used when sortType is SortType.dateTime,
  /// or null if unset.
  String? get dateTimeFormat =>
      _dateTimeFormat.isDefault ? null : _dateTimeFormat.value;
  set dateTimeFormat(String? value) => _dateTimeFormat.value = value ?? '';
}
