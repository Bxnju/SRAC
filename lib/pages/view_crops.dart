import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:srac_app/model/model_custom_user.dart';
import 'package:srac_app/pages/view_add_crop.dart';
import 'package:srac_app/pages/view_crop_detail.dart';
import 'package:srac_app/pages/view_home.dart';
import 'package:srac_app/pages/view_user_info.dart';

class Crops extends StatefulWidget {
  const Crops({super.key});

  @override
  State<Crops> createState() => _CropsState();
}

class Crop {
  final String nombre;
  final String tipo;
  final double humedad;
  final double agua;
  final double temperatura;

  Crop(this.nombre, this.tipo, this.humedad, this.agua, this.temperatura);
}

class StaticCrop {
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;
  static CollectionReference cropsCollection = firestore.collection("Cultivos");
  final String nombre;
  final String nombreCientifico;
  final double tempMaxDiurna;
  final double tempMinDiurna;
  final double tempMaxNocturna;
  final double tempMinNocturna;
  final double humMaxPorc;
  final double humMinPorc;

  StaticCrop(
      this.nombre,
      this.nombreCientifico,
      this.tempMaxDiurna,
      this.tempMinDiurna,
      this.tempMaxNocturna,
      this.tempMinNocturna,
      this.humMaxPorc,
      this.humMinPorc);
}

class _CropsState extends State<Crops> {
  final List<Crop> cropsList = [];
  final List<StaticCrop> staticCropsList = [];
  bool isLoading = true; // Nueva bandera de carga

  @override
  void initState() {
    super.initState();
    _getCropsFromFirestore();
    _getCropsToUser(CustomUser.usuarioActual!
        .mail); // Reemplaza con el correo electrónico del usuario actual
  }

  Future<void> _getCropsFromFirestore() async {
    try {
      QuerySnapshot querySnapshot = await StaticCrop.cropsCollection.get();

      List<StaticCrop> crops = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return StaticCrop(
          data['nombre'],
          data['nombre_cientifico'],
          data['temp_max_diurna'],
          data['temp_min_diurna'],
          data['temp_max_nocturna'],
          data['temp_min_nocturna'],
          data['hum_max_porc'],
          data['hum_min_porc'],
        );
      }).toList();

      setState(() {
        staticCropsList.addAll(crops);
      });
    } catch (e) {
      print('Error al obtener cultivos: $e');
    }
  }

  Future<void> _getCropsToUser(String userEmail) async {
    try {
      DocumentReference userDoc =
          FirebaseFirestore.instance.collection("Usuarios").doc(userEmail);
      DocumentSnapshot docSnapshot = await userDoc.get();

      if (docSnapshot.exists) {
        Map<String, dynamic> userData =
            docSnapshot.data() as Map<String, dynamic>;
        Map<String, dynamic> macetas = userData["Macetas"] ?? {};

        macetas.forEach((macetaKey, macetaValue) {
          // Accede a los cultivos como un mapa anidado dentro de Macetas
          Map<String, dynamic> cultivos = macetaValue["Cultivos"] ?? {};

          cultivos.forEach((cultivoKey, cultivoValue) {
            // Aquí creamos un nuevo objeto Crop y lo agregamos a la lista cropsList
            Crop newCrop = Crop(
              "${cultivoValue['nombre']} - $macetaKey", // Concatenamos el nombre del cultivo con el nombre de la maceta
              cultivoValue['tipo'], // El tipo será el nombre del cultivo
              cultivoValue['hume'], // Humedad
              cultivoValue['agua'], // Agua
              cultivoValue['temp'], // Temperatura
            );
            cropsList.add(newCrop);
          });
        });

        // Cambiamos el estado para indicar que los datos se cargaron
        setState(() {
          isLoading = false;
        });
      } else {
        print("No se encontró el documento del usuario.");
      }
    } catch (e) {
      print('Error al obtener los cultivos: $e');
      setState(() {
        isLoading = false; // Evita el bucle infinito en caso de error
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFBFD4A4),
      body: Stack(
        children: [
          Container(
            color: const Color(0xFFBFD4A4),
            child: isLoading
                ? Center(child: const CircularProgressIndicator())
                : ListView(
                    children: [
                      const SizedBox(height: 20),
                      const SizedBox(height: 5),
                      Image.asset(
                        'assets/logo.png',
                        width: 50,
                        height: 50,
                        fit: BoxFit.contain,
                      ),
                      Container(
                        padding: const EdgeInsets.all(10),
                        margin:
                            const EdgeInsets.only(left: 40, right: 40, top: 30),
                        decoration: BoxDecoration(
                          color: const Color(0xFF32470F),
                          borderRadius: BorderRadius.circular(40),
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
                          ),
                        ),
                      ),
                      Container(
                        width: 400,
                        margin: const EdgeInsets.only(top: 20, bottom: 75),
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: cropsList.length,
                          itemBuilder: (context, index) {
                            StaticCrop staticCropAux =
                                staticCropsList.firstWhere(
                              (element) =>
                                  element.nombre == cropsList[index].tipo,
                            );
                            print(
                                '${staticCropAux?.nombre} - ${cropsList[index].tipo} - ${staticCropAux?.tempMaxDiurna} - ${staticCropAux?.tempMinDiurna} - ${cropsList[index].temperatura}');
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
                                        decoration: BoxDecoration(
                                          color: staticCropAux != null
                                              ? (staticCropAux.tempMaxDiurna >
                                                      cropsList[index]
                                                          .temperatura
                                                  ? (staticCropAux
                                                              .tempMinDiurna <
                                                          cropsList[index]
                                                              .temperatura
                                                      ? const Color(0xFF32470F)
                                                      : const Color(0xFF10416B))
                                                  : const Color(0xFF590F0F))
                                              : const Color(0xFF32470F),
                                          borderRadius: const BorderRadius.only(
                                              topLeft: Radius.circular(20),
                                              topRight: Radius.circular(20)),
                                        ),
                                        child: Center(
                                          child: Text(
                                            cropsList[index].nombre,
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
                                            "assets/${cropsList[index].tipo}.png",
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
                    onTap: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  const AddCrop(),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
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
                          transitionDuration: const Duration(milliseconds: 800),
                        ),
                      );
                    },
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
          navbar(context),
        ],
      ),
    );
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
              onTap: () {},
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
                    transitionDuration: const Duration(milliseconds: 800),
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
              onTap: () async {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        const UserInfo(),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
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
                    transitionDuration: const Duration(milliseconds: 800),
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
