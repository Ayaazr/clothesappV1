import 'dart:convert';
import 'dart:math';
import 'package:clothes_app/models/models.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

Future<UserModel?> _userFromFirebaseUser(User? user) async {
  if (user != null) {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (userDoc.exists) {
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;

        return UserModel(
          uid: user.uid,
          email: user.email!,
          displayName: user.displayName ?? userData['displayName'] ?? 'User',
          createdAt: (userData['createdAt'] as Timestamp?) ?? Timestamp.now(),
          birthday: userData['birthday'] ?? '', // Correctly fetching birthday
          city: userData['city'] ?? '', // Correctly fetching city
          adress: userData['adress'] ?? '', // Correctly fetching address
          postalCode: userData['postalCode'] ?? 0, // Correctly fetching postal code
        );
      } else {
        print('User document not found');
        return null;
      }
    } catch (e) {
      print('Error fetching user role: ${e.toString()}');
      return null;
    }
  }
  return null;
}


  // Delete User
  Future<void> deleteUser(String uid) async {
    try {
      // First delete from Firestore
      await _firestore.collection('users').doc(uid).delete();

      // Then delete from Firebase Auth
      User? user = _auth.currentUser;
      if (user != null && user.uid == uid) {
        await user.delete();
      }
    } catch (e) {
      print('Delete User Error: ${e.toString()}');
    }
  }

  // Get All Users
  Future<List<UserModel>> getAllUsers() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('users').get();
      List<UserModel> users = snapshot.docs
          .map((doc) => UserModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
      return users;
    } catch (e) {
      print('Get All Users Error: ${e.toString()}');
      return [];
    }
  }

  Stream<UserModel?> get user {
    return _auth.authStateChanges().asyncMap((firebaseUser) async {
      return await _userFromFirebaseUser(firebaseUser);
    });
  }

  Future<UserModel?> updateUser(
    String uid, {
    String? displayName,
    String? email,
    UserRole? role,
    String? code,
    String? profilePictureUrl, // Add the profile picture URL
  }) async {
    try {
      // Create a map with the fields to update
      Map<String, dynamic> updatedFields = {};

      if (displayName != null) updatedFields['displayName'] = displayName;
      if (email != null) updatedFields['email'] = email;
      if (role != null) updatedFields['role'] = role.toString();
      if (code != null) updatedFields['code'] = code;
      if (profilePictureUrl != null) {
        updatedFields['profilePictureUrl'] =
            profilePictureUrl; // Update profile picture
      }

      // Update the user in Firestore
      await _firestore.collection('users').doc(uid).update(updatedFields);

      // Return the updated user model
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(uid).get();
      UserModel updatedUser =
          UserModel.fromMap(userDoc.data() as Map<String, dynamic>);

      return updatedUser;
    } catch (e) {
      print('Update User Error: ${e.toString()}');
      return null;
    }
  }

  // Sign up, sign in, and other methods here...

  Future<String?> uploadProfilePicture(File imageFile) async {
    try {
      String fileName =
          'profile_pictures/${DateTime.now().millisecondsSinceEpoch}.png';
      Reference storageReference = _storage.ref().child(fileName);

      // Upload the file
      UploadTask uploadTask = storageReference.putFile(imageFile);

      // Get the download URL
      TaskSnapshot snapshot = await uploadTask.whenComplete(() {});
      String downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl; // Return the URL of the uploaded image
    } catch (e) {
      print('Profile Picture Upload Error: ${e.toString()}');
      return null;
    }
  }

  Future<void> updateProfilePicture(String uid, File imageFile) async {
    try {
      // Upload the image and get the URL
      String? profilePictureUrl = await uploadProfilePicture(imageFile);

      if (profilePictureUrl != null) {
        // Update the user profile picture URL in Firestore
        await updateUser(uid, profilePictureUrl: profilePictureUrl);
      }
    } catch (e) {
      print('Update Profile Picture Error: ${e.toString()}');
    }
  }

  Future<UserModel?> signUp(String email, String password, String displayName,
      String city, String adress, int postalCode, String birthday,
      {String? code}) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;

      UserModel userModel = UserModel(
        uid: user!.uid,
        email: email,
        displayName: displayName,
        createdAt: Timestamp.now(),
        birthday: birthday,
        city: city,
        adress: adress,
        postalCode: postalCode,
        password: password,
      );

      await _firestore.collection('users').doc(user.uid).set(userModel.toMap());
      return _userFromFirebaseUser(user);
    } catch (e) {
      print('Sign Up Error: ${e.toString()}');
      return null;
    }
  }

  Future<UserModel?> signInWithEmail(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print('Sign In Error: ${e.toString()}');
      return null;
    }
  }

  Future<UserModel?> signInWithCode(String code) async {
    try {
      // String hashedCode = _hashCode(code);
      QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .where('code', isEqualTo: code)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot userDoc = querySnapshot.docs.first;
        UserModel userModel =
            UserModel.fromMap(userDoc.data() as Map<String, dynamic>);

        return userModel;
      } else {
        print('No user found with that code');
        return null;
      }
    } catch (e) {
      print('Sign In with Code Error: ${e.toString()}');
      return null;
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print('Sign Out Error: ${e.toString()}');
    }
  }

  Future<void> updateUserCode(String uid, String code) async {
    try {
      String hashedCode = code;
      await _firestore
          .collection('users')
          .doc(uid)
          .update({'code': hashedCode});
    } catch (e) {
      print('Update User Code Error: ${e.toString()}');
    }
  }

  Future<UserModel?> fetchUserData(String uid) async {
    try {
      DocumentSnapshot snapshot =
          await _firestore.collection('users').doc(uid).get();
      return UserModel.fromMap(snapshot.data() as Map<String, dynamic>);
    } catch (e) {
      print('Fetch User Data Error: ${e.toString()}');
      return null;
    }
  }
}
