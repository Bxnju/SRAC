import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:srac_app/model/model_custom_user.dart';
import 'package:srac_app/pages/view_crops.dart';
import 'package:srac_app/pages/view_home.dart';
import 'dart:math';
// import 'package:srac_app/model/custom_user.dart';
import 'package:srac_app/pages/view_user_info.dart';

class AddCrop extends StatefulWidget {
  const AddCrop({super.key});

  @override
  State<AddCrop> createState() => _AddCropState();
}

class Crop {
  final String name;
  final String tipo;
  final int humedad;
  final int agua;
  final int temperatura;

  Crop(this.name, this.tipo, this.humedad, this.agua, this.temperatura);
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

class _AddCropState extends State<AddCrop> {
  final List<Crop> cropsList = [
    Crop("Cultivo N°1 - Lechugas", "lechuga", 75, 3, 17),
    Crop("Cultivo N°2 - Tomates", "tomate", 50, 2, 22),
    Crop("Cultivo N°3 - Cebolla", "cebolla", 30, 4, 15),
    Crop("Cultivo N°4 - Cilantro", "cilantro", 64, 4, 19),
    Crop("Cultivo N°5 - Perejil", "perejil", 70, 4, 21),
  ];

  TextEditingController cName = TextEditingController();
  TextEditingController cMaceta = TextEditingController();
  TextEditingController cTipo = TextEditingController();
  TextEditingController cPassword = TextEditingController();

  final List<String> _options = [
    'Lechuga',
    'Tomate',
    'Cebolla',
    'Cilantro',
    'Perejil'
  ];
  String? _selectedOption;

  final List<String> _optionsMaceta = [];
  String? _selectedOptionMaceta;
  bool isLoading = true; // Nueva bandera de carga

  Future<void> getMacetas() async {
    try {
      DocumentReference userDoc = FirebaseFirestore.instance
          .collection("Usuarios")
          .doc(CustomUser.usuarioActual!.mail);
      DocumentSnapshot docSnapshot = await userDoc.get();

      if (docSnapshot.exists) {
        Map<String, dynamic> userData =
            docSnapshot.data() as Map<String, dynamic>;
        Map<String, dynamic> macetas = userData["Macetas"] ?? {};

        macetas.forEach((macetaKey, macetaValue) {
          // Accede a los cultivos como un mapa anidado dentro de Macetas
          Map<String, dynamic> cultivos = macetaValue["Cultivos"] ?? {};

          if (cultivos.isEmpty) {
            _optionsMaceta.add(macetaKey);
          }

          // Cambiamos el estado para indicar que los datos se cargaron
          setState(() {
            isLoading = false;
          });
        });
      } else {
        throw Exception(
            'Error al obtener las macetas: No existe el usuario en la base de datos');
      }
    } catch (e) {
      throw Exception('Error al obtener las macetas: $e');
    }
  }

  Future<bool> addNewCropToUser(String userEmail, String macetaName,
      String cropName, String cropType) async {
    try {
      // Generar valores aleatorios para temp, hume y agua
      final random = Random();
      double temp = double.parse(
          (15 + random.nextDouble() * (22 - 15)).toStringAsFixed(1));
      double hume = double.parse(
          (70 + random.nextDouble() * (85 - 70)).toStringAsFixed(1));
      double agua = double.parse(
          (0.5 + random.nextDouble() * (5 - 0.5)).toStringAsFixed(1));

      // Referencia al documento del usuario
      DocumentReference userDoc =
          FirebaseFirestore.instance.collection("Usuarios").doc(userEmail);
      DocumentSnapshot docSnapshot = await userDoc.get();

      if (docSnapshot.exists) {
        Map<String, dynamic> userData =
            docSnapshot.data() as Map<String, dynamic>;
        Map<String, dynamic> macetas = userData["Macetas"] ?? {};

        if (macetas.containsKey(macetaName)) {
          Map<String, dynamic> selectedMaceta = macetas[macetaName];
          Map<String, dynamic> cultivos = selectedMaceta["Cultivos"] ?? {};

          // Añadir el nuevo cultivo
          cultivos[macetaName] = {
            'nombre': cropName,
            'tipo': cropType,
            'temp': temp,
            'hume': hume,
            'agua': agua,
          };

          // Actualizar la maceta con el nuevo cultivo
          selectedMaceta["Cultivos"] = cultivos;
          macetas[macetaName] = selectedMaceta;

          // Guardar los cambios en Firestore
          await userDoc.update({"Macetas": macetas});

          return true;
        } else {
          return false;
        }
      } else {
        throw Exception("No se encontró el documento del usuario.");
      }
    } catch (e) {
      throw Exception('Error al añadir el cultivo: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    getMacetas(); //Obtengo macetas del usuario actual
  }

  final _formAddCropKey = GlobalKey<FormState>();

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
              child: isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                      strokeWidth: 7,
                      color: Color(0xFF32470F),
                    ))
                  : ListView(
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
                          height: 100,
                        ),

                        Container(
                          padding: const EdgeInsets.all(10),
                          margin: const EdgeInsets.only(
                              left: 40, right: 40, top: 30),
                          decoration: BoxDecoration(
                            color: const Color(0xFF32470F),
                            borderRadius: BorderRadius.circular(
                                40), // Ajusta el radio del borde aquí
                          ),
                          child: const Center(
                              child: Text(
                            'Añadir cultivo',
                            maxLines: 3,
                            style: TextStyle(
                                fontFamily: 'Roboto',
                                color: Color.fromARGB(255, 255, 255, 255),
                                fontSize: 45,
                                fontWeight: FontWeight.bold),
                          )),
                        ),

                        // ----------- AÑADIR CULTIVOS ------------

                        Container(
                          padding: const EdgeInsets.only(
                              top: 20, bottom: 20, left: 15, right: 15),
                          margin: const EdgeInsets.only(
                              left: 20, right: 20, top: 10, bottom: 20),
                          decoration: BoxDecoration(
                            color: const Color(0xFFDBE9C9),
                            borderRadius: BorderRadius.circular(
                                40), // Ajusta el radio del borde aquí
                          ),
                          child: Form(
                              key: _formAddCropKey,
                              child: Column(
                                children: [
                                  // ----------- INPUT NAME ------------

                                  Container(
                                    margin: const EdgeInsets.only(top: 10),
                                    child: TextFormField(
                                      //Name Controller
                                      controller: cName,
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.white,
                                        hintText: 'Nombre del cultivo',
                                        hintStyle:
                                            const TextStyle(fontSize: 20),
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(25),
                                            borderSide: BorderSide.none),
                                      ),
                                      style: const TextStyle(fontSize: 20),
                                      validator: (value) {
                                        if (value!.length < 5) {
                                          return "El nombre debe tener al menos 5 caracteres.\n";
                                        }
                                        return null;
                                      },
                                    ),
                                  ),

                                  // ----------- INPUT TIPO ------------

                                  Container(
                                    margin: const EdgeInsets.only(top: 10),
                                    child: DropdownButtonFormField<String>(
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Por favor seleccione tipo de cultivo';
                                        }
                                        return null;
                                      },
                                      value: _selectedOption,
                                      items: _options.map((String option) {
                                        return DropdownMenuItem<String>(
                                          value: option,
                                          child: Text(option),
                                        );
                                      }).toList(),
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          _selectedOption = newValue;
                                          switch (_selectedOption) {
                                            case "Lechuga":
                                              cTipo.text = "lechuga";
                                              break;
                                            case "Tomate":
                                              cTipo.text = "tomate";
                                              break;
                                            case "Cilantro":
                                              cTipo.text = "cilantro";
                                              break;
                                            case "Cebolla":
                                              cTipo.text = "cebolla";
                                              break;
                                            case "Perejil":
                                              cTipo.text = "perejil";
                                              break;
                                            default:
                                              cTipo.text = "lechuga";
                                              break;
                                          }
                                        });
                                      },
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: const Color(0xFFFFFFFF),
                                        hintText: 'Tipo de cultivo',
                                        hintStyle:
                                            const TextStyle(fontSize: 20),
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(25),
                                            borderSide: BorderSide.none),
                                      ),
                                      style: const TextStyle(fontSize: 20),
                                    ),
                                  ),

                                  // ----------- INPUT MACETA ------------

                                  Container(
                                    margin: const EdgeInsets.only(top: 10),
                                    child: DropdownButtonFormField<String>(
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Por favor seleccione la maceta';
                                        }
                                        return null;
                                      },
                                      value: _selectedOptionMaceta,
                                      items:
                                          _optionsMaceta.map((String option) {
                                        return DropdownMenuItem<String>(
                                          value: option,
                                          child: Text(option),
                                        );
                                      }).toList(),
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          _selectedOptionMaceta = newValue;
                                          cMaceta.text = _selectedOptionMaceta!;
                                        });
                                      },
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: const Color(0xFFFFFFFF),
                                        hintText: 'Seleccione la maceta',
                                        hintStyle:
                                            const TextStyle(fontSize: 20),
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(25),
                                            borderSide: BorderSide.none),
                                      ),
                                      style: const TextStyle(fontSize: 20),
                                    ),
                                  ),

                                  // ----------- BUTTON ADD ------------

                                  Center(
                                    child: GestureDetector(
                                      onTap: () async {
                                        if (_formAddCropKey.currentState!
                                            .validate()) {
                                          // Añadir el cultivo a la base de datos
                                          bool result = await addNewCropToUser(
                                              CustomUser.usuarioActual!.mail,
                                              cMaceta.text,
                                              cName.text,
                                              cTipo.text);

                                          if (result) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(
                                              backgroundColor:
                                                  Color(0xFF32470F),
                                              content: Text(
                                                'Cultivo añadido correctamente.',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                              duration: Duration(seconds: 3),
                                            ));
                                            Navigator.push(
                                              context,
                                              PageRouteBuilder(
                                                pageBuilder: (context,
                                                        animation,
                                                        secondaryAnimation) =>
                                                    const Crops(),
                                                transitionsBuilder: (context,
                                                    animation,
                                                    secondaryAnimation,
                                                    child) {
                                                  var begin =
                                                      const Offset(0.0, 1.0);
                                                  var end = Offset.zero;
                                                  var curve = Curves.easeInOut;

                                                  var tween = Tween(
                                                          begin: begin,
                                                          end: end)
                                                      .chain(CurveTween(
                                                          curve: curve));
                                                  var curvedAnimation =
                                                      CurvedAnimation(
                                                    parent: animation,
                                                    curve: curve,
                                                  );

                                                  return SlideTransition(
                                                    position: tween.animate(
                                                        curvedAnimation),
                                                    child: child,
                                                  );
                                                },
                                                transitionDuration: const Duration(
                                                    milliseconds:
                                                        700), // Ajusta la duración aquí
                                              ),
                                            );
                                          } else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(
                                              backgroundColor:
                                                  Color(0xFF830000),
                                              content: Text(
                                                'Error al añadir el cultivo. Intente nuevamente.',
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
                                          margin:
                                              const EdgeInsets.only(top: 20),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: const Color(0xFF32470F),
                                            boxShadow: [
                                              BoxShadow(
                                                  color: Colors.black
                                                      .withOpacity(0.25),
                                                  spreadRadius: 3,
                                                  offset: const Offset(0, 3))
                                            ],
                                          ),
                                          height: 70,
                                          width: 150,
                                          child: const Center(
                                            child: Text("Registrar",
                                                maxLines: 3,
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 25,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          )),
                                    ),
                                  )
                                ],
                              )),
                        ),

                        const SizedBox(height: 100),
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
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        const Crops(),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
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
