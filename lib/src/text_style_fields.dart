// Copyright 2024-2026 ProntoGUI, LLC
// ProntoGUI™ is a trademark of ProntoGUI, LLC
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'color.dart';
import 'color_value_field.dart';
import 'double_field.dart';
import 'enum_field.dart';
import 'enums.dart';
import 'fkey.dart';
import 'primitive_base.dart';
import 'string_field.dart';

/// The text-styling fields shared by every primitive that displays styled
/// text - Check, Choice, Button, ExportFile, ImportFile, NumericField,
/// Text, TextField, and Tristate - replacing the pre-2.0
/// TextDefaultPropertyAccess embodiment property group with real typed wire
/// fields, same rationale as PrimitiveBase's common box-model/positioning/
/// appearance fields (Wave 1).
///
/// Like those, these fields use the SAME fixed key on every primitive that
/// mixes this in (see fkFontColor etc. in fkey.dart) - they are not
/// recomputed per primitive. Mirrors golib's TextStyleFields, which is a
/// struct a primitive embeds; Dart has no struct embedding, so this is a
/// mixin instead - `class Check extends PrimitiveBase with
/// TextStyleFieldsMixin`. Each field is nullable at the public API boundary
/// for the same reason as PrimitiveBase's common fields: null means unset/
/// default (the wire field is genuinely omitted from full updates).
mixin TextStyleFieldsMixin on PrimitiveBase {
  final _fontColor = ColorValueField();
  final _fontFamily = StringField();
  final _fontSize = DoubleField();
  final _fontStyle = EnumField<FontStyle>(FontStyle.values);
  final _fontWeight = EnumField<FontWeight>(FontWeight.values);
  final _horizontalTextAlignment =
      EnumField<HorizontalTextAlignment>(HorizontalTextAlignment.values);
  final _verticalTextAlignment =
      EnumField<VerticalTextAlignment>(VerticalTextAlignment.values);

  // Helpers for describeFields implementations - see PrimitiveBase's own
  // xxxFieldRef helpers for why these take no fkey parameter.
  FieldRef fontColorFieldRef() =>
      FieldRef(fkFontColor, 'FontColor', _fontColor);
  FieldRef fontFamilyFieldRef() =>
      FieldRef(fkFontFamily, 'FontFamily', _fontFamily);
  FieldRef fontSizeFieldRef() => FieldRef(fkFontSize, 'FontSize', _fontSize);
  FieldRef fontStyleFieldRef() =>
      FieldRef(fkFontStyle, 'FontStyle', _fontStyle);
  FieldRef fontWeightFieldRef() =>
      FieldRef(fkFontWeight, 'FontWeight', _fontWeight);
  FieldRef horizontalTextAlignmentFieldRef() => FieldRef(
      fkHorizontalTextAlignment,
      'HorizontalTextAlignment',
      _horizontalTextAlignment);
  FieldRef verticalTextAlignmentFieldRef() => FieldRef(
      fkVerticalTextAlignment, 'VerticalTextAlignment', _verticalTextAlignment);

  Color? get fontColor => _fontColor.isDefault ? null : _fontColor.value;
  set fontColor(Color? value) => _fontColor.value = value ?? Colors.transparent;

  String? get fontFamily => _fontFamily.isDefault ? null : _fontFamily.value;
  set fontFamily(String? value) => _fontFamily.value = value ?? '';

  double? get fontSize => _fontSize.isDefault ? null : _fontSize.value;
  set fontSize(double? value) => _fontSize.value = value ?? 0.0;

  FontStyle? get fontStyle => _fontStyle.isDefault ? null : _fontStyle.value;
  set fontStyle(FontStyle? value) =>
      _fontStyle.value = value ?? FontStyle.normal;

  FontWeight? get fontWeight =>
      _fontWeight.isDefault ? null : _fontWeight.value;
  set fontWeight(FontWeight? value) =>
      _fontWeight.value = value ?? FontWeight.normal;

  HorizontalTextAlignment? get horizontalTextAlignment =>
      _horizontalTextAlignment.isDefault
          ? null
          : _horizontalTextAlignment.value;
  set horizontalTextAlignment(HorizontalTextAlignment? value) =>
      _horizontalTextAlignment.value = value ?? HorizontalTextAlignment.left;

  VerticalTextAlignment? get verticalTextAlignment =>
      _verticalTextAlignment.isDefault ? null : _verticalTextAlignment.value;
  set verticalTextAlignment(VerticalTextAlignment? value) =>
      _verticalTextAlignment.value = value ?? VerticalTextAlignment.top;
}
