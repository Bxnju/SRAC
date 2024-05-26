// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:srac_app/model/model_custom_user.dart';
import 'dart:ui';
import 'package:srac_app/pages/view_register.dart';
import 'package:srac_app/services/database_services.dart';

import 'view_home.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formLoginKey = GlobalKey<FormState>();

  final TextEditingController cMail = TextEditingController();
  final TextEditingController cPassword = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    // Inicializar los controladores con los valores del usuario logueado
    // Por ejemplo:
    CustomUser.usuarioActual = null;
  }

  final RegExp vMail =
      RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFFBFD4A4),
        body: Stack(
          children: [
            ListView(
              children: [
                const SizedBox(
                  height: 150,
                ),
                Container(
                  color: Colors.transparent,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Image.asset(
                          'assets/logo.png',
                          width: 380,
                          height: 180,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(
                  height: 10,
                ),

                // ----------- TEXT LOGIN ------------

                const Center(
                  child: Text(
                    'Iniciar Sesión',
                    style: TextStyle(
                        color: Color(0xFF32470F),
                        fontSize: 35,
                        fontWeight: FontWeight.bold),
                  ),
                ),

                Form(
                  key: _formLoginKey,
                  child: Column(
                    children: [
                      // ----------- INPUT EMAIL ------------

                      Container(
                        margin:
                            const EdgeInsets.only(top: 10, left: 30, right: 30),
                        child: TextFormField(
                          controller: cMail,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: 'Correo electrónico',
                            hintStyle: const TextStyle(fontSize: 20),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25),
                                borderSide: BorderSide.none),
                          ),
                          style: const TextStyle(fontSize: 20),
                          validator: (value) {
                            if (value!.isNotEmpty) {
                              if (!vMail.hasMatch(value)) {
                                return 'Por favor ingrese un correo electrónico válido';
                              }
                            } else {
                              return 'Por favor ingrese su correo electrónico';
                            }
                            return null;
                          },
                        ),
                      ),

                      // ----------- INPUT PASSWORD ------------

                      Container(
                        margin:
                            const EdgeInsets.only(top: 10, left: 30, right: 30),
                        child: TextFormField(
                          obscureText:
                              !_isPasswordVisible, // Hace que el texto sea visible o no
                          controller: cPassword,
                          decoration: InputDecoration(
                            filled: true,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isPasswordVisible =
                                      !_isPasswordVisible; // Cambia el estado de visibilidad
                                });
                              },
                            ),
                            fillColor: const Color.fromARGB(255, 255, 255, 255),
                            hintText: 'Contraseña',
                            hintStyle: const TextStyle(fontSize: 20),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25),
                                borderSide: BorderSide.none),
                          ),
                          style: const TextStyle(fontSize: 20),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Por favor ingrese su contraseña';
                            }
                            return null;
                          },
                        ),
                      ),

                      // ----------- NOT REGISTERED ------------

                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                      const Register(),
                              transitionsBuilder: (context, animation,
                                  secondaryAnimation, child) {
                                var begin = const Offset(1.0, 0.0);
                                var end = Offset.zero;
                                var curve = Curves.easeInOut;

                                var tween = Tween(begin: begin, end: end)
                                    .chain(CurveTween(curve: curve));
                                var curvedAnimation = CurvedAnimation(
                                  parent: animation,
                                  curve: curve,
                                );

                                return SlideTransition(
                                  position: tween.animate(curvedAnimation),
                                  child: child,
                                );
                              },
                              transitionDuration: const Duration(
                                  milliseconds: 700), // Ajusta la duración aquí
                            ),
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.only(
                              top: 10, left: 30, right: 30),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                'Aun no estas registrado? Crea una cuenta',
                                style: TextStyle(
                                    color: Color(0xFF32470F),
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                      ),

                      // ----------- BUTTON LOGIN ------------

                      Center(
                        child: GestureDetector(
                          onTap: () async {
                            if (_formLoginKey.currentState!.validate()) {
                              final success = await DatabaseServices.login(
                                  mail: cMail.text, password: cPassword.text);

                              if (success) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  backgroundColor: const Color(0xFF32470F),
                                  content: Text(
                                    'Bienvenido a SRAC ${CustomUser.usuarioActual!.name} ${CustomUser.usuarioActual!.lastName}!',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  duration: const Duration(seconds: 3),
                                ));
                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder: (context, animation,
                                            secondaryAnimation) =>
                                        const Home(),
                                    transitionsBuilder: (context, animation,
                                        secondaryAnimation, child) {
                                      var begin = const Offset(0.0, 1.0);
                                      var end = Offset.zero;
                                      var curve = Curves.easeInOut;

                                      var tween = Tween(begin: begin, end: end)
                                          .chain(CurveTween(curve: curve));
                                      var curvedAnimation = CurvedAnimation(
                                        parent: animation,
                                        curve: curve,
                                      );

                                      return SlideTransition(
                                        position:
                                            tween.animate(curvedAnimation),
                                        child: child,
                                      );
                                    },
                                    transitionDuration: const Duration(
                                        milliseconds:
                                            700), // Ajusta la duración aquí
                                  ),
                                );

                                cMail.clear();
                                cPassword.clear();
                              } else {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  backgroundColor: Color(0xFF830000),
                                  content: Text(
                                    'Correo o contraseña incorrectos. Por favor, inténtelo de nuevo.',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  duration: Duration(seconds: 3),
                                ));
                              }
                            }
                          },
                          child: Container(
                            margin: const EdgeInsets.only(top: 20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: const Color(0xFF32470F),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  spreadRadius: 3,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            height: 70,
                            width: 140,
                            child: const Center(
                              child: Text("Ingresar",
                                  maxLines: 3,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ],
        ));
  }
}
