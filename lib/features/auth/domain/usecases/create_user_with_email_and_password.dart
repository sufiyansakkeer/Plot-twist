import 'package:firebase_auth/firebase_auth.dart';
import 'package:plot_twist/features/auth/domain/repositories/auth_repository.dart';

class CreateUserWithEmailAndPassword {
  final AuthRepository repository;

  CreateUserWithEmailAndPassword(this.repository);

  Future<UserCredential> call({
    required String email,
    required String password,
  }) async {
    return await repository.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }
}
