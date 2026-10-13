// Copyright 2024-2026 ProntoGUI, LLC
// ProntoGUI™ is a trademark of ProntoGUI, LLC
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'dart:typed_data';

import 'package:prontogui/prontogui.dart';
import 'references.dart';
import 'primitive_base.dart';
import 'blob_field.dart';
import 'string_field.dart';
import 'integer_field.dart';
import 'field_hooks.dart';
import 'opt_field.dart';

/// An image to display on the screen.  [fromFile] is the path to a file containing the image data.ArgumentError
/// The image can obtain its data from another Image in the primitive tree by specifying [ref], which is the ID
/// assigned to the image.  You can assign [id] if you intend to reference this image's data in another
/// Image primitive elsewhere.
class Image extends PrimitiveBase {
  Image(
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
      String? fromFile,
      Uint8List? image,
      ImageFit? imageFit,
      String id = '',
      String ref = '',
      int status = 0}) {
    if (fromFile != null) {
      _image = BlobField.fromFile(fromFile);
    } else {
      _image = BlobField();
      if (image != null) {
        _image.value = image;
      }
    }
    _id = StringField.from(id);
    _ref = StringField.from(ref);
    _status = IntegerField.from(status);
    this.imageFit = imageFit;
  }

  // Field storage
  late StringField _id;
  late BlobField _image;
  final _imageFit = EnumOptField<ImageFit>(ImageFit.values);
  late StringField _ref;
  late IntegerField _status;

  // Internal variables
  PrimitiveRef? _targetRef;
  PrimitiveLocator? _locator;

  @override
  String get describeType => 'Image';

  // Field keys for image's own fields (see firstOwnFKey in
  // fkey.dart). Fixed and append-only, matching golib field-for-field -
  // see fkey.dart's doc comment.
  static const _fkID = 100;
  static const _fkImage = 101;
  static const _fkRef = 102;
  static const _fkImageFit = 103;

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
    fieldRefs.add(heightFieldRef());
    fieldRefs.add(horizontalAlignmentFieldRef());
    fieldRefs.add(FieldRef(_fkID, 'ID', _id));
    fieldRefs.add(FieldRef(_fkImage, 'Image', _image));
    fieldRefs.add(FieldRef(_fkImageFit, 'ImageFit', _imageFit));
    fieldRefs.add(leftFieldRef());
    fieldRefs.add(marginAllFieldRef());
    fieldRefs.add(marginBottomFieldRef());
    fieldRefs.add(marginLeftFieldRef());
    fieldRefs.add(marginRightFieldRef());
    fieldRefs.add(marginTopFieldRef());
    fieldRefs.add(paddingAllFieldRef());
    fieldRefs.add(paddingBottomFieldRef());
    fieldRefs.add(paddingLeftFieldRef());
    fieldRefs.add(paddingRightFieldRef());
    fieldRefs.add(paddingTopFieldRef());
    fieldRefs.add(FieldRef(_fkRef, 'Ref', _ref));
    fieldRefs.add(rightFieldRef());
    fieldRefs.add(FieldRef(fkStatus, 'Status', _status));
    fieldRefs.add(tagFieldRef());
    fieldRefs.add(topFieldRef());
    fieldRefs.add(verticalAlignmentFieldRef());
    fieldRefs.add(widthFieldRef());
  }

  @override
  void prepareForUpdates(
      PKey pkey, FieldHooks fieldHooks, PrimitiveLocator locator) {
    super.prepareForUpdates(pkey, fieldHooks, locator);

    _locator = locator;

    // Any referencing going on?
    if (id.isNotEmpty) {
      _targetRef = References().defineTarget(id, pkey);
    }
  }

  @override
  void unprepareForUpdates() {
    super.unprepareForUpdates();

    var targetRef = _targetRef;
    if (targetRef != null) {
      References().undefineTarget(targetRef);
    }
    _targetRef = null;
    _locator = null;
  }

  @override
  String toString() {
    return '';
  }

  static final _emptyImage = Uint8List.fromList([]);

  /// The image data.  If there is no image data available then an empty list is returned.
  Uint8List get image {
    if (_image.value.isNotEmpty) {
      return _image.value;
    }

    var imageRef = ref;

    if (imageRef.isNotEmpty) {
      var p = References().dereference(imageRef, _locator!);

      // Reference primitive must be an Image and must not reference another Image
      // (this avoids cyclic references)
      if (p != null && p is Image && p.ref.isEmpty) {
        return p.image;
      }
    }

    return _emptyImage;
  }

  set image(Uint8List value) {
    _image.value = value;
  }

  /// How the image fills its bounds. Null means unset/default (fill).
  ImageFit? get imageFit => _imageFit.value;
  set imageFit(ImageFit? value) => _imageFit.value = value;

  /// Optional ID assigned to this primitive.
  String get id {
    return _id.value;
  }

  set id(String value) {
    _id.value = value;
  }

  /// Reference (ID) to a primitive that holds the actual image data.
  String get ref {
    return _ref.value;
  }

  set ref(String value) {
    _ref.value = value;
  }

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
