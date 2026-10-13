// Copyright 2024-2026 ProntoGUI, LLC
// ProntoGUI™ is a trademark of ProntoGUI, LLC
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'pkey.dart';
import 'primitive.dart';

abstract class PrimitiveLocator {
  Primitive? locatePrimitive(PKey pkey);

  /// The current GUI generation (see PrimitiveModel.guiEpoch) - carried on
  /// every full and partial update.
  int get guiEpoch;
}

/// A null implementation of [PrimitiveLocator] that does nothing.  Primarily used
/// for testing purposes.
class NullPrimitiveLocator implements PrimitiveLocator {
  @override
  Primitive? locatePrimitive(PKey pkey) {
    return null;
  }

  @override
  int get guiEpoch => 0;
}
