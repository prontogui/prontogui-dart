// Copyright 2024-2026 ProntoGUI, LLC
// ProntoGUI™ is a trademark of ProntoGUI, LLC
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:test/test.dart';
import 'package:prontogui/src/snackbar.dart';
import 'package:prontogui/src/text.dart';
import 'package:prontogui/src/button.dart';
import 'package:prontogui/src/enums.dart';
import 'package:prontogui/src/pkey.dart';

void main() {
  group('Snackbar', () {
    test('should initialize with default values', () {
      final snackbar = Snackbar();

      expect(snackbar.messageItem, isNull);
      expect(snackbar.actionItem, isNull);
      expect(snackbar.behavior, SnackbarBehavior.fixed);
      expect(snackbar.durationSeconds, 0.0);
      expect(snackbar.showCloseIcon, isFalse);
      expect(snackbar.showing, isFalse);
      expect(snackbar.status, 0);
    });

    test('should initialize with provided values', () {
      final message = Text();
      final action = Button();
      final snackbar = Snackbar(
        messageItem: message,
        actionItem: action,
        behavior: SnackbarBehavior.floating,
        durationSeconds: 5.0,
        showCloseIcon: true,
        showing: true,
      );

      expect(snackbar.messageItem, message);
      expect(snackbar.actionItem, action);
      expect(snackbar.behavior, SnackbarBehavior.floating);
      expect(snackbar.durationSeconds, 5.0);
      expect(snackbar.showCloseIcon, isTrue);
      expect(snackbar.showing, isTrue);
    });

    test('should update fields', () {
      final snackbar = Snackbar();
      final message = Text();

      snackbar.messageItem = message;
      snackbar.behavior = SnackbarBehavior.floating;
      snackbar.durationSeconds = 2.5;
      snackbar.showCloseIcon = true;
      snackbar.showing = true;

      expect(snackbar.messageItem, message);
      expect(snackbar.behavior, SnackbarBehavior.floating);
      expect(snackbar.durationSeconds, 2.5);
      expect(snackbar.showCloseIcon, isTrue);
      expect(snackbar.showing, isTrue);
    });

    test('should describe type correctly', () {
      expect(Snackbar().describeType, 'Snackbar');
    });

    test('should locate next descendant correctly', () {
      final message = Text();
      final action = Button();
      final snackbar = Snackbar(messageItem: message, actionItem: action);

      // Index 0 is actionItem, index 1 is messageItem.
      expect(
          snackbar.locateNextDescendant(PKeyLocator(PKey(0))), action);
      expect(
          snackbar.locateNextDescendant(PKeyLocator(PKey(1))), message);
    });

    test('should throw exception for out of bounds locator', () {
      final snackbar = Snackbar();
      final locator = PKeyLocator(PKey(9));

      expect(() => snackbar.locateNextDescendant(locator), throwsException);
    });
  });
}
