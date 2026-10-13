// Copyright 2024-2026 ProntoGUI, LLC
// ProntoGUI™ is a trademark of ProntoGUI, LLC
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'dart:typed_data';
import 'package:test/test.dart';
import 'package:prontogui/src/export_file.dart';

void main() {
  group('ExportFile', () {
    test('initial values are correct', () {
      final exportFile = ExportFile(name: 'test.txt');

      expect(exportFile.completed, isFalse);
      expect(exportFile.data, isEmpty);
      expect(exportFile.name, 'test.txt');
    });

    test('reset method clears data and completed flag', () {
      final exportFile = ExportFile(name: 'test.txt');
      exportFile.data = Uint8List.fromList([1, 2, 3]);
      exportFile.completed = true;

      exportFile.reset();

      expect(exportFile.data, isEmpty);
      expect(exportFile.completed, isFalse);
    });

    test('completed getter and setter work correctly', () {
      final exportFile = ExportFile(name: 'test.txt');
      exportFile.completed = true;

      expect(exportFile.completed, isTrue);

      exportFile.completed = false;

      expect(exportFile.completed, isFalse);
    });

    test('data getter and setter work correctly', () {
      final exportFile = ExportFile(name: 'test.txt');
      final data = Uint8List.fromList([1, 2, 3]);

      exportFile.data = data;

      expect(exportFile.data, data);
    });

    test('name getter and setter work correctly', () {
      final exportFile = ExportFile(name: 'test.txt');
      final newName = 'new_test.txt';

      exportFile.name = newName;

      expect(exportFile.name, newName);
    });

    test('toString returns the correct name', () {
      final exportFile = ExportFile(name: 'test.txt');

      expect(exportFile.toString(), 'test.txt');
    });
  });
}
