import '../entities/user_profile.dart';

abstract class UserProfileRepository {
  Future<UserProfile?> getProfile();
  Stream<UserProfile?> watchProfile();
  Future<bool> upsertProfile(UserProfile profile);
  Future<bool> clearAvatar();
}
