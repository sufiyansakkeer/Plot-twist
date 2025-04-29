import 'package:firebase_auth/firebase_auth.dart';
import 'package:plot_twist/features/auth/data/datasources/auth_firebase_datasource.dart';
import 'package:plot_twist/features/auth/domain/repositories/auth_repository.dart';

// Implementation of the AuthRepository
class AuthRepositoryImpl implements AuthRepository {
  final AuthFirebaseDataSource firebaseDataSource;

  AuthRepositoryImpl({required this.firebaseDataSource});

  @override
  Stream<User?> get authStateChanges => firebaseDataSource.authStateChanges;

  @override
  User? get currentUser => firebaseDataSource.currentUser;

  @override
  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    // Repository can add error handling or data mapping if needed
    try {
      return await firebaseDataSource.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException {
      // Re-throw specific Firebase exceptions or map to custom domain errors
      rethrow;
    } catch (e) {
      // Map other exceptions to custom domain errors
      throw Exception('Authentication failed: $e');
    }
  }

  @override
  Future<UserCredential> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      return await firebaseDataSource.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException {
      rethrow;
    } catch (e) {
      throw Exception('Registration failed: $e');
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await firebaseDataSource.signOut();
    } catch (e) {
      throw Exception('Sign out failed: $e');
    }
  }
}
