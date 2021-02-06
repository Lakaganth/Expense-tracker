import 'package:firebase_auth/firebase_auth.dart';
import 'package:fleming_expense_tracker/model/user_model.dart';
import 'package:fleming_expense_tracker/screens/1.splash_screens/onboarding_screen.dart';
import 'package:fleming_expense_tracker/screens/3.dashboard/dashboard_tab_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

class AuthController extends GetxController {
  static AuthController to = Get.find();

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

// Instantiating Auth and DB
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

// Observable for Auth user and DB user
  Rx<User> firebaseUser = Rx<User>();
  Rx<UserModel> firestoreUser = Rx<UserModel>();

  @override
  void onReady() async {
    //run everytime auth state changes

    ever(firebaseUser, handleAuthChanged);
    firebaseUser.value = await getUser;
    firebaseUser.bindStream(user);
    super.onInit();
  }

  // @override
  // void onClose() {
  //   nameController?.dispose();
  //   emailController?.dispose();
  //   passwordController?.dispose();
  //   super.onClose();
  // }

  void handleAuthChanged(User _firebaseUser) async {
    //Get user data from firestore
    if (_firebaseUser?.uid != null) {
      firestoreUser.bindStream(streamFirestoreUser());
    }
    if (_firebaseUser == null) {
      Get.offAll(OnboardingScreen());
    } else {
      Get.offAll(DashboardTabScreen());
    }
  }

  // Firebase user one-time fetch
  Future<User> get getUser async => _auth.currentUser;

  // Firebase user a realtime stream
  Stream<User> get user => _auth.authStateChanges();

  Stream<UserModel> streamFirestoreUser() {
    print('This from stream Firestore user');
    if (firebaseUser?.value?.uid != null) {
      return _db
          .doc('/users/${firebaseUser.value.uid}')
          .snapshots()
          .map((snapshot) => UserModel.fromMap(snapshot.data()));
    }
    return null;
  }

  // Fetch the Firestore User from Firestore collection
  Future<UserModel> getFirestoreUser() {
    if (firebaseUser?.value?.uid != null) {
      return _db.doc('/users/${firebaseUser.value.uid}').get().then(
          (documentSnapshot) => UserModel.fromMap(documentSnapshot.data()));
    }
    return null;
  }

  signInWithEmailAndPassword() async {
    try {
      await _auth.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());
      emailController.clear();
      passwordController.clear();
    } catch (err) {
      Get.snackbar(
        "Authentication Error", err.message,
        snackPosition: SnackPosition.TOP,
        duration: Duration(seconds: 4),
        // backgroundColor: Get.theme.snackBarTheme.backgroundColor,
        // colorText: Get.theme.snackBarTheme.actionTextColor,
      );
    }
  }

  registerWithEmailAndPassword() async {
    try {
      await _auth
          .createUserWithEmailAndPassword(
              email: emailController.text, password: passwordController.text)
          .then((result) async {
        print('uID: ' + result.user.uid);
        print('email: ' + result.user.email);

        //create the new user object
        UserModel _newUser = UserModel(
          uid: result.user.uid,
          email: result.user.email.trim(),
          name: nameController.text.trim(),
          searchKey: nameController.text[0].toLowerCase(),
        );
        //create the user in firestore
        _createUserFirestore(_newUser, result.user);
        emailController.clear();
        passwordController.clear();
      });
    } catch (error) {
      Get.snackbar("User creation error", error.message,
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 10),
          backgroundColor: Get.theme.snackBarTheme.backgroundColor,
          colorText: Get.theme.snackBarTheme.actionTextColor);
    }
  }

  //create the firestore user in users collection
  void _createUserFirestore(UserModel user, User _firebaseUser) {
    _db.doc('/users/${_firebaseUser.uid}').set(user.toJson());
    update();
  }

  // Sign out
  Future<void> signOut() {
    nameController.clear();
    emailController.clear();
    passwordController.clear();
    return _auth.signOut();
  }
}
