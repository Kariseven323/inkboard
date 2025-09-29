import 'dart:typed_data';

/// 用户资料实体
class UserProfile {
  final int id;
  final Uint8List? avatar;
  final String? nickname;
  final String? signature;
  final String? gender; // male/female/other
  final DateTime? birthday;
  final String? region;
  final String? email;
  final DateTime? updatedAt;

  const UserProfile({
    this.id = 1,
    this.avatar,
    this.nickname,
    this.signature,
    this.gender,
    this.birthday,
    this.region,
    this.email,
    this.updatedAt,
  });

  UserProfile copyWith({
    Uint8List? avatar,
    String? nickname,
    String? signature,
    String? gender,
    DateTime? birthday,
    String? region,
    String? email,
    DateTime? updatedAt,
  }) {
    return UserProfile(
      id: id,
      avatar: avatar ?? this.avatar,
      nickname: nickname ?? this.nickname,
      signature: signature ?? this.signature,
      gender: gender ?? this.gender,
      birthday: birthday ?? this.birthday,
      region: region ?? this.region,
      email: email ?? this.email,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

