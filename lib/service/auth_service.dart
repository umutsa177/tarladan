import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/user.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<bool> get isUserSeller async {
    final user = _auth.currentUser;
    if (user != null) {
      try {
        DocumentSnapshot doc =
            await _firestore.collection('users').doc(user.uid).get();
        if (doc.exists) {
          return (doc.data() as Map<String, dynamic>)['role'] == 'Satıcı';
        }
      } catch (e) {
        print("Error checking user role: $e");
      }
    }
    return false;
  }

  Future<UserCredential?> register(String name, String email, String password,
      String role, String phoneNumber) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'name': name,
        'email': email,
        'role': role,
        'phoneNumber': phoneNumber,
        'password': password,
      });

      return userCredential;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<User?> signIn(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<User?> getCurrentUser() async {
    return _auth.currentUser;
  }

  Future<AppUser?> getAppUser(String uid) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        return AppUser.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }
      return null;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Stream<AppUser?> get user {
    return _auth.authStateChanges().asyncMap((firebaseUser) async {
      if (firebaseUser == null) {
        return null;
      }
      return await getAppUser(firebaseUser.uid);
    });
  }

  Future<void> updateUserProfile(String userId, String newName) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'name': newName,
      });

      User? user = _auth.currentUser;
      if (user != null) {
        await user.updateProfile(displayName: newName);
      }
    } catch (e) {
      print('Profil güncelleme hatası: $e');
      throw Exception('Profil güncellenirken bir hata oluştu');
    }
  }

  Future<void> changePassword(
      String currentPassword, String newPassword) async {
    try {
      User? user = _auth.currentUser;

      if (user != null && user.email != null) {
        AuthCredential credential = EmailAuthProvider.credential(
          email: user.email!,
          password: currentPassword,
        );

        try {
          await user.reauthenticateWithCredential(credential);
        } catch (e) {
          throw Exception('Mevcut şifre yanlış. Lütfen doğru şifreyi giriniz.');
        }
        await user.updatePassword(newPassword);
        await _firestore.collection('users').doc(user.uid).update({
          'password': newPassword,
        });
      } else {
        throw Exception('Kullanıcı bulunamadı veya e-posta adresi yok');
      }
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'weak-password':
          throw Exception(
              'Yeni şifre çok zayıf. Lütfen daha güçlü bir şifre seçin.');
        case 'requires-recent-login':
          throw Exception(
              'Bu işlem için yakın zamanda oturum açmanız gerekiyor. Lütfen çıkış yapıp tekrar giriş yapın.');
        default:
          throw Exception('Şifre değiştirme başarısız oldu: ${e.message}');
      }
    } catch (e) {
      throw Exception('Beklenmeyen bir hata oluştu: $e');
    }
  }
}
