// Copyright 2024-2026 ProntoGUI, LLC
// ProntoGUI™ is a trademark of ProntoGUI, LLC
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:cbor/cbor.dart';
import 'package:prontogui/prontogui.dart';
import 'package:prontogui/src/field_hooks.dart';
import 'package:prontogui/src/field_owner.dart';
import 'package:prontogui/src/integer_field.dart';
import 'package:prontogui/src/opt_field.dart';
import 'package:test/test.dart';

/// CBOR array produced by golib for [unset double, double 0, double 2.5,
/// int 0, int -5, color transparent, enum index 0] - see golib's
/// Test_OptField_DecodesDartlibBytes for the reverse direction. golib writes
/// doubles as float64 (fb...); dartlib as the shortest exact float (f9...).
const golibHex = '87f6fb0000000000000000fb400400000000000000240000';

List<CborValue> decodeHex(String hex) {
  final bytes = [
    for (var i = 0; i < hex.length; i += 2)
      int.parse(hex.substring(i, i + 2), radix: 16)
  ];
  return (cbor.decode(bytes) as CborList).toList();
}

/// Records onSet calls, to check that set and unset both mark the field changed.
class _Hooks implements FieldHooks {
  int sets = 0;
  @override
  void onSetField(PKey pkey, FKey fkey, bool structural,
          [int containerIndex = -1]) =>
      sets++;
  @override
  void onIngestField(PKey pkey, FKey fkey, bool structural,
      [int containerIndex = -1]) {}
  @override
  void onNotify(PKey pkey, int notificationType) {}
}

class _Owner implements FieldOwner {
  _Owner(this.fieldHooks);
  @override
  final FieldHooks fieldHooks;
  @override
  PKey get pkey => PKey(0);
  @override
  PrimitiveLocator? get locator => null;
}

void main() {
  group('OptField', () {
    test('starts unset, which is the default and egests null', () {
      final f = DoubleOptField();
      expect(f.value, isNull);
      expect(f.isSet, isFalse);
      expect(f.isDefault, isTrue);
      expect(f.egestCborValue(), const CborNull());
    });

    test('set to 0 is not the default and is egested', () {
      final f = DoubleOptField()..value = 0;
      expect(f.isSet, isTrue);
      expect(f.isDefault, isFalse);
      expect(f.egestCborValue(), CborFloat(0));

      f.unset();
      expect(f.isSet, isFalse);
      expect(f.egestCborValue(), const CborNull());
    });

    test('set and unset both mark the field changed', () {
      final hooks = _Hooks();
      final f = IntegerOptField()..prepareForUpdates(100, 0, _Owner(hooks));
      f.value = 0;
      f.unset();
      expect(hooks.sets, 2);
    });

    test('ingested null unsets; ingested value sets', () {
      final f = ColorOptField()..ingestFullCborValue(const CborSmallInt(0));
      expect(f.value, Colors.transparent, reason: 'transparent is a set value');
      f.ingestFullCborValue(const CborNull());
      expect(f.isSet, isFalse);

      final e = EnumOptField<ImageFit>(ImageFit.values)
        ..ingestFullCborValue(const CborSmallInt(0));
      expect(e.value, ImageFit.values.first,
          reason: 'the first value is an ordinary choice');
      expect(e.egestCborValue(), const CborSmallInt(0));
    });

    test('non-optional fields still reject null', () {
      expect(() => IntegerField().ingestFullCborValue(const CborNull()),
          throwsException);
    });

    test('decodes values encoded by golib', () {
      final v = decodeHex(golibHex);
      final d = [
        for (var i = 0; i < 3; i++) DoubleOptField()..ingestFullCborValue(v[i])
      ];
      expect(d.map((f) => f.value), [null, 0.0, 2.5]);
      final i0 = IntegerOptField()..ingestFullCborValue(v[3]);
      final im5 = IntegerOptField()..ingestFullCborValue(v[4]);
      expect([i0.value, im5.value], [0, -5]);
      final c = ColorOptField()..ingestFullCborValue(v[5]);
      expect(c.value, Colors.transparent);
      final e = EnumOptField<ImageFit>(ImageFit.values)
        ..ingestFullCborValue(v[6]);
      expect(e.value, ImageFit.values.first);
    });
  });
}
