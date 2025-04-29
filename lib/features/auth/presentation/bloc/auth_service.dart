import 'package:firebase_auth/firebase_auth.dart';
import 'package:plot_twist/features/auth/domain/repositories/auth_repository.dart';
import 'package:plot_twist/features/auth/domain/usecases/create_user_with_email_and_password.dart';
import 'package:plot_twist/features/auth/domain/usecases/sign_in_with_email_and_password.dart';
import 'package:plot_twist/features/auth/domain/usecases/sign_out.dart';

class AuthService {
  final AuthRepository repository;
  final SignInWithEmailAndPassword signInUseCase;
  final CreateUserWithEmailAndPassword createUserUseCase;
  final SignOut signOutUseCase;

  AuthService({
    required this.repository,
    required this.signInUseCase,
    required this.createUserUseCase,
    required this.signOutUseCase,
  });

  // Use case getters
  SignInWithEmailAndPassword get signInWithEmailAndPassword => signInUseCase;
  CreateUserWithEmailAndPassword get createUserWithEmailAndPassword =>
      createUserUseCase;
  SignOut get signOut => signOutUseCase;

  // Auth state streams and current user
  Stream<User?> get authStateChanges => repository.authStateChanges;
  User? get currentUser => repository.currentUser;

  // Authentication methods
  Future<UserCredential> authenticateWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    return await signInUseCase(email: email, password: password);
  }

  Future<UserCredential> registerWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    return await createUserUseCase(email: email, password: password);
  }

  Future<void> logout() async {
    return await signOutUseCase();
  }
}
