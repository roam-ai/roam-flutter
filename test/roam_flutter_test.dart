import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:roam_flutter/roam_flutter.dart';

void main() {
  const MethodChannel channel = MethodChannel('roam_flutter');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await RoamFlutter.platformVersion, '42');
  });
}
