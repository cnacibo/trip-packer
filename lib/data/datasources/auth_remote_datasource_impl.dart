import 'package:firebase_auth/firebase_auth.dart';
import 'auth_remote_datasource.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth firebaseAuth;

  AuthRemoteDataSourceImpl({required this.firebaseAuth});

  @override
  Future<String> signUp(String email, String password) async {
    try {
      final userCredential = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user?.uid ?? '';
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('Registration failed: $e');
    }
  }

  @override
  Future<String> signIn(String email, String password) async {
    try {
      final userCredential = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user?.uid ?? '';
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  @override
  Future<void> signOut() async {
    await firebaseAuth.signOut();
  }

  @override
  Future<String?> getCurrentUserId() async {
    return firebaseAuth.currentUser?.uid;
  }

  Exception _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return Exception('Email already registered');
      case 'invalid-email':
        return Exception('Invalid email format');
      case 'weak-password':
        return Exception('Password is too weak');
      case 'user-not-found':
      case 'wrong-password':
        return Exception('Invalid email or password');
      default:
        return Exception(e.message ?? 'Authentication error');
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    return firebaseAuth.currentUser != null;
  }

}