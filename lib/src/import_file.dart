// Copyright 2024-2026 ProntoGUI, LLC
// ProntoGUI™ is a trademark of ProntoGUI, LLC
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'dart:typed_data';
import 'blob_field.dart';
import 'primitive_base.dart';
import 'notification.dart';
import 'text_style_fields.dart';
import 'boolean_field.dart';
import 'string_field.dart';
import 'strings1d_field.dart';
import 'integer_field.dart';
import 'color.dart';
import 'enums.dart';
import 'fkey.dart';

/// A file that represents a blob of data that can be imported from the app side
/// and consumed on the server side.
class ImportFile extends PrimitiveBase with TextStyleFieldsMixin {
  ImportFile(
      {super.tag,
      super.backgroundColor,
      super.borderAll,
      super.borderBottom,
      super.borderColor,
      super.borderLeft,
      super.borderRight,
      super.borderTop,
      super.bottom,
      super.height,
      super.horizontalAlignment,
      super.left,
      super.marginAll,
      super.marginBottom,
      super.marginLeft,
      super.marginRight,
      super.marginTop,
      super.paddingAll,
      super.paddingBottom,
      super.paddingLeft,
      super.paddingRight,
      super.paddingTop,
      super.right,
      super.top,
      super.verticalAlignment,
      super.width,
      Color? fontColor,
      String? fontFamily,
      double? fontSize,
      FontStyle? fontStyle,
      FontWeight? fontWeight,
      HorizontalTextAlignment? horizontalTextAlignment,
      VerticalTextAlignment? verticalTextAlignment,
      Uint8List? data,
      bool completed = false,
      String name = '',
      List<String> validExtensions = const [],
      int status = 0}) {
    _completed = BooleanField.from(completed);
    _data = BlobField();
    if (data != null) {
      _data.value = data;
    }
    _name = StringField.from(name);
    _validExtensions = Strings1DField.from(validExtensions);
    _status = IntegerField.from(status);

    this.fontColor = fontColor;
    this.fontFamily = fontFamily;
    this.fontSize = fontSize;
    this.fontStyle = fontStyle;
    this.fontWeight = fontWeight;
    this.horizontalTextAlignment = horizontalTextAlignment;
    this.verticalTextAlignment = verticalTextAlignment;
  }

  // Field storage
  late BooleanField _completed;
  late BlobField _data;
  late StringField _name;
  late Strings1DField _validExtensions;
  late IntegerField _status;

  // Server -> App bitmask of handled notifications (see Notify.bit).
  final _notificationsHandled = IntegerField();

  @override
  String get describeType => 'ImportFile';

  // Field keys for import_file's own fields (see firstOwnFKey in
  // fkey.dart). Fixed and append-only, matching golib field-for-field -
  // see fkey.dart's doc comment.
  static const _fkData = 100;
  static const _fkCompleted = 101;
  static const _fkName = 102;
  static const _fkValidExtensions = 103;

  @override
  void describeFields(List<FieldRef> fieldRefs) {
    fieldRefs.add(backgroundColorFieldRef());
    fieldRefs.add(borderAllFieldRef());
    fieldRefs.add(borderBottomFieldRef());
    fieldRefs.add(borderColorFieldRef());
    fieldRefs.add(borderLeftFieldRef());
    fieldRefs.add(borderRightFieldRef());
    fieldRefs.add(borderTopFieldRef());
    fieldRefs.add(bottomFieldRef());
    fieldRefs.add(FieldRef(_fkData, 'Data', _data));
    fieldRefs.add(fontColorFieldRef());
    fieldRefs.add(fontFamilyFieldRef());
    fieldRefs.add(fontSizeFieldRef());
    fieldRefs.add(fontStyleFieldRef());
    fieldRefs.add(fontWeightFieldRef());
    fieldRefs.add(heightFieldRef());
    fieldRefs.add(horizontalAlignmentFieldRef());
    fieldRefs.add(horizontalTextAlignmentFieldRef());
    fieldRefs.add(FieldRef(_fkCompleted, 'Completed', _completed));
    fieldRefs.add(leftFieldRef());
    fieldRefs.add(marginAllFieldRef());
    fieldRefs.add(marginBottomFieldRef());
    fieldRefs.add(marginLeftFieldRef());
    fieldRefs.add(marginRightFieldRef());
    fieldRefs.add(marginTopFieldRef());
    fieldRefs.add(FieldRef(_fkName, 'Name', _name));
    fieldRefs.add(FieldRef(
        fkNotificationsHandled, 'NotificationsHandled', _notificationsHandled));
    fieldRefs.add(paddingAllFieldRef());
    fieldRefs.add(paddingBottomFieldRef());
    fieldRefs.add(paddingLeftFieldRef());
    fieldRefs.add(paddingRightFieldRef());
    fieldRefs.add(paddingTopFieldRef());
    fieldRefs.add(rightFieldRef());
    fieldRefs.add(FieldRef(fkStatus, 'Status', _status));
    fieldRefs.add(tagFieldRef());
    fieldRefs.add(topFieldRef());
    fieldRefs
        .add(FieldRef(_fkValidExtensions, 'ValidExtensions', _validExtensions));
    fieldRefs.add(verticalAlignmentFieldRef());
    fieldRefs.add(verticalTextAlignmentFieldRef());
    fieldRefs.add(widthFieldRef());
  }

  @override
  String toString() {
    return _name.value;
  }

  @override
  bool isNotificationHandled(int notificationType) =>
      (_notificationsHandled.value & Notify.bit(notificationType)) != 0;

  /// Clears the imported data and the completed flag.
  void reset() {
    _data.value = Uint8List(0);
    _completed.value = false;
  }

  /// Sets the blob of data for the file, sets the name of the file, and sets
  /// completed flag to true.
  void importData(Uint8List data, String name) {
    _data.value = data;
    _name.value = name;
    _completed.value = true;
  }

  /// Returns true when the file has been imported by the app side and signals to the server
  /// side that file is ready to processs.  This field is normally only updated by the app.
  bool get completed => _completed.value;
  set completed(bool value) => _completed.value = value;

  /// The blob of data representing the binary contents of the file.  Note:  this
  /// data could be empty and yet represent a valid, albeit empty, file for export.
  Uint8List get data => _data.value;
  set data(Uint8List value) => _data.value = value;

  /// The suggested file name (including its extension separated by a period) to save the file as.
  String get name => _name.value;
  set name(String value) => _name.value = value;

  /// The list of valid file extensions that the file can be saved as.
  List<String> get validExtensions => _validExtensions.value;
  set validExtensions(List<String> value) => _validExtensions.value = value;

  /// The status of the primitive: 0 = Normal, 1 = Disabled, 2 = Hidden, 3 = Collapsed.
  ///
  /// Normal status: the primitive is visible and works as normal.
  /// Disabled status: the primitive is visible but is disable from user interaction.
  /// Hidden status: the primitive is hidden and disabled from user interaction. The
  ///    primitive stills takes up the same space on the screen.
  /// Collapsed: the primitive is hidden and disable from user interaction. It also
  ///    doesn't consume any space on the screen.
  int get status => _status.value;
  set status(int status) {
    _status.value = status;
  }

  /// The enabled status of the primitive. This is derived from the Status field.
  /// Setting this to true will set Status to 0 (visible & enabled)
  /// and setting this to false will set Status to 1 (disabled).
  ///
  /// Note: this is a helper method to make it easier to work with the status field.  The
  /// canonical storage is still with the status field.
  bool get enabled => status == 0;
  set enabled(bool enabled) {
    status = enabled ? 0 : 1;
  }

  /// The visibility of the primitive. This is derived from the Status field.
  /// Setting this to true will set Status to 0 (visible & enabled)and setting
  /// this to false will set Status to 2 (hidden).
  ///
  /// Note: this is a helper method to make it easier to work with the status field.  The
  /// canonical storage is still with the status field.
  bool get visible => status == 0 || status == 1;
  set visible(bool visible) {
    status = visible ? 0 : 2;
  }

  /// The hidden status of the primitive.  This is derived from the Status field.
  /// Setting this to true will set Status to 2 (hidden) and setting
  /// this to false will set Status to 0 (visible and enabled).
  ///
  /// Note: this is a helper method to make it easier to work with the status field.  The
  /// canonical storage is still with the status field.
  bool get hidden => status == 2;
  set hidden(bool hidden) {
    status = hidden ? 2 : 0;
  }

  /// The collapsed status of the primitive. This is derived from the Status field.
  /// Setting this to true will set Status to 3 (hidden & collapsed )and setting
  /// this to false will set Status to 0 (visible).
  ///
  /// Note: this is a helper method to make it easier to work with the status field.  The
  /// canonical storage is still with the status field.
  bool get collapsed => status == 3;
  set collapsed(bool collapsed) {
    status = collapsed ? 3 : 0;
  }
}
