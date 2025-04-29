import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

// Abstract class defining the data source contract
abstract class AuthFirebaseDataSource {
  Stream<User?> get authStateChanges;
  User? get currentUser;
  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  });
  Future<UserCredential> createUserWithEmailAndPassword({
    required String email,
    required String password,
  });
  Future<void> signOut();
}

// Implementation of the data source using FirebaseAuth
class AuthFirebaseDataSourceImpl implements AuthFirebaseDataSource {
  final FirebaseAuth _firebaseAuth;

  // Allow injecting FirebaseAuth for testing, otherwise use instance
  AuthFirebaseDataSourceImpl({FirebaseAuth? firebaseAuth})
    : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  @override
  User? get currentUser => _firebaseAuth.currentUser;

  @override
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  @override
  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      // Directly call Firebase method
      return await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      // Log and re-throw the specific exception for the repository layer to handle
      log('Firebase Auth Error during sign in: ${e.code} - ${e.message}');
      rethrow;
    } catch (e) {
      // Log and throw a generic exception for unexpected errors
      log('General Error during sign in: $e');
      throw Exception('Sign in failed: $e');
    }
  }

  @override
  Future<UserCredential> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      // Directly call Firebase method
      return await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      // Log and re-throw the specific exception
      log('Firebase Auth Error during sign up: ${e.code} - ${e.message}');
      rethrow;
    } catch (e) {
      // Log and throw a generic exception
      log('General Error during sign up: $e');
      throw Exception('Sign up failed: $e');
    }
  }

  @override
  Future<void> signOut() async {
    try {
      // Directly call Firebase method
      await _firebaseAuth.signOut();
    } catch (e) {
      // Log and throw a generic exception
      debugPrint('Error during sign out: $e');
      throw Exception('Sign out failed: $e');
    }
  }
}
