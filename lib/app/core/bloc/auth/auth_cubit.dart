import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:unlockme/app/core/model/usermodel.dart';

enum AuthState { signedIn, signedOut, admin }

class AuthCubit extends Cubit<AuthState> {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  final String _adminUser = dotenv.get('FIREBASE_ADMIN_USERNAME');
  final String _adminPass = dotenv.get('FIREBASE_PASSWORD');

  AuthCubit(this._auth, this._firestore)
      : super(_auth.currentUser != null
            ? AuthState.signedIn
            : AuthState.signedOut);

  Future<void> signInWithEmailPassword(String email, String password) async {
    try {
      // Validate email format
      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
        throw 'Invalid email format';
      }

      // Query Firestore for the user document
      QuerySnapshot userQuery = await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .get();

      if (userQuery.docs.isEmpty) {
        throw 'User not found';
      }

      // Assuming there's only one document per username
      DocumentSnapshot userDoc = userQuery.docs.first;
      String storedPassword = userDoc['password'];

      if (storedPassword != password) {
        throw 'Incorrect password';
      }

      if (email == _adminUser && password == _adminPass) {
        emit(AuthState.admin); // Emit admin state for specific credentials
      } else {
        emit(AuthState.signedIn); // Emit signed in state for other users
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
      emit(AuthState.signedOut); // Emit signed out state
    } on SocketException {
      throw 'No internet connection. Please turn on data or Wi-Fi to access the internet.';
    } catch (e) {
      throw 'An unexpected error occurred: $e';
    }
  }

  Future<void> createUserWithEmailPassword(
      String email, String password) async {
    try {
      // Validate email format
      if (email.isEmpty) {
        throw 'Please enter a value for the email.';
      }
      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
        throw 'Please enter a valid email address.';
      }

      // Check if the user already exists in Firestore
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(email).get();

      if (userDoc.exists) {
        throw 'Email is already in use.';
      }

      if (password.isEmpty) {
        throw 'Please enter a value for the password.';
      }

      if (password.length <= 5) {
        throw 'Please provide atleast 5 length above characters.';
      }
      if (email.isEmpty && password.isEmpty) {
        throw 'Please enter a value for both email and password.';
      }

      await _firestore.collection('users').doc(email).set({
        'email': email,
        'password': password, // In a real app, hash passwords
      });
    } on SocketException {
      throw 'No internet connection. Please turn on data or Wi-Fi to access the internet.';
    } catch (e) {
      throw '$e';
    }
  }

  Future<void> updateUserRecord(UserModel user) async {
    try {
      // Ensure the user object has a valid ID
      if (user.id == null || user.id!.isEmpty) {
        throw 'Invalid user ID.';
      }

      if (user.email.isEmpty) {
        throw 'Please enter a email.';
      }
      if (user.password.isEmpty) {
        throw 'Please enter a password.';
      }
      if (user.password.length <= 5) {
        throw 'Please provide atleast 5 length above characters.';
      }
      // Update the user record in Firestore
      await _firestore.collection('users').doc(user.id).update(user.toJson());
    } on SocketException {
      throw 'No internet connection. Please turn on data or Wi-Fi to access the internet.';
    } catch (e) {
      throw '$e';
    }
  }
}
