import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:srac_app/model/model_custom_user.dart';
import '../enum/genre.dart';
import 'package:flutter/widgets.dart';

class DatabaseServices {
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;
  static CollectionReference usersCollection = firestore.collection("Usuarios");

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
          genere: genere,
          birthDate: birthDate,
        );

        await docRef.set({
          "correo": mail,
          "contraseña": password,
          "nombre": name,
          "apellido": lastName,
          "fecha_nacimiento": convDateToString(birthDate),
          "genero": convGenderToString(genere),
          "Maceta": []
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
          return "Masculino";
        case eGenere.female:
          return "Femenino";
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

  static Future<CustomUser?> getUser({required String userMail}) async {
    try {
      print('Intentando obtener el usuario con correo: $userMail');
      DocumentSnapshot snapDoc = await usersCollection.doc(userMail).get();
      if (snapDoc.exists) {
        Map<String, dynamic>? userData =
            snapDoc.data() as Map<String, dynamic>?;

        CustomUser auxUser = CustomUser(
          name: userData!["nombre"],
          mail: userData["correo"],
          password: userData["contraseña"],
          genere: userData["genero"] == "Masculino"
              ? eGenere.male
              : userData["Genere"] == "Femenino"
                  ? eGenere.female
                  : eGenere.none,
          birthDate: convStringToDate(userData["fecha_nacimiento"]),
          lastName: userData["apellidos"],
        );

        return auxUser;
      } else {
        return null;
      }
    } catch (e) {
      throw Exception("Hubo un error en getUser ${e.toString()}");
    }
  }

  static DateTime convStringToDate(String fecha) {
    try {
      // Divide la cadena en día, mes y año
      List<String> partes = fecha.split('/');

      if (partes.length != 3) {
        throw const FormatException("El formato de fecha debe ser dd/mm/yyyy");
      }

      int dia = int.parse(partes[0]);
      int mes = int.parse(partes[1]);
      int anio = int.parse(partes[2]);

      // Crea y devuelve el objeto DateTime
      return DateTime(anio, mes, dia);
    } catch (e) {
      throw Exception("Error al convertir la fecha: $e");
    }
  }

  static Future<bool> login(
      {required String mail, required String password}) async {
    try {
      CustomUser? user = await getUser(userMail: mail);

      if (user != null) {
        if (password == user.password) {
          CustomUser.usuarioActual = user;
          return true;
        } else {
          // CODIGO DE CONTROL CUANDO LA CONTRASEÑA ES INCORRECTA
          return false;
        }
      } else {
        // CODIGO DE CONTROL CUANDO NO EXISTE USUARIO
        return false;
      }
    } catch (e) {
      throw Exception("Hubo un error en login $e");
    }
  }
}
