// Copyright 2024-2026 ProntoGUI, LLC
// ProntoGUI™ is a trademark of ProntoGUI, LLC
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

/// The wire-envelope version. It bumps only on a wire-incompatible change to
/// the envelope shape itself (not on additions to the primitive/field
/// catalog) — a client and server always ship in matched pairs, so this
/// exists to fail loudly on a mismatch rather than to negotiate
/// compatibility. Must stay numerically identical to golib's
/// synchro.ProtocolVersion.
const int protocolVersion = 3;
