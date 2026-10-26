import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../models/user_model.dart';

class MockAuthRepositoryImpl implements AuthRepository {
  UserModel? _currentUser;

  @override
  Future<UserEntity> login(String email, String password) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    if (email == 'demo@alnajm.com' && password == '123456') {
      _currentUser = UserModel(
        id: 'user_123',
        email: email,
        fullName: 'Demo User',
        isVerified: true,
      );
      return _currentUser!;
    }

    throw Exception('Invalid credentials');
  }

  @override
  Future<UserEntity> register({
    required String fullName,
    required String email,
    required String password,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    _currentUser = UserModel(
      id: 'user_new_${DateTime.now().millisecondsSinceEpoch}',
      email: email,
      fullName: fullName,
      isVerified: false,
    );

    return _currentUser!;
  }

  @override
  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _currentUser = null;
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    return _currentUser;
  }
}
