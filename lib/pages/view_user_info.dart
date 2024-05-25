import 'package:flutter/material.dart';
import 'package:srac_app/model/model_custom_user.dart';
import 'package:srac_app/pages/view_home.dart';
// import 'package:srac_app/model/custom_user.dart';

import 'package:srac_app/pages/view_login.dart';

class UserInfo extends StatefulWidget {
  const UserInfo({super.key});

  @override
  State<UserInfo> createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController mailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Inicializar los controladores con los valores del usuario logueado
    // Por ejemplo:
    // nameController.text = CustomUser.usuarioActual!.name;
    // lastNameController.text = CustomUser.usuarioActual!.lastName;
    // mailController.text = CustomUser.usuarioActual!.mail;
    // passwordController.text = CustomUser.usuarioActual!.password!;
    nameController.text = "Nombre Usuario";
    lastNameController.text = "Apellido Usuario";
    mailController.text = "Correo Usuario";
    passwordController.text = "Contraseña Usuario";
  }

  @override
  void dispose() {
    nameController.dispose();
    lastNameController.dispose();
    mailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void updateUserProfile(String field, String value) {
    // Aquí se actualiza la base de datos
    // Por ejemplo, usando Firebase:
    // FirebaseFirestore.instance.collection('usuarios').doc(CustomUser.usuarioActual!.mail).update({field: value});
    print('Updated $field to $value');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFFBFD4A4),
        body: Stack(
          children: [
            Container(
              color: Color(0xFFBFD4A4),
              child: ListView(
                children: [
                  const SizedBox(
                    height: 25,
                  ),
                  Image.asset(
                    'assets/logo.png',
                    width: 50,
                    height: 50,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(
                    height: 35,
                  ),
                  Center(
                    child: Container(
                      margin: const EdgeInsets.only(top: 20),
                      child: Image.asset(
                        'assets/user_icon.png',
                        width: 200,
                        height: 200,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const Center(
                      child: Text(
                    'Nombre Usuario'
                    // "${CustomUser.usuarioActual!.name} ${CustomUser.usuarioActual!.lastName}",
                    ,
                    maxLines: 3,
                    style: TextStyle(
                        fontFamily: 'Roboto',
                        color: Color(0xFF32470F),
                        fontSize: 45,
                        fontWeight: FontWeight.bold),
                  )),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 20),
                          child: TextFormField(
                            controller: nameController,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: const Color(0xFFDBE9C9),
                              labelText: 'Nombres',
                              labelStyle: const TextStyle(
                                  fontSize: 28,
                                  color: Color.fromARGB(124, 49, 71, 15)),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25),
                                  borderSide: BorderSide.none),
                              suffixIcon: const Icon(
                                Icons.edit,
                                color: Color(0xFF32470F),
                                size: 30,
                              ),
                            ),
                            style: const TextStyle(fontSize: 23),
                            onFieldSubmitted: (value) {
                              updateUserProfile('name', value);
                            },
                            onChanged: (value) {
                              updateUserProfile('name', value);
                            },
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 20),
                          child: TextFormField(
                            controller: lastNameController,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: const Color(0xFFDBE9C9),
                              labelText: 'Apellidos',
                              labelStyle: const TextStyle(
                                  fontSize: 28,
                                  color: Color.fromARGB(124, 49, 71, 15)),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25),
                                  borderSide: BorderSide.none),
                              suffixIcon: const Icon(
                                Icons.edit,
                                color: Color(0xFF32470F),
                                size: 30,
                              ),
                            ),
                            style: const TextStyle(fontSize: 23),
                            onFieldSubmitted: (value) {
                              updateUserProfile('lastname', value);
                            },
                            onChanged: (value) {
                              updateUserProfile('name', value);
                            },
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 20),
                          child: TextFormField(
                            controller: mailController,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: const Color(0xFFDBE9C9),
                              labelText: 'Email',
                              labelStyle: const TextStyle(
                                  fontSize: 28,
                                  color: Color.fromARGB(124, 49, 71, 15)),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25),
                                  borderSide: BorderSide.none),
                              suffixIcon: const Icon(
                                Icons.edit,
                                color: Color(0xFF32470F),
                                size: 30,
                              ),
                            ),
                            style: const TextStyle(fontSize: 23),
                            keyboardType: TextInputType.emailAddress,
                            onFieldSubmitted: (value) {
                              updateUserProfile('email', value);
                            },
                            onChanged: (value) {
                              updateUserProfile('email', value);
                            },
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 20),
                          child: TextFormField(
                            controller: passwordController,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: const Color(0xFFDBE9C9),
                              labelText: 'Contraseña',
                              labelStyle: const TextStyle(
                                  fontSize: 28,
                                  color: Color.fromARGB(124, 49, 71, 15)),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25),
                                  borderSide: BorderSide.none),
                              suffixIcon: const Icon(
                                Icons.edit,
                                color: Color(0xFF32470F),
                                size: 30,
                              ),
                            ),
                            style: const TextStyle(fontSize: 23),
                            keyboardType: TextInputType.phone,
                            onFieldSubmitted: (value) {
                              updateUserProfile('phone', value);
                            },
                            onChanged: (value) {
                              updateUserProfile('phone', value);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Positioned(
              top: 25,
              left: 25,
              child: Center(
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: const Color(0xFF32470F),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 2,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  height: 60,
                  width: 60,
                  child: Center(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            Positioned(
              top: 25,
              right: 25,
              child: Center(
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: const Color(0xFF32470F),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 2,
                          offset: const Offset(0, 3))
                    ],
                  ),
                  height: 60,
                  width: 60,
                  child: Center(
                    child: GestureDetector(
                      onTap: () {},
                      child: const Icon(
                        Icons.logout,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // ----------- NAVBAR ------------

            navbar(context),
          ],
        ));
  }

  static Positioned navbar(BuildContext context) {
    return Positioned(
      bottom: 0,
      right: 0,
      left: 0,
      child: Container(
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 205, 233, 201),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3))
          ],
        ),
        height: 90,
        width: 414,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: () {
                // Navigator.push(context,
                //     MaterialPageRoute(builder: (context) => const Tasks()));
              },
              child: Image.asset(
                'assets/flowerpot_icon.png',
                width: 70,
                height: 70,
                fit: BoxFit.contain,
              ),
            ),
            GestureDetector(
              onTap: () async {
                Navigator.pushReplacement(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        const Home(),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      var begin = const Offset(-1.0, 0.0);
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
                        milliseconds: 800), // Ajusta la duración aquí
                  ),
                );
              },
              child: Image.asset(
                'assets/home_icon.png',
                width: 70,
                height: 70,
                fit: BoxFit.contain,
              ),
            ),
            GestureDetector(
              onTap: () {},
              child: Image.asset(
                'assets/user_icon.png',
                width: 70,
                height: 70,
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
