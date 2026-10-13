// Copyright 2024-2026 ProntoGUI, LLC
// ProntoGUI™ is a trademark of ProntoGUI, LLC
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:prontogui/prontogui.dart';
import 'package:test/test.dart';

// Declaration order is the wire value and must match golib's enums.go. These
// enums back optional fields, so order carries no default (null = unset).
void main() {
  test('enum order matches golib', () {
    expect(CheckBoxPosition.values, [
      CheckBoxPosition.top,
      CheckBoxPosition.bottom,
      CheckBoxPosition.left,
      CheckBoxPosition.right
    ]);
    expect(LabelItemPosition.values, [
      LabelItemPosition.top,
      LabelItemPosition.bottom,
      LabelItemPosition.left,
      LabelItemPosition.right
    ]);
    expect(FlowDirection.values,
        [FlowDirection.leftToRight, FlowDirection.topToBottom]);
    expect(ImageFit.values, [
      ImageFit.fill,
      ImageFit.contain,
      ImageFit.cover,
      ImageFit.fitWidth,
      ImageFit.fitHeight,
      ImageFit.none,
      ImageFit.scaleDown,
    ]);
    expect(FocusSelection.values,
        [FocusSelection.begin, FocusSelection.end, FocusSelection.all]);
  });
}
