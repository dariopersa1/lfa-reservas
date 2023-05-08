import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:intl/intl.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LFA Reservas App',
      theme: ThemeData(
        primaryColor: const Color.fromARGB(255, 33, 33, 33),
      ),
      home: BottomNavBar() /*const MyHomePage(title: 'LFA Reservas App')*/,
    );
  }
}

class BottomNavBar extends StatefulWidget {
  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const MyHomePage(title: 'LFA Reservas App'),
    StatsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Booking',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pie_chart),
            label: 'Stats',
          ),
        ],
      ),
    );
  }
}

class StatsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stats Page'),
      ),
      body: const Center(
        child: Text('Stats Content'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class Reservation {
  final String docId;
  final String name;
  final String date;
  final int guests;
  String email;
  final String tlf;
  final String hour;
  final String comment;
  final List preferences;
  String mesa;

  Reservation(
      {required this.docId,
      required this.name,
      required this.date,
      required this.guests,
      required this.email,
      required this.comment,
      required this.tlf,
      required this.hour,
      required this.preferences,
      required this.mesa});

  factory Reservation.fromFirestore(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return Reservation(
        docId: snapshot.id,
        name: data['nombre'] + ' ' + data['apellidos'],
        date: data['fecha'],
        guests: data['px'],
        email: data['email'],
        comment: data['comentario'],
        tlf: data['tlf'],
        hour: data['hora'],
        preferences: data['alergenos'],
        mesa: data['mesa'] ?? "-");
  }
}

final mesasAvailable = [
  "-",
  "1",
  "2",
  "3",
  "4",
  "5",
  "6",
  "7",
  "8",
  "9",
  "10",
  "11",
  "12",
  "13",
  "14",
  "15",
  "16",
  "17",
  "18",
  "19",
  "20",
  "21",
  "22",
  "23",
  "24",
  "25",
  "26",
  "27",
  "28",
  "29",
  "30",
  "31",
  "32",
  "33",
  "34",
  "35",
  "36",
  "37",
  "38",
  "39",
  "40"
];

class ReservaInfoSheet extends StatelessWidget {
  final Reservation reservation;
  ReservaInfoSheet({Key? key, required this.reservation}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 700.0,
      child: ListView(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        children: [
          ListTile(
              leading: const Icon(Icons.person),
              title: Text(reservation.name),
              trailing: Text('${reservation.guests} px'),
              visualDensity: const VisualDensity(vertical: 0)),
          const Divider(),
          ListTile(
              title: const Text('Teléfono'),
              subtitle: Text(reservation.tlf.toString()),
              visualDensity: const VisualDensity(vertical: -2)),
          ListTile(
              title: const Text('Email'),
              subtitle: Text(reservation.email.toString()),
              visualDensity: const VisualDensity(vertical: -2)),
          const ListTile(
              title: Text('Preferencias'),
              visualDensity: VisualDensity(vertical: -2)),
          reservation.preferences.isNotEmpty
              ? SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                  child: Row(mainAxisSize: MainAxisSize.max, children: [
                    Wrap(
                      spacing: 8.0,
                      runSpacing: 8.0,
                      children: List<Widget>.generate(
                        reservation.preferences.length,
                        (int idx) {
                          return Chip(
                              label: Text(
                                  reservation.preferences[idx].toString()));
                        },
                      ).toList(),
                    )
                  ]))
              : const ListTile(title: Text('Sin preferencias')),
          reservation.comment.isNotEmpty
              ? ListTile(
                  title: const Text('Comentario'),
                  subtitle: Text(reservation.comment.toString()),
                  visualDensity: const VisualDensity(vertical: -2))
              : const ListTile(
                  title: Text('Sin comentarios'),
                  visualDensity: VisualDensity(vertical: -2)),
          ListTile(
              title: const Text('Hora'),
              subtitle: Text(reservation.hour.toString()),
              visualDensity: const VisualDensity(vertical: -2)),
          ListTile(
            title: const Text('Mesa: '),
            subtitle: DropdownButtonFormField(
              menuMaxHeight: 550.0,
              items: mesasAvailable.map((String mesa) {
                return DropdownMenuItem(
                    value: mesa,
                    child: Row(
                      children: <Widget>[
                        Text(mesa),
                      ],
                    ));
              }).toList(),
              onChanged: (newMesa) {
                reservation.mesa = newMesa.toString();
                FirebaseFirestore.instance
                    .collection("reservas")
                    .doc(reservation.docId)
                    .update({"mesa": reservation.mesa}).then((_) {
                  print('Document updated successfully!');
                }).catchError((error) {
                  print('Error updating document: $error');
                });
              },
              value: reservation.mesa,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(10, 20, 10, 20),
              ),
            ),
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {},
                child: const Text('Llamar al cliente'),
              ),
              ElevatedButton(
                onPressed: () {},
                child: const Text('Anular reserva'),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class _MyHomePageState extends State<MyHomePage> {
  // Define a variable to hold the selected date
  DateTime _selectedDate = DateTime.now();
  // format the DateTime object as "dd/mm/yyyy"
  final dateFormatter = DateFormat('dd/MM/yyyy');
  List<Reservation> _reservations = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    // initialize the selectedDate to today's date
    _selectedDate = DateTime.now();
  }

  // Define a function to fetch the data for the selected date
  Future<void> _fetchReservations() async {
    setState(() {
      isLoading = true;
    });
    final reservations = await FirebaseFirestore.instance
        .collection('reservas')
        .where('fecha', isEqualTo: dateFormatter.format(_selectedDate))
        .get();
    setState(() {
      _reservations = reservations.docs
          .map((doc) => Reservation.fromFirestore(doc))
          .toList();
    });
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: Text(widget.title),
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                ListTile(
                  leading: Icon(Icons.date_range),
                  title: Text('Select a date'),
                  subtitle: Text('${dateFormatter.format(_selectedDate)}'),
                  onTap: () async {
                    // show the date picker and wait for user input
                    final pickedDate = await showDatePicker(
                        context: context,
                        initialDate: _selectedDate,
                        firstDate: DateTime(1900),
                        lastDate: DateTime(2100),
                        currentDate: _selectedDate);

                    if (pickedDate != null && pickedDate != _selectedDate) {
                      // update the selectedDate state variable and fetch the data
                      setState(() {
                        _selectedDate = pickedDate;
                      });
                      _fetchReservations();
                    }
                  },
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: _reservations.length,
                    itemBuilder: (context, index) {
                      final reservation = _reservations[index];
                      return Card(
                        child: ListTile(
                          title: Text(reservation.name),
                          subtitle: Text('Mesa: ${reservation.mesa}'),
                          trailing: Text('${reservation.guests} px'),
                          onTap: () {
                            // Show the bottom sheet
                            showModalBottomSheet(
                              context: context,
                              builder: (BuildContext context) {
                                return ReservaInfoSheet(
                                    reservation: reservation);
                              },
                            ).then((value) => _fetchReservations());
                          },
                        ),
                      );
                    },
                  ),
                ),
              ]));
  }
}
