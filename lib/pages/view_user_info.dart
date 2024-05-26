import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:srac_app/model/model_custom_user.dart';
import 'package:srac_app/pages/view_crops.dart';
import 'package:srac_app/pages/view_home.dart';
// import 'package:srac_app/model/custom_user.dart';

import 'package:srac_app/pages/view_login.dart';
import 'package:srac_app/services/database_services.dart';

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
  final RegExp vPassword =
      RegExp(r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[\W_]).{8,}$');
  bool _isNameIconVisible = false;
  bool _isLastNameIconVisible = false;
  bool _isMailIconVisible = false;
  bool _isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    // Inicializar los controladores con los valores del usuario logueado
    // Por ejemplo:
    nameController.text = CustomUser.usuarioActual!.name;
    lastNameController.text = CustomUser.usuarioActual!.lastName;
    mailController.text = CustomUser.usuarioActual!.mail;
    passwordController.text = CustomUser.usuarioActual!.password;
  }

  @override
  void dispose() {
    nameController.dispose();
    lastNameController.dispose();
    mailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void updateUserProfile(String field, String value) async {
    String correoAntiguo = CustomUser.usuarioActual!.mail;

    if (field == 'nombre') {
      CustomUser.usuarioActual!.name = value;

      await FirebaseFirestore.instance
          .collection('Usuarios')
          .doc(CustomUser.usuarioActual!.mail)
          .update({field: value});
    } else if (field == 'apellido') {
      CustomUser.usuarioActual!.lastName = value;

      await FirebaseFirestore.instance
          .collection('Usuarios')
          .doc(CustomUser.usuarioActual!.mail)
          .update({field: value});
    } else if (field == 'correo') {
      CustomUser.usuarioActual!.mail = value;

      // Actualizar correo requiere crear un nuevo documento y eliminar el antiguo
      DocumentSnapshot oldUserDoc = await FirebaseFirestore.instance
          .collection('Usuarios')
          .doc(correoAntiguo)
          .get();

      if (oldUserDoc.exists) {
        // Crear nuevo documento con los mismos datos y nuevo correo
        await FirebaseFirestore.instance
            .collection('Usuarios')
            .doc(value)
            .set(oldUserDoc.data() as Map<String, dynamic>);

        // Actualizar el campo 'mail' en el nuevo documento
        await FirebaseFirestore.instance
            .collection('Usuarios')
            .doc(value)
            .update({'correo': value});

        // Eliminar el documento antiguo
        await FirebaseFirestore.instance
            .collection('Usuarios')
            .doc(correoAntiguo)
            .delete();
      }
    } else if (field == 'contraseña') {
      CustomUser.usuarioActual!.password = value;

      await FirebaseFirestore.instance
          .collection('Usuarios')
          .doc(CustomUser.usuarioActual!.mail)
          .update({field: value});
    }

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: const Color(0xFF32470F),
      content: Text(
        'Se ha actualizado el campo $field',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
      duration: const Duration(seconds: 3),
    ));
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
                  SizedBox(
                    height: 25.h,
                  ),
                  Image.asset(
                    'assets/logo.png',
                    width: 50.w,
                    height: 50.h,
                    fit: BoxFit.contain,
                  ),
                  SizedBox(
                    height: 35.h,
                  ),
                  Center(
                    child: Container(
                      margin: const EdgeInsets.only(top: 20),
                      child: Image.asset(
                        'assets/user_icon.png',
                        width: 200.w,
                        height: 200.h,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.only(left: 40, right: 40, top: 30),
                    decoration: BoxDecoration(
                      color: const Color(0xFF32470F),
                      borderRadius: BorderRadius.circular(
                          40.r), // Ajusta el radio del borde aquí
                    ),
                    child: Center(
                        child: Text(
                      'Editar datos',
                      maxLines: 3,
                      style: TextStyle(
                          fontFamily: 'Roboto',
                          color: const Color.fromARGB(255, 255, 255, 255),
                          fontSize: 45.sp,
                          fontWeight: FontWeight.bold),
                    )),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        //----- NAME -----

                        Container(
                          margin: const EdgeInsets.only(top: 20),
                          child: TextFormField(
                            controller: nameController,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: const Color(0xFFDBE9C9),
                              labelText: 'Nombres',
                              labelStyle: TextStyle(
                                  fontSize: 28.sp,
                                  color: Color.fromARGB(124, 49, 71, 15)),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25.r),
                                  borderSide: BorderSide.none),
                              suffixIcon: _isNameIconVisible
                                  ? IconButton(
                                      onPressed: () {
                                        updateUserProfile(
                                            'nombre', nameController.text);
                                        setState(() {
                                          _isNameIconVisible = false;
                                        });
                                      },
                                      icon: const Icon(
                                        Icons.check,
                                        color: Color(0xFF32470F),
                                        size: 30,
                                      ))
                                  : null,
                            ),
                            style: TextStyle(fontSize: 23.sp),
                            onFieldSubmitted: (value) {
                              updateUserProfile('nombre', value);
                              setState(() {
                                _isNameIconVisible = false;
                              });
                            },
                            onChanged: (value) {
                              setState(() {
                                _isNameIconVisible = true;
                              });
                            },
                          ),
                        ),

                        //----- LAST NAME -----

                        Container(
                          margin: const EdgeInsets.only(top: 20),
                          child: TextFormField(
                            controller: lastNameController,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: const Color(0xFFDBE9C9),
                              labelText: 'Apellidos',
                              labelStyle: TextStyle(
                                  fontSize: 28.sp,
                                  color: Color.fromARGB(124, 49, 71, 15)),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25.r),
                                  borderSide: BorderSide.none),
                              suffixIcon: _isLastNameIconVisible
                                  ? IconButton(
                                      onPressed: () {
                                        updateUserProfile('apellido',
                                            lastNameController.text);
                                        setState(() {
                                          _isLastNameIconVisible = false;
                                        });
                                      },
                                      icon: const Icon(
                                        Icons.check,
                                        color: Color(0xFF32470F),
                                        size: 30,
                                      ))
                                  : null,
                            ),
                            style: TextStyle(fontSize: 23.sp),
                            onFieldSubmitted: (value) {
                              updateUserProfile('apellido', value);
                              setState(() {
                                _isLastNameIconVisible = false;
                              });
                            },
                            onChanged: (value) {
                              setState(() {
                                _isLastNameIconVisible = true;
                              });
                            },
                          ),
                        ),

                        //----- EMAIL -----

                        Container(
                          margin: const EdgeInsets.only(top: 20),
                          child: TextFormField(
                            controller: mailController,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: const Color(0xFFDBE9C9),
                              labelText: 'Email',
                              labelStyle: TextStyle(
                                  fontSize: 28.sp,
                                  color: Color.fromARGB(124, 49, 71, 15)),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25.r),
                                  borderSide: BorderSide.none),
                              suffixIcon: _isMailIconVisible
                                  ? IconButton(
                                      onPressed: () {
                                        updateUserProfile(
                                            'correo', mailController.text);
                                        setState(() {
                                          _isMailIconVisible = false;
                                        });
                                      },
                                      icon: const Icon(
                                        Icons.check,
                                        color: Color(0xFF32470F),
                                        size: 30,
                                      ))
                                  : null,
                            ),
                            style: TextStyle(fontSize: 23.sp),
                            onFieldSubmitted: (value) {
                              updateUserProfile('correo', value);
                              setState(() {
                                _isMailIconVisible = false;
                              });
                            },
                            onChanged: (value) {
                              setState(() {
                                _isMailIconVisible = true;
                              });
                            },
                          ),
                        ),

                        //----- PASSWORD -----

                        Container(
                          margin: const EdgeInsets.only(top: 20),
                          child: TextFormField(
                            controller: passwordController,
                            obscureText:
                                !_isPasswordVisible, // Hace que el texto sea visible o no
                            decoration: InputDecoration(
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
                              filled: true,
                              fillColor: const Color(0xFFDBE9C9),
                              labelText: 'Contraseña',
                              labelStyle: TextStyle(
                                  fontSize: 28.sp,
                                  color: Color.fromARGB(124, 49, 71, 15)),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25.r),
                                  borderSide: BorderSide.none),
                            ),
                            style: TextStyle(fontSize: 23.sp),
                            keyboardType: TextInputType.phone,
                            onFieldSubmitted: (value) {
                              updateUserProfile('contraseña', value);
                            },
                            onChanged: (value) {
                              if (value.isEmpty) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  backgroundColor: Color(0xFF830000),
                                  content: Text(
                                    'La contraseña no puede estar vacía.',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  duration: Duration(seconds: 1),
                                ));
                              } else if (!vPassword.hasMatch(value)) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  backgroundColor: Color(0xFF830000),
                                  content: Text(
                                    'La contraseña debe tener al menos 8 caracteres, una mayúscula, una minúscula, un número y un caracter especial.',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  duration: Duration(seconds: 1),
                                ));
                              } else {
                                updateUserProfile('contraseña', value);
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  backgroundColor: Color(0xFF32470F),
                                  content: Text(
                                    'Se ha actualizado la contraseña',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  duration: Duration(seconds: 1),
                                ));
                              }
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
                    borderRadius: BorderRadius.circular(25.r),
                    color: const Color(0xFF32470F),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 2,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  height: 60.h,
                  width: 60.w,
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
                    borderRadius: BorderRadius.circular(25.r),
                    color: const Color(0xFF32470F),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 2,
                          offset: const Offset(0, 3))
                    ],
                  ),
                  height: 60.h,
                  width: 60.w,
                  child: Center(
                    child: GestureDetector(
                      onTap: () {
                        if (DatabaseServices.logout()) {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                      const Login(),
                              transitionsBuilder: (context, animation,
                                  secondaryAnimation, child) {
                                var begin = const Offset(0.0, -1.0);
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
                        }
                      },
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
          color: const Color.fromARGB(255, 205, 233, 201),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3))
          ],
        ),
        height: 90.h,
        width: 414.w,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        const Crops(),
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
                        milliseconds: 700), // Ajusta la duración aquí
                  ),
                );
              },
              child: Image.asset(
                'assets/flowerpot_icon.png',
                width: 70.w,
                height: 70.h,
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
                width: 70.w.w,
                height: 70.h,
                fit: BoxFit.contain,
              ),
            ),
            GestureDetector(
              onTap: () {},
              child: Image.asset(
                'assets/user_icon.png',
                width: 70.w,
                height: 70.h,
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
