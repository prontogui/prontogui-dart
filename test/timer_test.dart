// Copyright 2024-2026 ProntoGUI, LLC
// ProntoGUI™ is a trademark of ProntoGUI, LLC
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:test/test.dart';
import 'package:prontogui/src/timer.dart';

void main() {
  group('Timer', () {
    test('should initialize with default periodMs', () {
      final timer = Timer();
      expect(timer.periodMs, 0);
    });

    test('should initialize with given periodMs', () {
      final timer = Timer(periodMs: 1000);
      expect(timer.periodMs, 1000);
    });

    test('should update periodMs', () {
      final timer = Timer();
      timer.periodMs = 500;
      expect(timer.periodMs, 500);
    });

    test('should describe type correctly', () {
      final timer = Timer();
      expect(timer.describeType, 'Timer');
    });

    test('should convert to string correctly', () {
      final timer = Timer(periodMs: 2000);
      expect(timer.toString(), 'Timer: periodMs=2000 (ms)');
    });
  });
}
