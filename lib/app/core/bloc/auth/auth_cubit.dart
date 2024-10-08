import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unlockme/app/core/model/usermodel.dart';

enum AuthState { initial, signedIn, signedOut, admin }

class AuthCubit extends Cubit<AuthState> {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  final String _adminUser = dotenv.get('FIREBASE_ADMIN_USERNAME');
  final String _adminPass = dotenv.get('FIREBASE_PASSWORD');

  AuthCubit(this._auth, this._firestore) : super(AuthState.initial) {
    _checkPersistedAuthState(); // Check authentication state from persistence
  }

  // Check auth state from SharedPreferences on initialization
  Future<void> _checkPersistedAuthState() async {
    final prefs = await SharedPreferences.getInstance();
    final isSignedIn = prefs.getBool('isSignedIn') ?? false;
    final isAdmin = prefs.getBool('isAdmin') ?? false;

    if (isAdmin) {
      emit(AuthState.admin);
    } else if (isSignedIn) {
      emit(AuthState.signedIn);
    } else {
      emit(AuthState.signedOut);
    }
  }

  Future<void> signInWithEmailPassword(String email, String password) async {
    try {
      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
        throw 'Invalid email format';
      }

      QuerySnapshot userQuery = await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .get();

      if (userQuery.docs.isEmpty) {
        throw 'User not found';
      }

      DocumentSnapshot userDoc = userQuery.docs.first;
      String storedPassword = userDoc['password'];

      if (storedPassword != password) {
        throw 'Incorrect password';
      }

      if (email == _adminUser && password == _adminPass) {
        _persistAuthState(isSignedIn: true, isAdmin: true);
        emit(AuthState.admin);
      } else {
        _persistAuthState(isSignedIn: true, isAdmin: false);
        emit(AuthState.signedIn);
      }
    } on SocketException {
      throw 'No internet connection. Please turn on data or Wi-Fi to access the internet.';
    } catch (e) {
      throw 'An unexpected error occurred: $e';
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      _clearAuthState();
      emit(AuthState.signedOut);
    } on SocketException {
      throw 'No internet connection. Please turn on data or Wi-Fi to access the internet.';
    } catch (e) {
      throw 'An unexpected error occurred: $e';
    }
  }

  Future<void> _persistAuthState(
      {required bool isSignedIn, required bool isAdmin}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isSignedIn', isSignedIn);
    await prefs.setBool('isAdmin', isAdmin);
  }

  Future<void> _clearAuthState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('isSignedIn');
    await prefs.remove('isAdmin');
  }

  // Validation added: Check if email already exists when creating a new user
  Future<void> createUserWithEmailPassword(
      String email, String password, String mobileNumber) async {
    try {
      if (email.isEmpty) {
        throw 'Please enter a value for the email.';
      }
      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
        throw 'Please enter a valid email address.';
      }

      // Check if email already exists
      QuerySnapshot userQuery = await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .get();

      if (userQuery.docs.isNotEmpty) {
        throw 'Email is already in use.';
      }

      if (password.isEmpty) {
        throw 'Please enter a value for the password.';
      }

      if (password.length <= 5) {
        throw 'Please provide at least 6 characters.';
      }

      // Format the mobile number
      String formattedMobileNumber = mobileNumber.trim();
      if (formattedMobileNumber.startsWith('0')) {
        formattedMobileNumber = '+63${formattedMobileNumber.substring(1)}';
      }

      await _firestore.collection('users').doc(email).set({
        'email': email,
        'password': password, // In a real app, hash passwords
        'mobileNumber': formattedMobileNumber,
      });
    } on SocketException {
      throw 'No internet connection. Please turn on data or Wi-Fi to access the internet.';
    } catch (e) {
      throw 'An error occurred: $e';
    }
  }

  // Validation added: Prevent updating to an existing email in Firestore
  Future<void> updateUserRecord(UserModel user) async {
    try {
      if (user.id == null || user.id!.isEmpty) {
        throw 'Invalid user ID.';
      }

      if (user.email.isEmpty) {
        throw 'Please enter an email.';
      }
      if (user.password.isEmpty) {
        throw 'Please enter a password.';
      }
      if (user.password.length <= 5) {
        throw 'Please provide at least 6 characters.';
      }

      // Check if the email belongs to another user
      QuerySnapshot userQuery = await _firestore
          .collection('users')
          .where('email', isEqualTo: user.email)
          .get();

      if (userQuery.docs.isNotEmpty && userQuery.docs.first.id != user.id) {
        throw 'Email is already in use by another user.';
      }

      await _firestore.collection('users').doc(user.id).update(user.toJson());
    } on SocketException {
      throw 'No internet connection. Please turn on data or Wi-Fi to access the internet.';
    } catch (e) {
      throw '$e';
    }
  }
}
