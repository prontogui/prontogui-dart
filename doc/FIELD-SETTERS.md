# Field Setter Policy

**Status:** Policy, binding on every ProntoGUI language library. dartlib is the
reference implementation; golib and later ports must match it.

## Policy

1. **Every field set marks the field changed, unconditionally.** A setter stores
   the new value and then calls `onSet()` (Go: `OnSet(structural)`), which
   records the field in the synchro's pending update. A setter does **not**
   compare the new value with the current one, and must not skip recording
   when they are equal.

   ```dart
   set value(String s) {
     _s = s;
     onSet(); // always - even if s == _s
   }
   ```

2. **Ingested values never count as a set.** Values arriving from the other
   side go through `ingestFullCborValue` / `ingestPartialCborValue`, which
   assign the backing storage directly and call `onIngest()`, never `onSet()`.
   Taking in a peer's value therefore never queues it to be sent back.

3. **Repeated sets coalesce per pending update.** The synchro keeps at most one
   pending entry per primitive (pkey) and at most one occurrence of each field
   key (fkey) in it (`PrimitiveUpdate.appendField` here,
   `appendFieldToUpdate` in golib). Setting a field N times before the next
   flush sends its latest value once.

4. **All field types follow the same rule:** scalar, enum, color, blob, 1-D,
   the container fields (`AnyField`, `Any1DField`, `Any2DField`), and the
   optional fields (`DoubleOptField`, `IntegerOptField`, `ColorOptField`,
   `EnumOptField`). There is no per-type exception.

5. **Unsetting an optional field is a set too.** An optional field (schema type
   `int?`, `double?`, `color?`, `enum<T>?` - see
   `app_core/specs/OPTIONAL-FIELDS.md`) is either set to a value or unset.
   `unset()` (Go: `Unset()`, and assigning `null` in Dart) marks the field
   changed exactly like a set, and the partial update carries it as CBOR
   `null`. Setting it to `0` is a set like any other - it is not "unset", and
   it is always sent.

In short, **a set means "make the other side hold this value", not "this value
differs from what I had."**

## Rationale

### 1. A set is how one side resyncs the other

Both sides can edit some fields: the App writes user input (for example
`TextField.textEntry`, `Check.checked`), and the server can write the same
field. A side's local copy can therefore be out of date for the moment a peer's
update is in flight:

| Step | Server copy | App shows | |
|---|---|---|---|
| 1 | `""` | `""` | |
| 2 | `""` | `"abc"` | user types; the App's update is still on its way |
| 3 | `""` | `"abc"` | server code calls `setTextEntry("")` to clear the box |

If setters skipped equal values, step 3 would compare `""` with the out-of-date
`""`, decide nothing changed, and send nothing. The App would keep showing
`"abc"` and the server's intent would be lost. Because every set is sent, the
server's last write is always delivered. This is the main reason for the
policy, and the reason it must not be "optimized" away.

### 2. Container fields cannot check for changes cheaply or reliably

A container setter takes a list of primitives. In both Dart and Go a caller can
change that list in place and pass the same object back. An identity or shallow
check would then report "unchanged" although the contents changed. The only
sound test is a deep comparison of the child primitive trees, which costs more
than resending. A container set also has to run anyway, because it re-prepares
the children and re-assigns their pkeys.

Because container fields must always record a set, and a rule that differs by
field type is harder to reason about, scalar fields follow the same rule (see
policy item 4).

### 3. Equality is not well-defined for every type

- **Doubles:** `NaN != NaN`, so an equality check would resend a NaN on every
  set. `-0.0 == 0.0` would hide a sign change.
- **Blobs:** need a byte-by-byte comparison.
- **1-D fields:** need element-by-element comparison.
- **Enums and colors:** comparable, but each type needs its own check written
  and kept in sync across language libraries.

Leaving out equality keeps every setter the same two lines in every language,
which matters for keeping several language libraries behaving identically.

### 4. The cost is small

Coalescing (policy item 3) bounds a duplicate set to one resent field value per
flush. That is usually a few bytes, and normally over a local connection. The
only real cost is in code that re-sets many fields that haven't changed on
every event, which the guidance below addresses.

## Consequences for library users

- **Set only what you mean to send.** Code that re-applies all of its state on
  every event (an Elm-style "refresh everything") sends every field it touches,
  changed or not. Prefer refreshing only the parts affected by the event. In
  golib, `Run` calls `Refresh` only on Components that saw the notification;
  the global `OnRefresh` refreshes any others whose state depends on what
  changed.
- **Setting a field is a valid way to force a resend,** for example to reset a
  field the user may have edited. No special "touch" API is needed.
- **To clear an optional field, unset it** (`UnsetPaddingTop()` in Go,
  `paddingTop = null` in Dart) rather than setting a zero value: `0` is a real
  value for an optional field (e.g. "top padding 0, overriding PaddingAll"),
  while unset means "not specified - use the default or the stated fallback."
- **Don't rely on a set being skipped** to avoid side effects on the other
  side. Every set is delivered, and the other side applies it.

## If this policy is ever revisited

A future skip-if-unchanged behavior must preserve rationale 1. Acceptable shapes:

- an **opt-in** setter (for example `setIfChanged`) for scalar fields only,
  leaving the plain setter unconditional; or
- skip-if-unchanged plain setters for scalar fields **plus** an explicit
  force-resend API.

Container fields stay unconditional either way. Any change must land in every
language library together and be recorded here.
