import 'package:equatable/equatable.dart';
import 'tag.dart';

/// 日记条目实体
class DiaryEntry extends Equatable {
  /// 主键ID
  final int? id;

  /// 日记标题
  final String title;

  /// 日记内容（Markdown格式）
  final String content;

  /// 创建时间
  final DateTime createdAt;

  /// 更新时间
  final DateTime updatedAt;

  /// 是否收藏
  final bool isFavorite;

  /// 心情评分 (1-5)
  final int? moodScore;

  /// 天气信息
  final String? weather;

  /// 位置信息
  final String? location;

  /// 关联的标签列表
  final List<Tag> tags;

  /// 是否草稿
  final bool isDraft;

  const DiaryEntry({
    this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    this.isFavorite = false,
    this.moodScore,
    this.weather,
    this.location,
    this.tags = const [],
    this.isDraft = false,
  });

  /// 创建副本
  DiaryEntry copyWith({
    int? id,
    String? title,
    String? content,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isFavorite,
    int? moodScore,
    String? weather,
    String? location,
    List<Tag>? tags,
    bool? isDraft,
  }) {
    return DiaryEntry(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isFavorite: isFavorite ?? this.isFavorite,
      moodScore: moodScore ?? this.moodScore,
      weather: weather ?? this.weather,
      location: location ?? this.location,
      tags: tags ?? this.tags,
      isDraft: isDraft ?? this.isDraft,
    );
  }

  /// 是否为空内容
  bool get isEmpty => title.trim().isEmpty && content.trim().isEmpty;

  /// 是否有标签
  bool get hasTags => tags.isNotEmpty;

  /// 获取内容摘要（前100个字符）
  String get excerpt {
    final plainText = content.replaceAll(RegExp(r'[#*_`\[\]()!-]'), '');
    if (plainText.length <= 100) return plainText;
    return '${plainText.substring(0, 97)}...';
  }

  /// 获取情绪描述
  String? get moodDescription {
    switch (moodScore) {
      case 1:
        return '很糟糕';
      case 2:
        return '不太好';
      case 3:
        return '一般';
      case 4:
        return '不错';
      case 5:
        return '很棒';
      default:
        return null;
    }
  }

  @override
  List<Object?> get props => [
    id,
    title,
    content,
    createdAt,
    updatedAt,
    isFavorite,
    moodScore,
    weather,
    location,
    tags,
    isDraft,
  ];
}
