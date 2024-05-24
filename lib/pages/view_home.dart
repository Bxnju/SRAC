import 'package:flutter/material.dart';
// import 'package:srac_app/model/custom_user.dart';
import 'dart:ui';

import 'package:srac_app/pages/view_login.dart';

class Home extends StatelessWidget {
  const Home({super.key});

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
                    height: 120,
                  ),
                  const Column(
                    children: [
                      Center(
                          child: Text(
                        'Bienvenido!',
                        maxLines: 3,
                        style: TextStyle(
                          color: Color(0xFF32470F),
                          fontSize: 55,
                          fontWeight: FontWeight.bold,
                          // shadows: [
                          //   Shadow(
                          //     color: Color.fromARGB(205, 0, 0, 0),
                          //     blurRadius: 15,
                          //   ),
                          // ],
                        ),
                      )),
                      Center(
                          child: Text(
                        "Empieza a automatizar con",
                        // "${CustomUser.usuarioActual!.name} ${CustomUser.usuarioActual!.lastName}",
                        maxLines: 3,
                        style: TextStyle(
                            color: Color(0xFF32470F),
                            fontSize: 25,
                            fontWeight: FontWeight.bold),
                      )),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Image.asset(
                    'assets/logo.png',
                    width: 100,
                    height: 100,
                    fit: BoxFit.contain,
                  ),
                  Center(
                    child: Center(
                      child: GestureDetector(
                        onTap: () {
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) => const Tasks()));
                        },
                        child: Container(
                            margin: const EdgeInsets.only(top: 50),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Color(0xFF32470F),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    spreadRadius: 5,
                                    blurRadius: 13,
                                    offset: const Offset(0, 3))
                              ],
                            ),
                            height: 60,
                            width: 190,
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  "Comencemos",
                                  maxLines: 3,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.white,
                                  size: 30,
                                ),
                              ],
                            )),
                      ),
                    ),
                  )
                ],
              ),
            ),

            // ----------- BUTTON Home ------------

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
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const Home()));
              },
              child: Image.asset(
                'assets/home_icon.png',
                width: 70,
                height: 70,
                fit: BoxFit.contain,
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        const Login(),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      var begin = const Offset(0.0, -1.0);
                      var end = Offset.zero;
                      var curve = Curves.easeInOut;

                      var tween = Tween(begin: begin, end: end)
                          .chain(CurveTween(curve: curve));

                      return SlideTransition(
                        position: animation.drive(tween),
                        child: child,
                      );
                    },
                  ),
                );
              },
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
