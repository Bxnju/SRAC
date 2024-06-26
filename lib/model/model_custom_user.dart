// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:srac_app/enum/genre.dart';
import 'package:srac_app/model/model_flowerpot.dart';

class CustomUser {
  //instanciamos la base de datos
  // static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // static final CollectionReference _userCollection =
  //     _firestore.collection('Users');

  String name;
  String lastName;
  String mail;
  String password;
  final eGenere genere; //enum con los generos
  final DateTime? birthDate;
  final List<Flowerpot> flowerpotList;

  static CustomUser? usuarioActual;

  CustomUser(
      {required this.name,
      required this.lastName,
      required this.mail,
      required this.password,
      this.genere = eGenere.none, // Valor por defecto
      required this.birthDate,
      this.flowerpotList = const []});

  // void getUsers() async {
  //   //referencia a que colección vamos a utilizar
  //   CollectionReference collectionReferenceUsers =
  //       FirebaseFirestore.instance.collection("users");

  //   DocumentSnapshot snap = await FirebaseFirestore.instance
  //       .collection("users")
  //       .doc("usuario1")
  //       .get();

  //   //consulta a la coleccion
  //   QuerySnapshot consultaUsers = await collectionReferenceUsers.get();
  // }

  // //funcion para añadir los usuarios
  // Future<void> addUser() async {
  //   try {
  //     DocumentReference docRef = _userCollection.doc();
  //     /*
  //     User user = User(name: name, lastName: lastName, mail: mail, password: password, age: age, weight: weight)
  //     User.usuarioActual = user;
  //     User.setUsuario(user);

  //     await docRef.set(
  //       {
  //         "Name":name.text,
  //         "LastName":lastname.text,
  //       }
  //     );
  //     */
  //   } catch (e) {
  //     throw Exception("Hubo un error en addUser $e");
  //   }
  // }

  static setUsuario(CustomUser user) {}
}
