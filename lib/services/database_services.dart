import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:srac_app/model/model_custom_user.dart';
import '../enum/genre.dart';
import 'package:flutter/widgets.dart';

class DatabaseServices {
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;
  static CollectionReference usersCollection = firestore.collection("Users");

  static Future<bool> userExists({required String userMail}) async {
    try {
      DocumentSnapshot snapDoc = await usersCollection.doc(userMail).get();
      if (snapDoc.exists) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      throw Exception("Hubo un error en userExists ${e.toString()}");
    }
  }

  static bool logout() {
    try {
      CustomUser.usuarioActual = null;
      return true;
    } catch (e) {
      throw Exception("Hubo un error en logout $e");
    }
  }

  static Future<bool> registerUser({
    required BuildContext context,
    required String name,
    required String lastName,
    required String mail,
    required String password,
    required int age,
    required DateTime birthDate,
    required eGenere genere,
  }) async {
    try {
      DocumentReference docRef = usersCollection.doc(mail);

      if (await userExists(userMail: mail)) {
        // CODIGO DE CONTROL CUANDO EXISTE USUARIO
        return false;
      } else {
        CustomUser.usuarioActual = CustomUser(
          name: name,
          lastName: lastName,
          mail: mail,
          password: password,
          age: age,
          genere: genere,
          birthDate: birthDate,
        );

        await docRef.set({
          "Mail": mail,
          "Password": password,
          "Name": name,
          "LastName": lastName,
          "BirthDate": convDateToString(birthDate),
          "Age": age.toString(),
          "Genere": convGenderToString(genere),
        });

        return true;
      }
    } catch (e) {
      return false;
    }
  }

  static String convDateToString(DateTime fecha) {
    try {
      final dia = fecha.day
          .toString()
          .padLeft(2, '0'); // Agrega ceros a la izquierda si es necesario
      final mes = fecha.month.toString().padLeft(2, '0');
      final anio = fecha.year;

      return "$dia/$mes/$anio";
    } catch (e) {
      throw Exception("Error al convertir la fecha: $e");
    }
  }

  static String convGenderToString(eGenere genero) {
    try {
      switch (genero) {
        case eGenere.male:
          return "Male";
        case eGenere.female:
          return "Female";
        default:
          return "None"; // Valor predeterminado en caso de un género desconocido
      }
    } catch (e) {
      throw Exception("Error al convertir el genero: $e");
    }
  }

  static int calculateAge(DateTime fechaNacimiento) {
    try {
      final now = DateTime.now();
      final edad = now.year - fechaNacimiento.year;

      if (now.month < fechaNacimiento.month ||
          (now.month == fechaNacimiento.month &&
              now.day < fechaNacimiento.day)) {
        return edad - 1;
      }
      return edad;
    } catch (e) {
      throw Exception("Error al calcular la edad: $e");
    }
  }
}
