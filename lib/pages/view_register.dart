// ignore_for_file: use_build_context_synchronously
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:srac_app/enum/genre.dart';
import 'package:srac_app/pages/view_home.dart';
import 'package:srac_app/pages/view_login.dart';
import 'package:srac_app/services/database_services.dart';

class Register extends StatefulWidget {
  const Register({
    super.key,
  });

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  //--------------Control Variables-------------------
  TextEditingController cName = TextEditingController();
  TextEditingController cLastname = TextEditingController();
  TextEditingController cMail = TextEditingController();
  TextEditingController cPassword = TextEditingController();

  eGenere cGender = eGenere.none;

  DateTime? cBirthdate;

  final _formRegisterKey = GlobalKey<FormState>();

  final RegExp vFirstname = RegExp(r'^[a-zA-ZáéíóúÁÉÍÓÚ ]+$');
  final RegExp vLastname = RegExp(r'^[a-zA-ZáéíóúÁÉÍÓÚ ]+$');
  final RegExp vMail =
      RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
  final RegExp vPassword =
      RegExp(r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[\W_]).{8,}$');

  final List<String> _options = ['Masculino', 'Femenino'];
  String? _selectedOption;

  DateTime selectedDate = DateTime(2014, 1, 1);

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2019),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          // Aquí puedes personalizar el tema del selector de fecha
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
                primary: Colors.green), // Cambia el color primario a verde
            buttonTheme: const ButtonThemeData(
              textTheme: ButtonTextTheme.primary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        //Controlador fecha
        cBirthdate = selectedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFFBFD4A4),
        body: Stack(
          children: [
            ListView(
              children: [
                const SizedBox(
                  height: 80,
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
                    'Registrate',
                    maxLines: 3,
                    style: TextStyle(
                        fontFamily: 'Roboto',
                        color: Color.fromARGB(255, 255, 255, 255),
                        fontSize: 45,
                        fontWeight: FontWeight.bold),
                  )),
                ),
                const SizedBox(
                  height: 40,
                ),
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
                      key: _formRegisterKey,
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
                                hintText: 'Nombre',
                                hintStyle: const TextStyle(fontSize: 20),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25),
                                    borderSide: BorderSide.none),
                              ),
                              style: const TextStyle(fontSize: 20),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Por favor ingrese un nombre.\n";
                                } else if (!vFirstname.hasMatch(value)) {
                                  return "El nombre solo debe contener letras.\n";
                                } else if (value.length < 3) {
                                  return "EL nombre tiene que tener al menos 3 caracteres\n";
                                }
                                return null;
                              },
                            ),
                          ),

                          // ----------- INPUT LASTNAME ------------

                          Container(
                            margin: const EdgeInsets.only(top: 10),
                            child: TextFormField(
                              //LastName Controller
                              controller: cLastname,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                hintText: 'Apellidos',
                                hintStyle: const TextStyle(fontSize: 20),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25),
                                    borderSide: BorderSide.none),
                              ),
                              style: const TextStyle(fontSize: 20),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Por favor ingrese un apellido.\n";
                                } else if (!vLastname.hasMatch(value)) {
                                  return "El apellido solo debe contener letras.\n";
                                } else if (value.length < 3) {
                                  return "EL apellido tiene que tener al menos 3 caracteres\n";
                                }
                                return null;
                              },
                            ),
                          ),

                          // ----------- INPUT GENDER ------------

                          Container(
                            margin: const EdgeInsets.only(top: 10),
                            child: DropdownButtonFormField<String>(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Por favor seleccione su género';
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
                                    case "Masculino":
                                      cGender = eGenere.male;
                                      break;
                                    case "Femenino":
                                      cGender = eGenere.female;
                                      break;
                                    default:
                                      cGender = eGenere.none;
                                      break;
                                  }
                                });
                              },
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: const Color(0xFFFFFFFF),
                                hintText: 'Seleccione su género',
                                hintStyle: const TextStyle(fontSize: 20),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25),
                                    borderSide: BorderSide.none),
                              ),
                              style: const TextStyle(fontSize: 20),
                            ),
                          ),

                          // ----------- INPUT BIRTHDATE ------------

                          Container(
                            margin: const EdgeInsets.only(top: 10),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () => _selectDate(context),
                                  child: Container(
                                    height: 56,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                    padding: const EdgeInsets.all(10),
                                    child: Row(
                                      children: [
                                        const Text(
                                          'Fecha de nacimiento:',
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Color(0xFF707070)),
                                        ),
                                        const SizedBox(width: 10),
                                        Text(
                                          "${selectedDate.toLocal()}"
                                              .split(' ')[0],
                                          style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // ----------- INPUT EMAIL ------------

                          Container(
                            margin: const EdgeInsets.only(top: 10),
                            child: TextFormField(
                              //Email Controller
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
                                if (value!.isEmpty) {
                                  return "Por favor ingrese un correo electrónico.\n";
                                } else if (!vMail.hasMatch(value)) {
                                  return "El correo electrónico no es válido.\n";
                                }
                                return null;
                              },
                            ),
                          ),

                          // ----------- INPUT PASSWORD ------------

                          Container(
                            margin: const EdgeInsets.only(top: 10),
                            child: TextFormField(
                              //Password Controller
                              controller: cPassword,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                hintText: 'Contraseña',
                                hintStyle: const TextStyle(fontSize: 20),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25),
                                    borderSide: BorderSide.none),
                              ),
                              style: const TextStyle(fontSize: 20),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Por favor ingrese una contraseña.\n";
                                } else if (!vPassword.hasMatch(value)) {
                                  return "La contraseña debe tener al menos 8 caracteres, una letra mayúscula, una minúscula, un número y un caracter especial.\n";
                                }
                                return null;
                              },
                            ),
                          ),

                          // ----------- BUTTON REGISTER ------------

                          Center(
                            child: GestureDetector(
                              onTap: () async {
                                if (_formRegisterKey.currentState!.validate()) {
                                  final success =
                                      await DatabaseServices.registerUser(
                                          context: context,
                                          name: cName.text,
                                          lastName: cLastname.text,
                                          mail: cMail.text,
                                          password: cPassword.text,
                                          age: DatabaseServices.calculateAge(
                                              cBirthdate!),
                                          genere: cGender,
                                          birthDate: cBirthdate!);
                                  if (success) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const Home()));
                                  } else {
                                    print(
                                        "Ya el usuario existe en la base de datos");
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
                                          color: Colors.black.withOpacity(0.25),
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
                                            fontWeight: FontWeight.bold)),
                                  )),
                            ),
                          )
                        ],
                      )),
                ),
              ],
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
                          offset: const Offset(0, 3))
                    ],
                  ),
                  height: 60,
                  width: 60,
                  child: Center(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    Login(),
                            transitionsBuilder: (context, animation,
                                secondaryAnimation, child) {
                              var begin = Offset(-1.0, 0.0);
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
                            transitionDuration: Duration(
                                milliseconds: 700), // Ajusta la duración aquí
                          ),
                        );
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
          ],
        ));
  }
}
