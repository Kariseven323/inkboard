import 'package:equatable/equatable.dart';

/// 标签实体
class Tag extends Equatable {
  /// 主键ID
  final int? id;

  /// 标签名称
  final String name;

  /// 标签颜色 (HEX格式，如 #FF5722)
  final String color;

  /// 创建时间
  final DateTime createdAt;

  /// 使用次数
  final int usageCount;

  /// 标签描述
  final String? description;

  const Tag({
    this.id,
    required this.name,
    required this.color,
    required this.createdAt,
    this.usageCount = 0,
    this.description,
  });

  /// 创建副本
  Tag copyWith({
    int? id,
    String? name,
    String? color,
    DateTime? createdAt,
    int? usageCount,
    String? description,
  }) {
    return Tag(
      id: id ?? this.id,
      name: name ?? this.name,
      color: color ?? this.color,
      createdAt: createdAt ?? this.createdAt,
      usageCount: usageCount ?? this.usageCount,
      description: description ?? this.description,
    );
  }

  /// 是否为默认标签（系统预设）
  bool get isDefault => _defaultTagNames.contains(name);

  /// 默认标签名称列表
  static const _defaultTagNames = ['工作', '生活', '学习', '思考', '旅行'];

  /// 获取颜色的Color对象
  // Color get colorValue => Color(int.parse(color.substring(1, 7), radix: 16) + 0xFF000000);

  @override
  List<Object?> get props => [
    id,
    name,
    color,
    createdAt,
    usageCount,
    description,
  ];
}
