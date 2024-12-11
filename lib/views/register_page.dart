import 'package:flutter/material.dart';
import 'package:livrosfirebase/components/my_button.dart';
import 'package:livrosfirebase/components/my_textfield.dart';
import 'package:livrosfirebase/service/auth_service.dart';
import 'package:livrosfirebase/views/login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final AuthService authService = AuthService();
  String? errorMessage; // Para armazenar mensagens de erro

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: Column(
              children: <Widget>[
                const SizedBox(height: 50),
                const Icon(
                  Icons.app_registration,
                  size: 100,
                  color: Colors.purple,
                ),
                const SizedBox(height: 50),
                const Text(
                  'Crie uma conta!',
                  style: TextStyle(
                      color: Color(0xFF7B1FA2),
                      fontSize: 25,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 45),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.0),
                  child: Column(
                    children: <Widget>[
                      MyTextField(
                        controller: emailController,
                        hintText: "digite seu email",
                        obscureText: false,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 10.0),
                      MyTextField(
                        controller: passwordController,
                        hintText: "crie uma senha",
                        obscureText: true,
                        keyboardType: TextInputType.visiblePassword,
                      ),
                      const SizedBox(height: 10.0),
                      MyTextField(
                        controller: confirmPasswordController,
                        hintText: "confirme sua senha",
                        obscureText: true,
                        keyboardType: TextInputType.visiblePassword,
                      ),
                      const SizedBox(height: 15),
                      if (errorMessage != null) 
                        Text(
                          errorMessage!,
                          style: TextStyle(color: Colors.red),
                        ),
                      const SizedBox(height: 15),
                      MyButton(
                        onTap : () async {
                          String? result = await authService.userRegister(
                            emailController,
                            passwordController,
                            confirmPasswordController,
                          );
                          if (result != null) {
                            setState(() {
                              errorMessage = result; 
                            });
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => LoginPage(successMessage: "Usuário cadastrado com sucesso!",)),
                            );
                          }
                        },
                        text: "Cadastrar",
                      ),
                      const SizedBox(height: 15),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => LoginPage()),
                          );
                        },
                        child: Text(
                          'Já tenho uma conta!',
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}