// Copyright 2024-2026 ProntoGUI, LLC
// ProntoGUI™ is a trademark of ProntoGUI, LLC
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:cbor/cbor.dart';
import 'package:prontogui/src/primitive_locator.dart';
import 'package:test/test.dart';
import 'package:prontogui/src/button.dart';
import 'package:prontogui/src/enums.dart';
import 'package:prontogui/src/fkey.dart';
import 'package:prontogui/src/notification.dart';
import 'package:prontogui/src/pkey.dart';

import 'field_hooks_mock.dart';
import 'test_cbor_samples.dart';

void main() {
  group('Button', () {
    test('initial values are set correctly', () {
      final button = Button(label: 'Test Button', status: 1);

      expect(button.label, 'Test Button');
      expect(button.status, 1);
      expect(button.enabled, false);
      expect(button.visible, true);
    });

    test('style getter and setter work correctly', () {
      final button = Button();
      expect(button.style, isNull);
      button.style = ButtonStyle.outlined;
      expect(button.style, ButtonStyle.outlined);
    });

    test('notify() reaches the model only when the notification is handled',
        () {
      final button = Button();
      final hooks = FieldHooksMock();
      button.prepareForUpdates(PKey(0), hooks, NullPrimitiveLocator());

      // No handler registered by the server => no notification is emitted.
      button.notify(Notify.press);
      expect(hooks.onNotifyCalled, 0);

      // Simulate the server ingesting a NotificationsHandled bitmask with the
      // Press bit set.
      button.ingestPartialCborMap(CborMap({
        CborSmallInt(fkNotificationsHandled): CborSmallInt(Notify.bit(Notify.press)),
      }));
      button.notify(Notify.press);
      expect(hooks.onNotifyCalled, 1);
      expect(hooks.onNotifyType, Notify.press);
    });

    test('label getter and setter work correctly', () {
      final button = Button();
      button.label = 'New Label';

      expect(button.label, 'New Label');
    });

    test('status getter and setter work correctly', () {
      final button = Button();
      button.status = 2;

      expect(button.status, 2);
      expect(button.enabled, false);
      expect(button.visible, false);
    });

    test('enabled getter and setter work correctly', () {
      final button = Button();
      button.enabled = true;

      expect(button.status, 0);
      expect(button.enabled, true);

      button.enabled = false;

      expect(button.status, 1);
      expect(button.enabled, false);
    });

    test('visible getter and setter work correctly', () {
      final button = Button();
      button.visible = true;

      expect(button.status, 0);
      expect(button.visible, true);

      button.visible = false;

      expect(button.status, 2);
      expect(button.visible, false);
    });

    test('all fields are added', () {
      final button = Button();
      expect(
          () =>
              button.initializeFromCborMap(PKey(0), cborForButtonAsOutlined()),
          returnsNormally);
    });
  });
}
