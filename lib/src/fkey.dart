// Copyright 2024-2026 ProntoGUI, LLC
// ProntoGUI™ is a trademark of ProntoGUI, LLC
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

/// FKey identifies a field within a single primitive type. Field keys are
/// scoped per primitive (see PKind in pkind.dart) rather than drawn from one
/// global registry shared by every primitive — Card's FKey 3 and Button's
/// FKey 3 are unrelated. This is safe because a primitive's fields are only
/// ever interpreted once its PKind is already known — decode never needs to
/// guess a field's meaning from its numeric key alone.
///
/// Within one primitive, every field's key is a fixed, permanent, explicitly
/// assigned number - never computed or re-derived. This matters because the
/// server (embedding golib/dartlib) and the App are independently versioned
/// and independently deployed; a receiver on one version has to be able to
/// correctly interpret an update from a sender on a different version. A
/// scheme that re-derives keys from the current field set (e.g. "alphabetical
/// order over all fields") breaks that: adding one field anywhere in the
/// alphabet silently renumbers every field after it, so the same numeric key
/// means a different field depending on which version produced it. Fixed,
/// append-only numbering avoids that: a key assigned to a field means that
/// field forever, on every version, past or future.
///
/// FKey numbering must stay identical to golib's for the same primitive.
/// Unlike before, these are no longer independently re-derivable by each
/// language applying the same rule - they're an explicit, hand-maintained
/// agreement. golib's key/fkey.go is the canonical source; the constants
/// below mirror it exactly, field-for-field.
typedef FKey = int;

/// Sentinel for "no field key yet" — used as a placeholder before a field is
/// prepared for updates, not as part of any name-lookup scheme.
const invalidFieldName = -1;

/// Shared field keys: the same key means the same field on every primitive
/// that has it, unlike a primitive's own keys (FirstOwnFKey and up), which
/// mean different things on different primitives. Numbering follows
/// app_core/specs/prontogui.schema.yaml (field_groups). Pre-release it may be
/// renumbered; after the first release it is append-only - never renumber or
/// reuse a key.

/// common: every primitive except the non-visual Nothing and ColumnSettings.
const int fkStatus = 0;
const int fkTag = 1;

/// notifier: every primitive with notifications - its NotificationsHandled bitmask.
const int fkNotificationsHandled = 2;

/// layout: box model and positioning (see PrimitiveBase).
const int fkBackgroundColor = 3;
const int fkBorderAll = 4;
const int fkBorderBottom = 5;
const int fkBorderColor = 6;
const int fkBorderLeft = 7;
const int fkBorderRight = 8;
const int fkBorderTop = 9;
const int fkBottom = 10;
const int fkHeight = 11;
const int fkHorizontalAlignment = 12;
const int fkLeft = 13;
const int fkMarginAll = 14;
const int fkMarginBottom = 15;
const int fkMarginLeft = 16;
const int fkMarginRight = 17;
const int fkMarginTop = 18;
const int fkPaddingAll = 19;
const int fkPaddingBottom = 20;
const int fkPaddingLeft = 21;
const int fkPaddingRight = 22;
const int fkPaddingTop = 23;
const int fkRight = 24;
const int fkTop = 25;
const int fkVerticalAlignment = 26;
const int fkWidth = 27;

/// text_style: text styling (see TextStyleFieldsMixin).
const int fkFontColor = 28;
const int fkFontFamily = 29;
const int fkFontSize = 30;
const int fkFontStyle = 31;
const int fkFontWeight = 32;
const int fkHorizontalTextAlignment = 33;
const int fkVerticalTextAlignment = 34;

/// The first FKey available for a primitive's own fields. Shared-field
/// blocks occupy 0-34 above, with headroom reserved up to this boundary for
/// future shared fields (either more common fields, or an entirely new
/// shared block like TextStyleFieldsMixin) to be added without ever
/// colliding with a primitive's own range. Each primitive assigns its own
/// fields fixed literal numbers starting here (see e.g. _fkLabel in
/// tristate.dart), in whatever order they were introduced - append-only,
/// same rule as above, and matching golib's assignment for the same
/// primitive field-for-field.
const int firstOwnFKey = 100;
