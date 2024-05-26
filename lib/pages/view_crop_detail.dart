import 'package:flutter/material.dart';
import 'package:srac_app/pages/view_home.dart';
import 'package:srac_app/pages/view_user_info.dart';
import 'package:srac_app/pages/view_crops.dart';
import 'package:community_charts_flutter/community_charts_flutter.dart'
    as charts;

class CropDetail extends StatefulWidget {
  final Crop crop;

  const CropDetail({super.key, required this.crop});

  @override
  State<CropDetail> createState() => _CropDetailState();
}

class _CropDetailState extends State<CropDetail> {
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
                  margin: const EdgeInsets.only(left: 40, right: 40, top: 30),
                  decoration: BoxDecoration(
                    color: const Color(0xFF32470F),
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: Center(
                    child: Text(
                      widget.crop.nombre,
                      maxLines: 3,
                      style: const TextStyle(
                          fontFamily: 'Roboto',
                          color: Color.fromARGB(255, 255, 255, 255),
                          fontSize: 30,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                // ----------- DETALLES DEL CULTIVO ------------
                Container(
                  width: 400,
                  height: 300,
                  margin: const EdgeInsets.only(top: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          bottomLeft: Radius.circular(20),
                        ),
                        child: Container(
                            child: Image.asset(
                          'assets/${widget.crop.tipo}.png',
                          width: 150,
                          height: 300,
                          fit: BoxFit.cover,
                        )),
                      ),
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                        child: Container(
                          width: 200,
                          padding: const EdgeInsets.all(5.0),
                          color: const Color(0xFFF7FFEC),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.only(
                                    left: 20, right: 20, top: 10, bottom: 10),
                                child: const Center(
                                  child: Text('Datos del cultivo',
                                      style: TextStyle(
                                          fontSize: 25,
                                          color:
                                              Color.fromARGB(255, 50, 71, 15),
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center),
                                ),
                              ),
                              Container(
                                width: 180,
                                padding: const EdgeInsets.only(
                                    left: 20, right: 20, top: 10, bottom: 10),
                                margin: const EdgeInsets.only(
                                    left: 20, right: 20, top: 10),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF32470F),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Center(
                                  child: Text(
                                    '${widget.crop.humedad}% Hum',
                                    style: const TextStyle(
                                        fontSize: 18,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.only(
                                    left: 20, right: 20, top: 10, bottom: 10),
                                margin: const EdgeInsets.only(
                                    left: 20, right: 20, top: 10),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF32470F),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Center(
                                  child: Text(
                                    '${widget.crop.agua}L de agua',
                                    style: const TextStyle(
                                        fontSize: 18,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.only(
                                    left: 20, right: 20, top: 10, bottom: 10),
                                margin: const EdgeInsets.only(
                                    left: 20, right: 20, top: 10),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF32470F),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Center(
                                  child: Text(
                                    '${widget.crop.temperatura}°C',
                                    style: const TextStyle(
                                        fontSize: 18,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const CropChart(),
                const SizedBox(height: 150),
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
              onTap: () {
                // Navegación a la página de tareas
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

class CropChart extends StatelessWidget {
  const CropChart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ChartContainer(
          title: "Humedad a través del tiempo",
          data: [
            TimeSeriesData(DateTime(2024, 1, 1), 75),
            TimeSeriesData(DateTime(2024, 2, 1), 80),
            TimeSeriesData(DateTime(2024, 3, 1), 65),
            TimeSeriesData(DateTime(2024, 4, 1), 70),
            TimeSeriesData(DateTime(2024, 5, 1), 85),
          ],
        ),
        ChartContainer(
          title: "Riego de agua a través del tiempo",
          data: [
            TimeSeriesData(DateTime(2024, 1, 1), 0.5),
            TimeSeriesData(DateTime(2024, 2, 1), 0.1),
            TimeSeriesData(DateTime(2024, 3, 1), 0.071),
            TimeSeriesData(DateTime(2024, 4, 1), 0.1),
            TimeSeriesData(DateTime(2024, 5, 1), 0.3),
          ],
        ),
        ChartContainer(
          title: "Temperatura del suelo a través del tiempo",
          data: [
            TimeSeriesData(DateTime(2024, 1, 1), 15),
            TimeSeriesData(DateTime(2024, 2, 1), 10),
            TimeSeriesData(DateTime(2024, 3, 1), 30),
            TimeSeriesData(DateTime(2024, 4, 1), 22),
            TimeSeriesData(DateTime(2024, 5, 1), 28),
            TimeSeriesData(DateTime(2024, 6, 1), 11),
            TimeSeriesData(DateTime(2024, 7, 1), 38),
            TimeSeriesData(DateTime(2024, 8, 1), 42),
            TimeSeriesData(DateTime(2024, 9, 1), 30),
            TimeSeriesData(DateTime(2024, 10, 1), 11),
          ],
        ),
      ],
    );
  }
}

class ChartContainer extends StatelessWidget {
  final String title;
  final List<TimeSeriesData> data;

  ChartContainer({required this.title, required this.data});

  @override
  Widget build(BuildContext context) {
    var series = [
      charts.Series<TimeSeriesData, DateTime>(
        id: title,
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (TimeSeriesData data, _) => data.time,
        measureFn: (TimeSeriesData data, _) => data.value,
        data: data,
      )
    ];

    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(left: 25, right: 25, top: 20),
      decoration: BoxDecoration(
        color: const Color(0xFFF7FFEC),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF32470F),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 200.0,
            child: charts.TimeSeriesChart(
              series,
              animate: true,
              dateTimeFactory: const charts.LocalDateTimeFactory(),
              behaviors: [
                charts.ChartTitle('Fecha',
                    behaviorPosition: charts.BehaviorPosition.bottom,
                    titleOutsideJustification:
                        charts.OutsideJustification.middleDrawArea,
                    innerPadding: 18),
                charts.ChartTitle('Valor (°C / % / L)',
                    behaviorPosition: charts.BehaviorPosition.start,
                    titleOutsideJustification:
                        charts.OutsideJustification.middleDrawArea,
                    innerPadding: 18),
              ],
              primaryMeasureAxis: charts.NumericAxisSpec(
                renderSpec: charts.GridlineRendererSpec(
                  lineStyle: charts.LineStyleSpec(
                    color: charts.MaterialPalette.gray.shadeDefault,
                  ),
                ),
              ),
              domainAxis: charts.DateTimeAxisSpec(
                renderSpec: charts.GridlineRendererSpec(
                  lineStyle: charts.LineStyleSpec(
                    color: charts.MaterialPalette.gray.shadeDefault,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TimeSeriesData {
  final DateTime time;
  final double value;

  TimeSeriesData(this.time, this.value);
}
