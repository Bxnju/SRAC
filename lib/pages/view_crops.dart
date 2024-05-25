import 'package:flutter/material.dart';
import 'package:srac_app/pages/view_crop_detail.dart';
import 'package:srac_app/pages/view_home.dart';
// import 'package:srac_app/model/custom_user.dart';

import 'package:srac_app/pages/view_login.dart';
import 'package:srac_app/pages/view_user_info.dart';

class Crops extends StatefulWidget {
  const Crops({super.key});

  @override
  State<Crops> createState() => _CropsState();
}

class Crop {
  final String name;
  final String type;
  final int humedad;
  final int agua;
  final int temperatura;

  Crop(this.name, this.type, this.humedad, this.agua, this.temperatura);
}

class StaticCrop {
  final String name;
  final String scientificName;
  final int tempMaxDiurna;
  final int tempMinDiurna;
  final int tempMaxNocturna;
  final int tempMinNocturna;
  final int humMaxPorc;
  final int humMinPorc;

  StaticCrop(
      this.name,
      this.scientificName,
      this.tempMaxDiurna,
      this.tempMinDiurna,
      this.tempMaxNocturna,
      this.tempMinNocturna,
      this.humMaxPorc,
      this.humMinPorc);
}

class _CropsState extends State<Crops> {
  final List<Crop> cropsList = [
    Crop("Cultivo N°1 - Lechugas", "lechuga", 75, 3, 17),
    Crop("Cultivo N°2 - Tomates", "tomate", 50, 2, 22),
    Crop("Cultivo N°3 - Cebolla", "cebolla", 30, 4, 15),
    Crop("Cultivo N°4 - Cilantro", "cilantro", 64, 4, 19),
    Crop("Cultivo N°5 - Perejil", "perejil", 70, 4, 21),
  ];

  final List<StaticCrop> staticCropsList = [
    // StaticCrop("Cultivo N°1 - Lechugas", "lechuga", 75, 3, 17),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFFBFD4A4),
        body: Stack(
          children: [
            Container(
              color: const Color(0xFFBFD4A4),
              child: ListView(
                children: [
                  const SizedBox(
                    height: 20,
                  ),

                  const SizedBox(
                    height: 5,
                  ),
                  Image.asset(
                    'assets/logo.png',
                    width: 50,
                    height: 50,
                    fit: BoxFit.contain,
                  ),

                  Container(
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.only(left: 40, right: 40, top: 30),
                    decoration: BoxDecoration(
                      color: const Color(0xFF32470F),
                      borderRadius: BorderRadius.circular(
                          40), // Ajusta el radio del borde aquí
                    ),
                    child: const Center(
                        child: Text(
                      'Tus cultivos',
                      maxLines: 3,
                      style: TextStyle(
                          fontFamily: 'Roboto',
                          color: Color.fromARGB(255, 255, 255, 255),
                          fontSize: 45,
                          fontWeight: FontWeight.bold),
                    )),
                  ),

                  // ----------- CULTIVOS ------------
                  Container(
                    width: 400,
                    margin: const EdgeInsets.only(top: 20, bottom: 75),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: cropsList.length,
                      itemBuilder: (context, index) {
                        return Center(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CropDetail(
                                    crop: cropsList[index],
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              margin: const EdgeInsets.only(top: 20),
                              height: 150,
                              width: 300,
                              child: Column(
                                children: [
                                  Container(
                                    height: 40,
                                    width: 300,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFF32470F),
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(20),
                                          topRight: Radius.circular(20)),
                                    ),
                                    child: Center(
                                      child: Text(
                                        cropsList[index].name,
                                        style: const TextStyle(
                                            fontFamily: 'Roboto',
                                            color: Color.fromARGB(
                                                255, 255, 255, 255),
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(20),
                                          bottomRight: Radius.circular(20)),
                                    ),
                                    height: 110,
                                    width: 300,
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.only(
                                        bottomLeft: Radius.circular(20),
                                        bottomRight: Radius.circular(20),
                                      ),
                                      child: Image.asset(
                                        "assets/${cropsList[index].type}.png",
                                        width: 50,
                                        height: 50,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 100),
                ],
              ),
            ),

            Positioned(
              bottom: 120,
              left: 0,
              right: 0,
              child: Align(
                alignment: Alignment.center,
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(35),
                    color: const Color(0xFF32470F),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 2,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  height: 80,
                  width: 80,
                  child: Center(
                    child: GestureDetector(
                      onTap: () {},
                      child: const Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 50,
                      ),
                    ),
                  ),
                ),
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
          color: const Color.fromARGB(255, 205, 233, 201),
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
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        const Home(),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
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
              onTap: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        const UserInfo(),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
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
