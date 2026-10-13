// This is a generated file - do not edit.
//
// Generated from proto/pg.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'package:protobuf/protobuf.dart' as $pb;

import 'pg.pb.dart' as $0;

export 'pg.pb.dart';

/// A simple symetric service that can be implemented by either the service or app or both.  This
/// service streams updates bidirectionally between both sides.
@$pb.GrpcServiceName('PGService')
class PGServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  PGServiceClient(super.channel, {super.options, super.interceptors});

  $grpc.ResponseStream<$0.PGUpdate> streamUpdates(
    $async.Stream<$0.PGUpdate> request, {
    $grpc.CallOptions? options,
  }) {
    return $createStreamingCall(_$streamUpdates, request, options: options);
  }

  // method descriptors

  static final _$streamUpdates = $grpc.ClientMethod<$0.PGUpdate, $0.PGUpdate>(
      '/PGService/StreamUpdates',
      ($0.PGUpdate value) => value.writeToBuffer(),
      $0.PGUpdate.fromBuffer);
}

@$pb.GrpcServiceName('PGService')
abstract class PGServiceBase extends $grpc.Service {
  $core.String get $name => 'PGService';

  PGServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.PGUpdate, $0.PGUpdate>(
        'StreamUpdates',
        streamUpdates,
        true,
        true,
        ($core.List<$core.int> value) => $0.PGUpdate.fromBuffer(value),
        ($0.PGUpdate value) => value.writeToBuffer()));
  }

  $async.Stream<$0.PGUpdate> streamUpdates(
      $grpc.ServiceCall call, $async.Stream<$0.PGUpdate> request);
}
