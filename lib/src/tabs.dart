// Copyright 2024-2026 ProntoGUI, LLC
// ProntoGUI™ is a trademark of ProntoGUI, LLC
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'pkey.dart';
import 'primitive_base.dart';
import 'notification.dart';
import 'any1d_field.dart';
import 'boolean_field.dart';
import 'double_field.dart';
import 'integer_field.dart';
import 'primitive.dart';
import 'enum_field.dart';
import 'enums.dart';
import 'fkey.dart';

/// Tabs presents a collection of Tab primitives, one visible at a time. The
/// active tab (selectedTab) is server-visible - unlike the old List "tabbed"
/// embodiment it split out of. Mirrors golib's tabs.go.
class Tabs extends PrimitiveBase {
  Tabs({
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
    List<Primitive> items = const [],
    int selectedTab = 0,
    TabOrientation? tabOrientation,
    TabLabelOrientation? tabLabelOrientation,
    double? tabBarHeight,
    bool scrollable = false,
    int animationPeriodMs = 0,
    bool eagerContent = false,
    int status = 0,
  }) {
    _items = Any1DField.from(items);
    _selectedTab = IntegerField.from(selectedTab);
    _scrollable = BooleanField.from(scrollable);
    _animationPeriodMs = IntegerField.from(animationPeriodMs);
    _eagerContent = BooleanField.from(eagerContent);
    _status = IntegerField.from(status);
    this.tabOrientation = tabOrientation;
    this.tabLabelOrientation = tabLabelOrientation;
    this.tabBarHeight = tabBarHeight;
  }

  // Field storage
  late IntegerField _animationPeriodMs;
  late BooleanField _eagerContent;
  late Any1DField _items;
  final _notificationsHandled = IntegerField();
  late BooleanField _scrollable;
  late IntegerField _selectedTab;
  late IntegerField _status;
  final _tabBarHeight = DoubleField();
  final _tabOrientation = EnumField<TabOrientation>(TabOrientation.values);
  final _tabLabelOrientation =
      EnumField<TabLabelOrientation>(TabLabelOrientation.values);

  @override
  String get describeType => 'Tabs';

  // Field keys - fixed and append-only, matching golib's tabs.go.
  static const _fkItems = 100;
  static const _fkSelectedTab = 101;
  static const _fkTabOrientation = 102;
  static const _fkTabBarHeight = 103;
  static const _fkScrollable = 104;
  static const _fkAnimationPeriodMs = 105;
  static const _fkEagerContent = 106;
  static const _fkTabLabelOrientation = 107;

  @override
  void describeFields(List<FieldRef> fieldRefs) {
    fieldRefs.add(FieldRef(
        _fkAnimationPeriodMs, 'AnimationPeriodMs', _animationPeriodMs));
    fieldRefs.add(backgroundColorFieldRef());
    fieldRefs.add(borderAllFieldRef());
    fieldRefs.add(borderBottomFieldRef());
    fieldRefs.add(borderColorFieldRef());
    fieldRefs.add(borderLeftFieldRef());
    fieldRefs.add(borderRightFieldRef());
    fieldRefs.add(borderTopFieldRef());
    fieldRefs.add(bottomFieldRef());
    fieldRefs.add(FieldRef(_fkEagerContent, 'EagerContent', _eagerContent));
    fieldRefs.add(heightFieldRef());
    fieldRefs.add(horizontalAlignmentFieldRef());
    fieldRefs.add(FieldRef(_fkItems, 'Items', _items));
    fieldRefs.add(leftFieldRef());
    fieldRefs.add(marginAllFieldRef());
    fieldRefs.add(marginBottomFieldRef());
    fieldRefs.add(marginLeftFieldRef());
    fieldRefs.add(marginRightFieldRef());
    fieldRefs.add(marginTopFieldRef());
    fieldRefs.add(FieldRef(
        fkNotificationsHandled, 'NotificationsHandled', _notificationsHandled));
    fieldRefs.add(paddingAllFieldRef());
    fieldRefs.add(paddingBottomFieldRef());
    fieldRefs.add(paddingLeftFieldRef());
    fieldRefs.add(paddingRightFieldRef());
    fieldRefs.add(paddingTopFieldRef());
    fieldRefs.add(rightFieldRef());
    fieldRefs.add(FieldRef(_fkScrollable, 'Scrollable', _scrollable));
    fieldRefs.add(FieldRef(_fkSelectedTab, 'SelectedTab', _selectedTab));
    fieldRefs.add(FieldRef(fkStatus, 'Status', _status));
    fieldRefs.add(FieldRef(_fkTabBarHeight, 'TabBarHeight', _tabBarHeight));
    fieldRefs.add(FieldRef(
        _fkTabLabelOrientation, 'TabLabelOrientation', _tabLabelOrientation));
    fieldRefs
        .add(FieldRef(_fkTabOrientation, 'TabOrientation', _tabOrientation));
    fieldRefs.add(tagFieldRef());
    fieldRefs.add(topFieldRef());
    fieldRefs.add(verticalAlignmentFieldRef());
    fieldRefs.add(widthFieldRef());
  }

  @override
  Primitive locateNextDescendant(PKeyLocator locator) {
    if (locator.nextIndex() != 0) {
      throw Exception('PKey locator is out of bounds');
    }
    return items[locator.nextIndex()];
  }

  @override
  String toString() => '';

  @override
  bool isNotificationHandled(int notificationType) =>
      (_notificationsHandled.value & Notify.bit(notificationType)) != 0;

  /// The collection of Tab primitives.
  List<Primitive> get items => _items.value;
  set items(List<Primitive> value) => _items.value = value;

  /// The index of the active tab.
  int get selectedTab => _selectedTab.value;
  set selectedTab(int value) => _selectedTab.value = value;

  /// Where the tab bar sits relative to the content. Null means unset
  /// (top).
  TabOrientation? get tabOrientation =>
      _tabOrientation.isDefault ? null : _tabOrientation.value;
  set tabOrientation(TabOrientation? value) =>
      _tabOrientation.value = value ?? TabOrientation.top;

  /// How tab labels are drawn for a Left/Right tab bar. Null means unset
  /// (horizontal).
  TabLabelOrientation? get tabLabelOrientation =>
      _tabLabelOrientation.isDefault ? null : _tabLabelOrientation.value;
  set tabLabelOrientation(TabLabelOrientation? value) =>
      _tabLabelOrientation.value = value ?? TabLabelOrientation.horizontal;

  /// The tab bar's fixed height, or null to size to content.
  double? get tabBarHeight =>
      _tabBarHeight.isDefault ? null : _tabBarHeight.value;
  set tabBarHeight(double? value) => _tabBarHeight.value = value ?? 0.0;

  /// Whether the tab bar scrolls when tabs overflow.
  bool get scrollable => _scrollable.value;
  set scrollable(bool value) => _scrollable.value = value;

  /// The tab-switch animation period, in milliseconds.
  int get animationPeriodMs => _animationPeriodMs.value;
  set animationPeriodMs(int value) => _animationPeriodMs.value = value;

  /// Whether every tab's content is built up front. False (the default)
  /// means only the visible tab's content is built (lazy).
  bool get eagerContent => _eagerContent.value;
  set eagerContent(bool value) => _eagerContent.value = value;

  /// 0 = Normal, 1 = Disabled, 2 = Hidden, 3 = Collapsed.
  int get status => _status.value;
  set status(int value) => _status.value = value;

  bool get enabled => status == 0;
  set enabled(bool value) => status = value ? 0 : 1;

  bool get visible => status == 0 || status == 1;
  set visible(bool value) => status = value ? 0 : 2;

  bool get hidden => status == 2;
  set hidden(bool value) => status = value ? 2 : 0;

  bool get collapsed => status == 3;
  set collapsed(bool value) => status = value ? 3 : 0;
}
