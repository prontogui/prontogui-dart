// Copyright 2024-2026 ProntoGUI, LLC
// ProntoGUI™ is a trademark of ProntoGUI, LLC
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
//
// Cross-library wire samples (app_core/specs/wire-samples.json). golib writes
// the server -> App samples, which this test decodes; dartlib (the App side)
// writes the App -> server sample. To rewrite it after an intended wire change:
//
//   PG_WRITE_WIRE_SAMPLES=1 flutter test test/wire_samples_test.dart
import 'dart:convert';
import 'dart:io';

import 'package:cbor/cbor.dart';
import 'package:prontogui/prontogui.dart';
import 'package:test/test.dart';

final _file = File('../app_core/specs/wire-samples.json');

Map<String, dynamic> _read() =>
    jsonDecode(_file.readAsStringSync()) as Map<String, dynamic>;

List<int> _hexToBytes(String hex) => [
      for (var i = 0; i < hex.length; i += 2)
        int.parse(hex.substring(i, i + 2), radix: 16)
    ];

String _bytesToHex(List<int> b) =>
    b.map((x) => x.toRadixString(16).padLeft(2, '0')).join();

CborValue _sample(Map<String, dynamic> ws, String name) => cbor.decode(
    _hexToBytes((ws['samples'] as Map<String, dynamic>)[name]['hex']
        as String));

/// The App's notification path in miniature: queue each notification for
/// the next partial update (app_core's NotificationSynchro, minus the timing).
class _AppSynchro extends UpdateSynchro implements NotificationWatcher {
  _AppSynchro(PrimitiveLocator locator) : super(locator, null, false, true);

  @override
  void onNotify(PKey pkey, int notificationType) =>
      queueNotification(pkey, notificationType);
}

void main() {
  final skip = _file.existsSync() ? null : 'wire samples not checked out';

  group('wire samples', () {
    late PrimitiveModel model;
    late View view;

    setUp(() {
      final ws = _read();
      model = PrimitiveModel();
      model.ingestCborUpdate(_sample(ws, 'server_full'));
      view = model.topPrimitives.single as View;
    });

    test('decodes server_full', () {
      expect(view.title, 'Main');
      final items = view.items;
      final button = items[0] as Button;
      expect(button.label, 'Save');
      expect(button.style, ButtonStyle.outlined);
      expect(button.paddingAll, 12.0);
      expect(button.paddingTop, 0.0); // set to 0 - not unset
      expect(button.paddingBottom, isNull);
      expect(button.isNotificationHandled(Notify.press), isTrue);
      final text = items[1] as Text;
      expect(text.content, 'hi');
      expect(text.fontWeight, FontWeight.bold);
      expect(text.fontColor?.value, 0xFF112233);
      expect((items[2] as TextField).isNotificationHandled(Notify.submit),
          isTrue);
      final nf = items[3] as NumericField;
      expect(nf.numericEntry, '3.5');
      expect(nf.minValue, 0.0);
      expect(nf.displayDecimalPlaces, 2);
      final table = items[4] as StaticTable;
      expect((table.rows[0][1] as Text).content, 'b');
      expect(table.insideBorderAll, 1.0);
      expect(((items[5] as Card).mainItem as Text).content, 'm');
      final choice = items[6] as Choice;
      expect(choice.choice, 'y');
      expect(choice.choices, ['x', 'y']);
      final img = items[7] as Image;
      expect(img.image, [1, 2]);
      expect(img.imageFit, ImageFit.fill);
      final dt = items[8] as DataTable;
      expect(dt.selectedRows, [1]);
      expect((dt.rows[1][0] as Text).content, 'r1');
    });

    test('decodes server_partial', () {
      model.ingestCborUpdate(_sample(_read(), 'server_partial'));
      final button = view.items[0] as Button;
      expect(button.label, 'Saved');
      expect(button.paddingTop, isNull); // CBOR null = unset
      expect(button.paddingAll, 12.0);
      expect((view.items[5] as Card).mainItem, isNull);
      expect((view.items[1] as Text).fontSize, 14.5);
    });

    test('app_partial', () {
      final synchro = _AppSynchro(model);
      model.addWatcher(synchro);
      final items = view.items;
      final tf = items[2] as TextField;
      final nf = items[3] as NumericField;
      final dt = items[8] as DataTable;
      final button = items[0] as Button;

      tf.textEntry = 'abc';
      tf.notify(Notify.change);
      tf.notify(Notify.submit);
      nf.numericEntry = '4';
      nf.notify(Notify.change);
      dt.selectedRows = [0];
      dt.notify(Notify.selectionChange);
      button.notify(Notify.press);
      final bytes = cbor.encode(synchro.getPartialUpdate());

      if (Platform.environment['PG_WRITE_WIRE_SAMPLES'] != null) {
        final ws = _read();
        (ws['samples'] as Map<String, dynamic>)['app_partial'] = {
          'producer': 'dartlib',
          'doc': 'Against server_full: text_field text_entry "abc" + Change + '
              'Submit; numeric_field numeric_entry "4" + Change; data_table '
              'selected_rows [0] + SelectionChange; button Press.',
          'hex': _bytesToHex(bytes),
        };
        _file.writeAsStringSync(
            '${const JsonEncoder.withIndent('  ').convert(ws)}\n');
        return;
      }
      // Decoded comparison: map key order is not part of the contract.
      expect(cbor.decode(bytes).toObject(),
          _sample(_read(), 'app_partial').toObject());
    });
  }, skip: skip);
}
