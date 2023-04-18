import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'models/model.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  int _paginaActual = 0;

  final List<Widget> _paginas = [
    Pantalla1(),
    Pantalla2(),
    Pantalla3(),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        themeMode: ThemeMode.system,
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: null,
          body: _paginas[_paginaActual],
          bottomNavigationBar: BottomNavigationBar(
            onTap: (index) {
              setState(() {
                _paginaActual = index;
              });
            },
            currentIndex: _paginaActual,
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(Icons.home, color: Colors.orange),
                  label: "Amazonas"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.maps_home_work, color: Colors.orange),
                  label: "Provincias"),
              BottomNavigationBarItem(
                  icon:
                      Icon(Icons.maps_home_work_outlined, color: Colors.orange),
                  label: "Distritos"),
            ],
          ),
        ));
  }
}

class Pantalla1 extends StatefulWidget {
  @override
  State<Pantalla1> createState() => _Pantalla1State();
}

class _Pantalla1State extends State<Pantalla1> {
  // final List<String> departments = [
  //   'GOBIERNO REGIONAL DEL DEPARTAMENTO DE LORETO',
  //   'GOBIERNO REGIONAL DEL DEPARTAMENTO DE JUNIN',
  //   'GOBIERNO REGIONAL DEL DEPARTAMENTO DE ICA',
  //   'GOBIERNO REGIONAL DEL DEPARTAMENTO DE AMAZONAS',
  //   'GOBIERNO REGIONAL DEL DEPARTAMENTO DE CAJAMARCA',
  //   'GOBIERNO REGIONAL DEL DEPARTAMENTO DE TUMBES',
  //   'GOBIERNO REGIONAL DE LA PROVINCIA CONSTITUCIONAL DEL CALLAO',
  //   'GOBIERNO REGIONAL DEL DEPARTAMENTO DE AYACUCHO',
  //   'GOBIERNO REGIONAL DEL DEPARTAMENTO DE APURIMAC',
  //   'GOBIERNO REGIONAL DEL DEPARTAMENTO DE HUANCAVELICA',
  //   'GOBIERNO REGIONAL DEL DEPARTAMENTO DE LA LIBERTAD',
  //   'GOBIERNO REGIONAL DEL DEPARTAMENTO DE LIMA',
  //   'GOBIERNO REGIONAL DEL DEPARTAMENTO DE MOQUEGUA',
  //   'GOBIERNO REGIONAL DEL DEPARTAMENTO DE SAN MARTIN',
  //   'GOBIERNO REGIONAL DEL DEPARTAMENTO DE PIURA',
  //   'GOBIERNO REGIONAL DEL DEPARTAMENTO DE ANCASH',
  //   'GOBIERNO REGIONAL DEL DEPARTAMENTO DE LAMBAYEQUE',
  //   'GOBIERNO REGIONAL DEL DEPARTAMENTO DE HUANUCO',
  //   'GOBIERNO REGIONAL DEL DEPARTAMENTO DE PUNO',
  //   'GOBIERNO REGIONAL DEL DEPARTAMENTO DE CUSCO',
  //   'GOBIERNO REGIONAL DEL DEPARTAMENTO DE UCAYALI',
  //   'GOBIERNO REGIONAL DEL DEPARTAMENTO DE AREQUIPA',
  //   'GOBIERNO REGIONAL DEL DEPARTAMENTO DE MADRE DE DIOS',
  //   'GOBIERNO REGIONAL DEL DEPARTAMENTO DE TACNA',
  //   'GOBIERNO REGIONAL DEL DEPARTAMENTO DE PASCO',
  //   'MUNICIPALIDAD METROPOLITANA DE LIMA',
  // ];

  String removePrefix(String department) {
    const prefix = "GOBIERNO REGIONAL DEL DEPARTAMENTO DE ";
    if (department.startsWith(prefix)) {
      return department.substring(prefix.length);
    } else {
      return department;
    }
  }

  // final List<double> percentages = [
  //   15.0,
  //   12.0,
  //   18.0,
  //   24.0,
  //   10.0,
  //   20.0,
  //   25.0,
  //   14.6,
  //   13.0,
  //   21.0,
  //   23.2,
  //   8.0,
  //   14.0,
  //   11.0,
  //   10.0,
  //   13.0,
  //   12.0,
  //   14.0,
  //   16.0,
  //   21.0,
  //   22.0,
  //   23.0,
  //   23.7,
  //   17.6,
  //   15.4,
  //   11.5,
  // ];
  List<dynamic> departments = [];
  List<dynamic> percetages = [];
  @override
  void initState() {
    getData();
    super.initState();
  }

  void getData() async {
    Response data = await Dio().get('http://20.115.31.31:5000/get_data');
    setState(() {});
    Model model = Model.fromApi(data.data);
    for (var i in model.fullDepartmentsInfo) {
      departments.add(i[1]);
    }
    for (var i in model.fullDepartmentsInfo) {
      percetages.add(i[2]);
    }
  }

  @override
  Widget build(BuildContext context) {
    Map<String, double> departmentMap =
        Map.fromIterables(departments, percetages).cast();

    List<MapEntry<String, double>> departmentList = departmentMap.entries
        .map((entry) => MapEntry(entry.key, entry.value))
        .toList();

    departmentList.sort((a, b) => b.value.compareTo(a.value));

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Department Spending',
      home: Scaffold(
        appBar: null,
        body: ListView.builder(
          itemCount: departments.length,
          itemBuilder: (context, index) {
            String department = removePrefix(departmentList[index].key);
            double percentage = departmentList[index].value;

            Color progressBarColor = Colors.green; // default color

            if (departmentList[index].key ==
                'GOBIERNO REGIONAL DEL DEPARTAMENTO DE AMAZONAS') {
              progressBarColor =
                  Colors.red; // set color to red for AMAZONAS department
            }

            return Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 16.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    department,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  SizedBox(
                    width: double.infinity,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[300], // gray background color
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Container(
                        height: 25.0,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Stack(
                          children: <Widget>[
                            Container(
                              width: MediaQuery.of(context).size.width *
                                  percentage /
                                  100,
                              decoration: BoxDecoration(
                                color:
                                    progressBarColor, // set progress bar color
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            Positioned.fill(
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 10.0),
                                  child: Text(
                                    "${percentage.toStringAsFixed(1)}%",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class Pantalla2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: Center(
        child: Text('¡Pronto!'),
      ),
    );
  }
}

class Pantalla3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: Center(
        child: Text('¡Pronto!'),
      ),
    );
  }
}
