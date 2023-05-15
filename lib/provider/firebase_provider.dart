import 'package:budget/repositorys/auth_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_database/firebase_database.dart';

final firestoreProvider = Provider((ref) => FirebaseFirestore.instance);
final firebaseProvider = Provider<FirebaseDatabase>((ref) {
  return FirebaseDatabase.instance;
});

final userProvider = Provider((ref) {
  return FirebaseAuth.instance.currentUser!.uid;
});

final authProvider = Provider<FirebaseAuth>((ref) => FirebaseAuth.instance);
final userStateProvider = StreamProvider((ref) {
  return ref.watch(authRepositoryImplProvider).authStateChanges();
});

final postsQueryProvider = StreamProvider.autoDispose((ref) {
  final instanse = ref.watch(firestoreProvider);
  return instanse.collection('').orderBy('date').snapshots();
});
