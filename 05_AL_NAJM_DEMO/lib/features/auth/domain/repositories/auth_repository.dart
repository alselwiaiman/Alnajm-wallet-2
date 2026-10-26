import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<UserEntity> login(String email, String password);
  Future<UserEntity> register({
    required String fullName,
    required String email,
    required String password,
  });
  Future<void> logout();
  Future<UserEntity?> getCurrentUser();
}
