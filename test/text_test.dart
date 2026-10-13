// Copyright 2024-2026 ProntoGUI, LLC
// ProntoGUI™ is a trademark of ProntoGUI, LLC
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:test/test.dart';
import 'package:prontogui/src/text.dart';
import 'package:prontogui/src/pkey.dart';
import 'package:prontogui/src/field_hooks.dart';
import 'package:prontogui/src/primitive_locator.dart';

void main() {
  group('Text', () {
    test('Default constructor initializes with empty strings', () {
      final text = Text();
      expect(text.content, '');
      expect(text.tag, '');
    });

    test('Constructor initializes with provided values', () {
      final text = Text(content: 'Hello', tag: 'Greeting');
      expect(text.content, 'Hello');
      expect(text.tag, 'Greeting');
    });

    test('Content getter and setter work correctly', () {
      final text = Text();
      text.content = 'New Content';
      expect(text.content, 'New Content');
    });

    test('Tag getter and setter work correctly', () {
      final text = Text();
      text.tag = 'New Tag';
      expect(text.tag, 'New Tag');
    });

    test('toString returns content', () {
      final text = Text(content: 'Sample Text');
      expect(text.toString(), 'Sample Text');
    });

    test('prepareForUpdates does not throw', () {
      final text = Text();
      expect(
          () => text.prepareForUpdates(
              PKey(), NullFieldHooks(), NullPrimitiveLocator()),
          returnsNormally);
    });
  });
}
