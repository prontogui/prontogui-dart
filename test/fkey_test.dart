// Copyright 2024-2026 ProntoGUI, LLC
// ProntoGUI™ is a trademark of ProntoGUI, LLC
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
//
// FKey is now scoped per primitive (see fkey.dart) rather than drawn from a
// single global name registry, so there's no more fkeyFor/fieldnameFor to
// test here — each primitive's own field-key assignment is exercised via
// that primitive's own tests (egest/ingest round trips).
import 'package:test/test.dart';
import 'package:prontogui/src/fkey.dart';

void main() {
  test('invalidFieldName is a value no real field key would collide with.', () {
    expect(invalidFieldName, lessThan(0));
  });
}
