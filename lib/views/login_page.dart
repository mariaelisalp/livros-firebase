import 'package:flutter/material.dart';
import 'package:livrosfirebase/components/my_button.dart';
import 'package:livrosfirebase/components/my_textfield.dart';
import 'package:livrosfirebase/service/auth_service.dart';
import 'package:livrosfirebase/views/auth_page.dart';
import 'package:livrosfirebase/views/register_page.dart';

class LoginPage extends StatefulWidget {
  final String? successMessage;

  LoginPage({this.successMessage});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final AuthService authService = AuthService();


  @override
  void initState(){
    super.initState();
     if (widget.successMessage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.successMessage!),
            duration: Duration(seconds: 2),
          ),
        );
      });
    }
  }

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
                  Icons.book,
                  size: 100,
                  color: Colors.purple,
                ),
                const SizedBox(height: 50),
                const Text(
                  'Seja Bem-Vindo!',
                  style: TextStyle(
                      color: Color(0xFF7B1FA2),
                      fontSize: 25,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 45),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Column(
                    children: <Widget>[
                      MyTextField(
                        controller: emailController,
                        hintText: "digite seu email",
                        obscureText: false,
                        keyboardType: TextInputType.emailAddress,
                        onChanged: (value) {
                          
                        },
                      ),
                      const SizedBox(height: 10.0),
                      MyTextField(
                        controller: passwordController,
                        hintText: "digite sua senha",
                        obscureText: true,
                        keyboardType: TextInputType.visiblePassword,
                        onChanged: (value) {},
                      ),
                      const SizedBox(height: 4),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              'Esqueceu a senha?',
                              style: TextStyle(
                                color: Colors.purple,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 15),
                      MyButton(
                        onTap: () async {
                          String? error = await authService.signUserIn(
                            context,
                            emailController,
                            passwordController,
                          );
                          if (error != null) {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text("Erro ao fazer login."),
                                  content: Text(error),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text("Ok"),
                                    ),
                                  ],
                                );
                              },
                            );
                          } 
                          else {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const AuthPage()));
                          }
                        },
                        text: "Entrar",
                      ),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Não tem Cadastro?',
                            style: TextStyle(color: Color(0xFF3B3B3B)),
                          ),
                          const SizedBox(width: 4),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const RegisterPage()),
                              );
                            },
                            child: const Text(
                              'Registre-se Agora!',
                              style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
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
