import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:roam_flutter/roam_flutter.dart';

void main() {
  const MethodChannel channel = MethodChannel('roam_flutter');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    // ignore: deprecated_member_use
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    // ignore: deprecated_member_use
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await Roam.platformVersion, '42');
  });
}
