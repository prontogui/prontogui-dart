// Copyright 2024-2026 ProntoGUI, LLC
// ProntoGUI™ is a trademark of ProntoGUI, LLC
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// Enum types backing the Wave 2+ primitive-specific fields (Wave 1 covered
// only the fields shared by every primitive - see alignment.dart). These
// replace the equivalent enums that used to live entirely on the App side,
// parsed out of the embodiment string (see app_core's pre-2.0
// properties.dart). Must stay declaration-order-identical to golib's
// enums.go - see EnumField's doc comment for why (index is the wire value).

/// Where a checkbox is drawn relative to its label, on Check and Tristate.
/// Fields of this type are optional: null (unset) = [left].
enum CheckBoxPosition { top, bottom, left, right }

/// How a negative number is displayed, on NumericField.
enum DisplayNegativeFormat { absolute, minusSignPrefix, parens }

/// The flow direction of items within a Panel, View, or Dialog. Fields of
/// this type are optional: null (unset) = [topToBottom].
enum FlowDirection { leftToRight, topToBottom }

/// Which part of a text entry is selected when it first gains focus, on
/// TextField, NumericField, and ColorField. Fields of this type are optional:
/// null (unset) uses the primitive's own default (end for TextField, all for
/// NumericField and ColorField).
enum FocusSelection { begin, end, all }

/// The icon style used to indicate expand/collapse state, on Folder.
enum FolderIcons { chevron, fileFolder, plusMinus }

/// Text style, on the primitives with [TextStyleFieldsMixin].
enum FontStyle { normal, italic }

/// Text weight, on the primitives with [TextStyleFieldsMixin].
enum FontWeight { normal, bold, w1, w2, w3, w4, w5, w6, w7, w8, w9 }

/// How items flow horizontally within a Frame or Group.
enum HorizontalItemAlignment {
  left,
  center,
  right,
  expand,
  baseline,
  spaceBetween,
  spaceAround,
  spaceEvenly,
}

/// Horizontal alignment of text within its own bounds, on the primitives
/// with [TextStyleFieldsMixin]. Distinct from [HorizontalAlignment]
/// (alignment.dart), which positions the whole primitive within the space
/// its parent gives it.
enum HorizontalTextAlignment { left, center, right, justify }

/// How an Image fills its bounds. Fields of this type are optional: null
/// (unset) = [contain].
enum ImageFit { fill, contain, cover, fitWidth, fitHeight, none, scaleDown }

/// Where a Button/Check/Tristate's label item is positioned relative to
/// its label text. Fields of this type are optional: null (unset) = [left].
enum LabelItemPosition { top, bottom, left, right }

/// Frame's child-layout method: automatic flow, or explicit left/top/right/
/// bottom positioning via the common positioning fields.
enum LayoutMethod { flow, positioned }

/// How a Snackbar behaves:  fixed to the bottom edge, or floating.
enum SnackbarBehavior { fixed, floating }

/// The visual style of a Button.
enum ButtonStyle { elevated, outlined }

/// The visual style of a Check.
enum CheckStyle { checkbox, toggleButton }

/// The visual style of a Choice.
enum ChoiceStyle { dropdown, segmented }

/// The visual style of a Card.
enum CardStyle { card, tile }

/// How a Table column sorts, in its ColumnSettings.
enum SortType { none, text, numeric, tag, dateTime }

/// Where the tab bar sits relative to the tab content, on Tabs.
enum TabOrientation { top, bottom, left, right }

/// How a tab's label is drawn for a Left/Right tab bar, on Tabs. rotatedCW
/// reads top-to-bottom (book spine); rotatedCCW reads bottom-to-top. The icon
/// stays upright. Ignored for Top/Bottom.
enum TabLabelOrientation { horizontal, rotatedCW, rotatedCCW }

/// How items flow vertically within a Frame or Group.
enum VerticalItemAlignment {
  top,
  middle,
  bottom,
  expand,
  baseline,
  spaceBetween,
  spaceAround,
  spaceEvenly,
}

/// Vertical alignment of text within its own bounds, on the primitives with
/// [TextStyleFieldsMixin]. Distinct from [VerticalAlignment]
/// (alignment.dart), which positions the whole primitive within the space
/// its parent gives it.
enum VerticalTextAlignment { top, middle, bottom }
