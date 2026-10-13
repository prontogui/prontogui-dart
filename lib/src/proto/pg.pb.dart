// This is a generated file - do not edit.
//
// Generated from proto/pg.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

class PGUpdate extends $pb.GeneratedMessage {
  factory PGUpdate({
    $core.List<$core.int>? cbor,
  }) {
    final result = create();
    if (cbor != null) result.cbor = cbor;
    return result;
  }

  PGUpdate._();

  factory PGUpdate.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PGUpdate.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PGUpdate',
      createEmptyInstance: create)
    ..a<$core.List<$core.int>>(
        1, _omitFieldNames ? '' : 'cbor', $pb.PbFieldType.OY)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PGUpdate clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PGUpdate copyWith(void Function(PGUpdate) updates) =>
      super.copyWith((message) => updates(message as PGUpdate)) as PGUpdate;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PGUpdate create() => PGUpdate._();
  @$core.override
  PGUpdate createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PGUpdate getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PGUpdate>(create);
  static PGUpdate? _defaultInstance;

  /// CBOR encoded structure representing the update.
  @$pb.TagNumber(1)
  $core.List<$core.int> get cbor => $_getN(0);
  @$pb.TagNumber(1)
  set cbor($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCbor() => $_has(0);
  @$pb.TagNumber(1)
  void clearCbor() => $_clearField(1);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
