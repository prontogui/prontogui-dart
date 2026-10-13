// Copyright 2024-2026 ProntoGUI, LLC
// ProntoGUI™ is a trademark of ProntoGUI, LLC
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'pkey.dart';
import 'field_hooks.dart';
import 'primitive_locator.dart';

/// The primitive that owns a field. A [FieldBase] reaches its pkey, its update
/// hooks, and the primitive locator through this back-pointer rather than
/// storing its own copy of each - one set per primitive, not one per field.
/// [PrimitiveBase] implements it.
abstract interface class FieldOwner {
  PKey get pkey;
  FieldHooks? get fieldHooks;
  PrimitiveLocator? get locator;
}
