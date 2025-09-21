import 'package:flutter_test/flutter_test.dart';
import 'package:inkboard/core/di/service_locator.dart';
import 'package:inkboard/core/services/app_config_service.dart';

void main() {
  test('DI 注册与获取 AppConfigService', () {
    configureDependencies();
    final cfg = getIt<AppConfigService>();
    expect(cfg.appName, '砚记 (Inkboard)');
    expect(cfg.version, '1.0.0');

    // init 可调用（当前为空实现）
    cfg.init();
  });
}

