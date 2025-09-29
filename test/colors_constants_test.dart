import 'package:flutter_test/flutter_test.dart';
import 'package:inkboard/core/theme/facebook_colors.dart';

void main() {
  test('FacebookColors 常量值校验', () {
    expect(FacebookColors.primary.toARGB32(), 0xFF1877F2);
    expect(FacebookColors.background.toARGB32(), 0xFFF0F2F5);
    expect(FacebookColors.textPrimary.toARGB32(), 0xFF050505);
    expect(FacebookColors.success.toARGB32(), 0xFF42B883);
    expect(FacebookColors.error.toARGB32(), 0xFFE41E3F);
    expect(FacebookColors.iconGray.toARGB32(), 0xFF8A8D91);
    // 更多常量覆盖
    expect(FacebookColors.primaryHover.toARGB32(), 0xFF166FE5);
    expect(FacebookColors.primaryPressed.toARGB32(), 0xFF1464CC);
    expect(FacebookColors.surface.toARGB32(), 0xFFFFFFFF);
    expect(FacebookColors.surfaceHover.toARGB32(), 0xFFF7F8FA);
    expect(FacebookColors.border.toARGB32(), 0xFFE4E6EA);
    expect(FacebookColors.divider.toARGB32(), 0xFFDDDFE2);
    expect(FacebookColors.textSecondary.toARGB32(), 0xFF65676B);
    expect(FacebookColors.textDisabled.toARGB32(), 0xFFBCC0C4);
    expect(FacebookColors.textOnPrimary.toARGB32(), 0xFFFFFFFF);
    expect(FacebookColors.shadow.toARGB32(), 0x1A000000);
    expect(FacebookColors.shadowLight.toARGB32(), 0x0D000000);
    expect(FacebookColors.shadowDark.toARGB32(), 0x33000000);
    expect(FacebookColors.online.toARGB32(), 0xFF44D362);
    expect(FacebookColors.away.toARGB32(), 0xFFFFB800);
    expect(FacebookColors.offline.toARGB32(), 0xFFBCC0C4);
  });
}
