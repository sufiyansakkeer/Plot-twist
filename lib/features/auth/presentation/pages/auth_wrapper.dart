import 'package:flutter/material.dart';
import 'package:plot_twist/features/auth/presentation/pages/auth_page.dart'; //added import
import 'package:plot_twist/features/plot_twist/data/repositories/plot_twist_repository_impl.dart';
import 'package:plot_twist/features/plot_twist/presentation/pages/home_screen.dart'; //corrected import
import 'package:plot_twist/features/auth/presentation/bloc/auth_service.dart';
import 'package:plot_twist/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:plot_twist/features/auth/data/datasources/auth_firebase_datasource.dart';
import 'package:plot_twist/features/auth/domain/usecases/sign_in_with_email_and_password.dart';
import 'package:plot_twist/features/auth/domain/usecases/create_user_with_email_and_password.dart';
import 'package:plot_twist/features/auth/domain/usecases/sign_out.dart';
import 'package:provider/provider.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    // Create dependencies
    final authDataSource = AuthFirebaseDataSourceImpl();
    final authRepository = AuthRepositoryImpl(
      firebaseDataSource: authDataSource,
    );
    final signInUseCase = SignInWithEmailAndPassword(authRepository);
    final createUserUseCase = CreateUserWithEmailAndPassword(authRepository);
    final signOutUseCase = SignOut(authRepository);

    // Create AuthService with all dependencies
    final authService = AuthService(
      repository: authRepository,
      signInUseCase: signInUseCase,
      createUserUseCase: createUserUseCase,
      signOutUseCase: signOutUseCase,
    );

    return Provider<AuthService>(
      create: (_) => authService,
      child: StreamBuilder(
        stream: authService.authStateChanges,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return HomeScreen(repository: PlotTwistRepositoryImpl());
          }
          return const AuthPage();
        },
      ),
    );
  }
}
