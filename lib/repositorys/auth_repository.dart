import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../provider/firebase_provider.dart';

final authRepositoryImplProvider = Provider<AuthRepository>(
  (ref) => AuthRepositoryImpl(ref.watch(authProvider)),
);

abstract class AuthRepository {
  User? get currentUser;
  Stream<User?> authStateChanges();

  Future<void> deleteUser() async {}
  Future<String?> signUp({
    required String email,
    required String password,
  });
  Future<void> signIn({
    required String email,
    required String password,
  });
  Future<void> sendPasswordResetEmail({required String email});

  Future<void> signOut() async {}
  Future<void> refreshUser(User user) async {}
}

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._auth);
  final FirebaseAuth _auth;

  @override
  User? get currentUser => _auth.currentUser;

  @override
  Stream<User?> authStateChanges() => _auth.authStateChanges();

  @override
  Future<void> deleteUser() async {
    await currentUser!.delete();
  }

  @override
  Future<String?> signUp({
    required String email,
    required String password,
  }) async {
    final userCredential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    return userCredential.user?.uid;
  }

  @override
  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  @override
  Future<void> sendPasswordResetEmail({required String email}) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  @override
  Future<void> signOut() async {
    await _auth.signOut();
  }

  @override
  Future<void> refreshUser(User user) async {
    await user.reload();
  }
}
