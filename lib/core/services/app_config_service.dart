import 'package:injectable/injectable.dart';

@injectable
class AppConfigService {
  String get appName => '砚记 (Inkboard)';
  String get version => '1.0.0';

  void init() {
    // 应用配置服务初始化逻辑
  }
}