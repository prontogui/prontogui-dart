// Copyright 2024-2026 ProntoGUI, LLC
// ProntoGUI™ is a trademark of ProntoGUI, LLC
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:test/test.dart';
import 'package:cbor/cbor.dart';
import 'package:prontogui/src/component.dart';
import 'package:prontogui/src/group.dart';
import 'package:prontogui/src/text.dart';
import 'package:prontogui/src/pkey.dart';
import 'package:prontogui/src/pkind.dart';

import 'test_cbor_samples.dart';

void main() {
  group('Component', () {
    test('should initialize with default values', () {
      final component = Component();
      expect(component.content, isNull);
      expect(component.status, 0);
      expect(component.describeType, 'Component');
      expect(component.toString(), 'Component');
    });

    test('kind is pkindComponent', () {
      expect(Component().kind, pkindComponent);
    });

    test('should initialize with provided values', () {
      final t = Text(content: 'inside');
      final component = Component(content: t, status: 1);
      expect(component.content, t);
      expect(component.status, 1);
    });

    test('content can be reassigned', () {
      final component = Component(content: Text());
      final g = Group();
      component.content = g;
      expect(component.content, g);
      component.content = null;
      expect(component.content, isNull);
    });

    test('status helpers map to Status', () {
      final component = Component();
      expect(component.enabled, isTrue);
      expect(component.visible, isTrue);

      component.enabled = false;
      expect(component.status, 1);
      expect(component.visible, isTrue);

      component.hidden = true;
      expect(component.status, 2);
      expect(component.visible, isFalse);

      component.collapsed = true;
      expect(component.status, 3);
      expect(component.collapsed, isTrue);

      component.collapsed = false;
      expect(component.status, 0);
    });

    test('should locate next descendant (Content=0)', () {
      final t = Text();
      final component = Component(content: t);
      expect(component.locateNextDescendant(PKeyLocator(PKey(0))), t);
    });

    test('should locate a descendant nested inside Content', () {
      final t2 = Text();
      final component = Component(content: Group(items: [Text(), t2]));
      // Content (0) -> Group's Items (0), second item.
      final g = component.locateNextDescendant(PKeyLocator(PKey(0)));
      expect(g, isA<Group>());
      expect(g.locateNextDescendant(PKeyLocator(PKey(0, 1))), t2);
    });

    test('initializeFromCborMap ingests nested Content', () {
      final component = Component();
      component.initializeFromCborMap(PKey(0), distinctCborForComponent());
      expect(component.content, isA<Text>());
      expect((component.content as Text).content,
          'Excepteur sint occaecat cupidatat');
    });

    test('egest then ingest round-trips Content and Status', () {
      final original =
          Component(content: Text(content: 'round trip'), status: 2);
      final cbor = original.egestFullCborMap();

      final copy = Component();
      copy.initializeFromCborMap(PKey(0), cbor);
      expect(copy.status, 2);
      expect(copy.content, isA<Text>());
      expect((copy.content as Text).content, 'round trip');
    });

    test('egest encodes Content as a [kind, fields] pair', () {
      final cbor = Component(content: Text(content: 'x')).egestFullCborMap();
      final content = cbor[CborSmallInt(100)];
      expect(content, isA<CborList>());
      expect((content as CborList)[0], CborSmallInt(pkindText));
    });
  });
}
