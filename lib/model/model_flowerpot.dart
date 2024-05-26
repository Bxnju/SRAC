import 'package:srac_app/model/model_history.dart';
import 'package:srac_app/model/model_plant.dart';

class Flowerpot {
  final int id;
  final String sensor;
  final String valve;
  History? history;
  Plant? plant;

  Flowerpot({
    required this.id,
    required this.sensor,
    required this.valve,
    this.history,
    this.plant,
  });
}
