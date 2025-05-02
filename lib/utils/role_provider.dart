import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RoleProvider with ChangeNotifier {
  String _role = '';

  String get role => _role;

  Future<void> fetchUserRole() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final docSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        if (docSnapshot.exists) {
          _role = docSnapshot.data()?['role'] ?? '';
          notifyListeners();
        }
      }
    } catch (e) {
      _role = '';
      notifyListeners();
    }
  }

  void setRole(String newRole) {
    _role = newRole;
    notifyListeners();
  }
}