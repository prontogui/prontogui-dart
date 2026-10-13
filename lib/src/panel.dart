// Copyright 2024-2026 ProntoGUI, LLC
// ProntoGUI™ is a trademark of ProntoGUI, LLC
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:prontogui/src/any_field.dart';
import 'package:prontogui/src/string_field.dart';

import 'pkey.dart';
import 'primitive_base.dart';
import 'any1d_field.dart';
import 'integer_field.dart';
import 'primitive.dart';
import 'enum_field.dart';
import 'enums.dart';
import 'opt_field.dart';
import 'fkey.dart';

/// A Panel is a container with explicit control over how its children are
/// laid out: a flow direction (left-to-right or top-to-bottom) or explicit
/// left/top/right/bottom positioning, plus an optional title and icon. Frame
/// and Group are the simpler fixed-direction containers; View and Dialog are
/// Panels shown by the App as a screen or a modal dialog.
class Panel extends PrimitiveBase {
  Panel(
      {super.tag,
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
      List<Primitive> items = const [],
      FlowDirection? flowDirection,
      HorizontalItemAlignment? horizontalItemAlignment,
      LayoutMethod? layoutMethod,
      String title = '',
      Primitive? icon,
      VerticalItemAlignment? verticalItemAlignment,
      int status = 0}) {
    _items = Any1DField.from(items);
    _title = StringField.from(title);
    _icon = AnyField.from(icon);
    _status = IntegerField.from(status);
    this.flowDirection = flowDirection;
    this.horizontalItemAlignment = horizontalItemAlignment;
    this.layoutMethod = layoutMethod;
    this.verticalItemAlignment = verticalItemAlignment;
  }

  // Field storage
  final _flowDirection = EnumOptField<FlowDirection>(FlowDirection.values);
  final _horizontalItemAlignment =
      EnumField<HorizontalItemAlignment>(HorizontalItemAlignment.values);
  late AnyField _icon;
  late Any1DField _items;
  final _layoutMethod = EnumField<LayoutMethod>(LayoutMethod.values);
  late IntegerField _status;
  late StringField _title;
  final _verticalItemAlignment =
      EnumField<VerticalItemAlignment>(VerticalItemAlignment.values);

  @override
  String get describeType => 'Panel';

  // Field keys for panel's own fields (see firstOwnFKey in fkey.dart). Fixed
  // and append-only, matching golib field-for-field.
  static const _fkIcon = 100;
  static const _fkItems = 101;
  static const _fkHorizontalItemAlignment = 102;
  static const _fkVerticalItemAlignment = 103;
  static const _fkFlowDirection = 104;
  static const _fkLayoutMethod = 105;
  static const _fkTitle = 106;

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
    fieldRefs.add(FieldRef(_fkFlowDirection, 'FlowDirection', _flowDirection));
    fieldRefs.add(heightFieldRef());
    fieldRefs.add(horizontalAlignmentFieldRef());
    fieldRefs.add(FieldRef(_fkHorizontalItemAlignment,
        'HorizontalItemAlignment', _horizontalItemAlignment));
    fieldRefs.add(FieldRef(_fkIcon, 'Icon', _icon));
    fieldRefs.add(FieldRef(_fkItems, 'Items', _items));
    fieldRefs.add(FieldRef(_fkLayoutMethod, 'LayoutMethod', _layoutMethod));
    fieldRefs.add(leftFieldRef());
    fieldRefs.add(marginAllFieldRef());
    fieldRefs.add(marginBottomFieldRef());
    fieldRefs.add(marginLeftFieldRef());
    fieldRefs.add(marginRightFieldRef());
    fieldRefs.add(marginTopFieldRef());
    fieldRefs.add(paddingAllFieldRef());
    fieldRefs.add(paddingBottomFieldRef());
    fieldRefs.add(paddingLeftFieldRef());
    fieldRefs.add(paddingRightFieldRef());
    fieldRefs.add(paddingTopFieldRef());
    fieldRefs.add(rightFieldRef());
    fieldRefs.add(FieldRef(fkStatus, 'Status', _status));
    fieldRefs.add(tagFieldRef());
    fieldRefs.add(FieldRef(_fkTitle, 'Title', _title));
    fieldRefs.add(topFieldRef());
    fieldRefs.add(verticalAlignmentFieldRef());
    fieldRefs.add(FieldRef(_fkVerticalItemAlignment, 'VerticalItemAlignment',
        _verticalItemAlignment));
    fieldRefs.add(widthFieldRef());
  }

  @override
  Primitive locateNextDescendant(PKeyLocator locator) {
    // Container fields in alphabetical order: Icon (0), Items (1).
    var nextIndex = locator.nextIndex();
    switch (nextIndex) {
      case 0:
        return icon!;
      case 1:
        return items[locator.nextIndex()];
      default:
        throw Exception('PKey locator is out of bounds');
    }
  }

  @override
  String toString() {
    return "";
  }

  /// The collection of primitives that make up the panel.
  List<Primitive> get items => _items.value;
  set items(List<Primitive> items) => _items.value = items;

  /// The optional title to display for the panel. Only used in certain
  /// embodiments.
  String get title => _title.value;
  set title(String s) => _title.value = s;

  /// The optional icon to display along with the title. Only used in certain
  /// embodiments.
  Primitive? get icon => _icon.value;
  set icon(Primitive? p) => _icon.value = p;

  /// The flow direction of items within the panel. Null means unset/default.
  FlowDirection? get flowDirection => _flowDirection.value;
  set flowDirection(FlowDirection? value) => _flowDirection.value = value;

  /// How items align horizontally within the panel. Null means unset/default.
  HorizontalItemAlignment? get horizontalItemAlignment =>
      _horizontalItemAlignment.isDefault
          ? null
          : _horizontalItemAlignment.value;
  set horizontalItemAlignment(HorizontalItemAlignment? value) =>
      _horizontalItemAlignment.value = value ?? HorizontalItemAlignment.left;

  /// The panel's child-layout method: automatic flow, or explicit positioning
  /// via the common positioning fields. Null means unset/default (flow).
  LayoutMethod? get layoutMethod =>
      _layoutMethod.isDefault ? null : _layoutMethod.value;
  set layoutMethod(LayoutMethod? value) =>
      _layoutMethod.value = value ?? LayoutMethod.flow;

  /// How items align vertically within the panel. Null means unset/default.
  VerticalItemAlignment? get verticalItemAlignment =>
      _verticalItemAlignment.isDefault ? null : _verticalItemAlignment.value;
  set verticalItemAlignment(VerticalItemAlignment? value) =>
      _verticalItemAlignment.value = value ?? VerticalItemAlignment.top;

  /// The status of the primitive: 0 = Normal, 1 = Disabled, 2 = Hidden, 3 = Collapsed.
  int get status => _status.value;
  set status(int status) {
    _status.value = status;
  }

  /// The enabled status of the primitive. Derived from the Status field.
  bool get enabled => status == 0;
  set enabled(bool enabled) {
    status = enabled ? 0 : 1;
  }

  /// The visibility of the primitive. Derived from the Status field.
  bool get visible => status == 0 || status == 1;
  set visible(bool visible) {
    status = visible ? 0 : 2;
  }

  /// The hidden status of the primitive. Derived from the Status field.
  bool get hidden => status == 2;
  set hidden(bool hidden) {
    status = hidden ? 2 : 0;
  }

  /// The collapsed status of the primitive. Derived from the Status field.
  bool get collapsed => status == 3;
  set collapsed(bool collapsed) {
    status = collapsed ? 3 : 0;
  }
}
