import 'package:welcome_to_flutter/src/services/local_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

enum AuthStatus {
  notAuthenticated,
  checking,
  authenticated,
}

class LoginProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  AuthStatus authStatus = AuthStatus.notAuthenticated;

  String? _errorMessage;
  String get errorMessage => _errorMessage ?? '';

  bool obscureText = true;

  bool isLoggedIn = false;

//PARA EL INICIO DE SESIÓN
  Future<UserCredential?> loginUser(String email, String password) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } catch (e) {
      print(e);
      return null;
    }
  }

//VERIFICAR AUTENTICIDAD DEL ROL
  Future<void> checkAuthStatus() async {
    final user = FirebaseAuth.instance.currentUser;
    isLoggedIn = user != null;

    if (isLoggedIn) {
      final tokenResult = await user!.getIdTokenResult();
      try {
        final decodedToken = tokenResult.claims;
        final rol = decodedToken!['rol'];

        // VERFICIAR PERMISOS DE USUARIO SEGÚN LAS REGLAS DE "Firestore"
        final firestore = FirebaseFirestore.instance;
        final userDoc = firestore.collection('users').doc(user.uid);
        final userDocSnapshot = await userDoc.get();
        final userDocData = userDocSnapshot.data();
        final userRol = userDocData?['rol'];

        if (userRol == 'admin' || userRol == 'manager') {
          // El usuario tiene permisos de administrador o manager, puede hacer lo que quiera
        } else if (userRol == 'user') {
          // EL USUARIO NO TIENE PERMISOS DE "USUARIO", PUEDE VER PERO NO MODIFICAR
          // EN LAS COLECCIONES SEGUN LAS REGLAS de Firestore
        } else {
          // EL USUARIO NO TIENE UN "ROL" VÁLIDO; SE CIERRA SESIÓN
          FirebaseAuth.instance.signOut();
        }
      } catch (e) {
        // AQUÍ SE PUEDE MODIFICAR EN CASO DE ERROR AL ' VERIFICAR EL "TOKEN" '
      }
    }
  }

  void getObscureText() {
    obscureText == true ? obscureText = false : obscureText = true;
    notifyListeners();
  }

  //SALIR DE LA APP
  Future<void> logoutApp() async {
    await _auth.signOut();
    authStatus = AuthStatus.notAuthenticated;
    isLoggedIn = false;
    notifyListeners();
    // ELIMINA LA 'is_signedin' DE LA CAJA USANDO: "LocalStorage"
    await LocalStorage().deleteIsSignedIn();
    //CAMBIAR A 'false' el valor de isLoggedIn
    await LocalStorage().setIsLoggedIn(false);
    //LIMPIAR LA CAJA
    await LocalStorage().clear();
  }

  //PARA OBTENER LOS DATOS DEL USUARIO
  Future<dynamic> getUserData(String email) async {
    final QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection('users')
        .where('email', isEqualTo: email)
        .limit(1)
        .get();

    if (snapshot.docs.isNotEmpty) {
      final userData = snapshot.docs[0].data();
      return userData;
    }

    return null;
  }
}
