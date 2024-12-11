import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  Future<String?> signUserIn(BuildContext context, TextEditingController email,
      TextEditingController password) async {
    if (email.text.isEmpty || password.text.isEmpty) {
      return "Informe seu email e senha.";
    } else {
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email.text,
          password: password.text,
        );
        return null;
      } on FirebaseAuthException catch (e) {
        print('Código de erro: ${e.code}, Mensagem: ${e.message}');
        String message;

        switch (e.code) {
          case 'user-not-found':
            message = "Usuário não encontrado. Verifique seu email.";
            break;
          case 'wrong-password':
            message = "Senha incorreta. Tente novamente.";
            break;
          case 'invalid-email':
            message = "Email inválido. Verifique o formato do email.";
            break;
          case 'invalid-credential':
            message = "Credenciais inválidas. Verifique seu email e senha";
            break;
          default:
            message = "Ocorreu um erro. Tente novamente.";
        }
        return message;
      }
    }
  }

  void userSignOut() async {
    await FirebaseAuth.instance.signOut();
  }

  Future<String?> userRegister(
      TextEditingController email,
      TextEditingController password,
      TextEditingController confirmPassword) async {
    if (email.text.isEmpty ||
        password.text.isEmpty ||
        confirmPassword.text.isEmpty) {
      return "Por favor, preencha todos os campos.";
    }

    if (password.text != confirmPassword.text) {
      return "As senhas não coincidem.";
    }

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email.text,
        password: password.text,
      );
      return null; 
    } on FirebaseAuthException catch (e) {
      print('Código de erro: ${e.code}, Mensagem: ${e.message}');
      String message;

      switch (e.code) {
        case 'email-already-in-use':
          message = "Este email já está em uso.";
          break;
        case 'invalid-email':
          message = "Email inválido. Verifique o formato do email.";
          break;
        case 'weak-password':
          message = "A senha é muito fraca, deve ter pelo menos 6 dígitos.";
          break;
        default:
          message = "Ocorreu um erro. Tente novamente.";
      }
      return message; 
    }
  }
}
