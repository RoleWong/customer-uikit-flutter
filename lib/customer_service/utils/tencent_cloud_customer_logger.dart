import 'dart:io';

import 'package:opentelemetry/api.dart' as otApi;
import 'package:opentelemetry/sdk.dart';

class TencentCloudCustomerLogger {
  static final TencentCloudCustomerLogger _instance = TencentCloudCustomerLogger._internal();

  TencentCloudCustomerLogger._internal();

  factory TencentCloudCustomerLogger() {
    return _instance;
  }

  TracerProviderBase? _tracerProvider;
  otApi.Tracer? _tracer;
  bool _initialized = false;

  void init() {
    if(_initialized){
      return;
    }
    final resource = Resource([
      otApi.Attribute.fromString('service.name', 'flutter-customer'),
      otApi.Attribute.fromString('tps.tenant.id', 'tccc'),
    ]);

    _tracerProvider = TracerProviderBase(
      processors: [
        BatchSpanProcessor(
          CollectorExporter(
            Uri.parse('https://tpstelemetry.tencent.com/v1/traces'),
            headers: {
              'X-Tps-Tenantid': 'tccc',
            },
          ),
        ),
        SimpleSpanProcessor(ConsoleExporter())
      ],
      resource: resource,
    );

    otApi.registerGlobalTracerProvider(_tracerProvider!);
    _tracer = otApi.globalTracerProvider.getTracer('tencent-cloud-customer-flutter');
    _initialized = true;
  }

  void reportSpan(String name, {List<otApi.Attribute>? attributes}) {
    if (_tracer == null) {
      init();
    }
    final span = _tracer!.startSpan(name, attributes: attributes ?? []);
    try {
      span.addEvent(name, attributes: attributes ?? []);
    } catch (e, s) {
      span
        ..setStatus(otApi.StatusCode.error, e.toString())
        ..recordException(e, stackTrace: s);
      rethrow;
    } finally {
      span.end();
    }
  }

  void reportLogin({
    required int sdkAppId,
    required String userID,
    required String userSig,
  }) {
    final platform = Platform.isIOS ? 'iOS' : (Platform.isAndroid ? 'Android' : 'Unknown');

    final attributes = [
      otApi.Attribute.fromString('client.environment', 'Flutter'),
      otApi.Attribute.fromString('client.module', 'CustomerClient'),
      otApi.Attribute.fromString('client.platform', platform),
      otApi.Attribute.fromString('client.sdkAppId', sdkAppId.toString()),
      otApi.Attribute.fromString('client.userId', userID),
      otApi.Attribute.fromString('client.userSig', userSig),
      otApi.Attribute.fromString('telemetry.sdk.language', 'Dart'),
      otApi.Attribute.fromString('client.version', '2.4.0'),
    ];

    final logMessage =
        'Tencent Cloud Customer loginWithSdkAppID: $sdkAppId, userID: $userID, and userSig: $userSig';

    reportSpan(
      'Login to Customer UIKit',
      attributes: [
        ...attributes,
        otApi.Attribute.fromString('log.message', logMessage),
      ],
    );
  }
}
