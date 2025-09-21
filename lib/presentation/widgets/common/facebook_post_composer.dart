import 'package:flutter/material.dart';
import '../../../core/theme/facebook_colors.dart';
import '../../../core/theme/facebook_sizes.dart';
import '../../../core/theme/facebook_text_styles.dart';

/// Facebook风格的发布输入组件
/// 模拟Facebook的"你在想什么？"输入框
class FacebookPostComposer extends StatefulWidget {
  final String? placeholder;
  final VoidCallback? onTap;
  final VoidCallback? onPhotoTap;
  final VoidCallback? onVideoTap;
  final VoidCallback? onLocationTap;
  final VoidCallback? onMoodTap;

  const FacebookPostComposer({
    super.key,
    this.placeholder,
    this.onTap,
    this.onPhotoTap,
    this.onVideoTap,
    this.onLocationTap,
    this.onMoodTap,
  });

  @override
  State<FacebookPostComposer> createState() => _FacebookPostComposerState();
}

class _FacebookPostComposerState extends State<FacebookPostComposer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: FacebookSizes.spacing16),
      child: Card(
        elevation: FacebookSizes.cardElevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(FacebookSizes.radiusLarge),
          side: const BorderSide(
            color: FacebookColors.border,
            width: 1,
          ),
        ),
        child: Padding(
          padding: FacebookSizes.paddingAll,
          child: Column(
            children: [
              // 主要输入区域
              _buildMainInputArea(),

              // 分割线
              Divider(
                height: FacebookSizes.spacing24,
                thickness: FacebookSizes.dividerThickness,
                color: FacebookColors.divider,
              ),

              // 功能按钮行
              _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  /// 构建主要输入区域
  Widget _buildMainInputArea() {
    return InkWell(
      onTap: widget.onTap,
      borderRadius: BorderRadius.circular(FacebookSizes.radiusLarge),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: FacebookSizes.spacing12,
          vertical: FacebookSizes.spacing12,
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final avatar = CircleAvatar(
              radius: FacebookSizes.avatarMedium / 2,
              backgroundColor: FacebookColors.primary,
              child: Icon(
                Icons.person,
                color: FacebookColors.textOnPrimary,
                size: FacebookSizes.iconMedium,
              ),
            );

            final input = Container(
              padding: EdgeInsets.symmetric(
                horizontal: FacebookSizes.spacing16,
                vertical: FacebookSizes.spacing12,
              ),
              decoration: BoxDecoration(
                color: FacebookColors.inputBackground,
                borderRadius: BorderRadius.circular(FacebookSizes.radiusRound),
                border: Border.all(
                  color: FacebookColors.inputBorder,
                  width: 1,
                ),
              ),
              child: Text(
                widget.placeholder ?? '今天你想记录什么？',
                style: FacebookTextStyles.placeholder.copyWith(
                  color: FacebookColors.iconGray,
                ),
              ),
            );

            // 特别窄的情况下，改用垂直布局避免溢出
            if (constraints.maxWidth < (FacebookSizes.avatarMedium + FacebookSizes.spacing12 + 120)) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(child: avatar),
                  SizedBox(height: FacebookSizes.spacing12),
                  input,
                ],
              );
            }

            // 正常桌面/平板/手机宽度使用水平布局
            return Row(
              children: [
                avatar,
                SizedBox(width: FacebookSizes.spacing12),
                Expanded(child: input),
              ],
            );
          },
        ),
      ),
    );
  }

  /// 构建功能按钮行
  Widget _buildActionButtons() {
    return LayoutBuilder(
      builder: (context, constraints) {
        // 窄宽度下采用纵向排列，避免Row溢出
        if (constraints.maxWidth < 260) {
          return Column(
            children: [
              _buildActionButton(
                icon: Icons.photo_library_outlined,
                label: '照片/视频',
                color: const Color(0xFF45BD62),
                onTap: widget.onPhotoTap,
                compact: constraints.maxWidth < 120,
              ),
              SizedBox(height: FacebookSizes.spacing8),
              _buildActionButton(
                icon: Icons.mood_outlined,
                label: '心情',
                color: const Color(0xFFF7B928),
                onTap: widget.onMoodTap,
                compact: constraints.maxWidth < 120,
              ),
              SizedBox(height: FacebookSizes.spacing8),
              _buildActionButton(
                icon: Icons.location_on_outlined,
                label: '位置',
                color: const Color(0xFFE7453D),
                onTap: widget.onLocationTap,
                compact: constraints.maxWidth < 120,
              ),
            ],
          );
        }

        // 正常宽度下使用水平三等分
        return Row(
          children: [
            Expanded(
              child: _buildActionButton(
                icon: Icons.photo_library_outlined,
                label: '照片/视频',
                color: const Color(0xFF45BD62),
                onTap: widget.onPhotoTap,
              ),
            ),
            SizedBox(width: FacebookSizes.spacing8),
            Expanded(
              child: _buildActionButton(
                icon: Icons.mood_outlined,
                label: '心情',
                color: const Color(0xFFF7B928),
                onTap: widget.onMoodTap,
              ),
            ),
            SizedBox(width: FacebookSizes.spacing8),
            Expanded(
              child: _buildActionButton(
                icon: Icons.location_on_outlined,
                label: '位置',
                color: const Color(0xFFE7453D),
                onTap: widget.onLocationTap,
              ),
            ),
          ],
        );
      },
    );
  }

  /// 构建单个功能按钮
  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    VoidCallback? onTap,
    bool compact = false,
  }) {
    return Material(
      color: Colors.transparent,
      child: LayoutBuilder(builder: (context, constraints) {
        final isCompact = compact || constraints.maxWidth < 120;
        return InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(FacebookSizes.radiusLarge),
          child: Container(
            padding: isCompact
                ? const EdgeInsets.all(6)
                : EdgeInsets.symmetric(
                    horizontal: FacebookSizes.spacing8,
                    vertical: FacebookSizes.spacing8,
                  ),
            child: isCompact
                ? Center(
                    child: Icon(
                      icon,
                      color: color,
                      size: 18.0,
                    ),
                  )
                : Wrap(
                    alignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: FacebookSizes.spacing8,
                    children: [
                      Icon(
                        icon,
                        color: color,
                        size: FacebookSizes.iconMedium,
                      ),
                      Text(
                        label,
                        style: FacebookTextStyles.bodySmall.copyWith(
                          color: FacebookColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
          ),
        );
      }),
    );
  }
}
