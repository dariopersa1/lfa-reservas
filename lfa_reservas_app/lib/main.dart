import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'components/ReservationCard.dart';
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
        primaryColor: Color.fromARGB(255, 33, 33, 33),
      ),
      home: const MyHomePage(title: 'LFA Reservas App'),
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
  final String name;
  final String date;
  final int guests;

  Reservation({required this.name, required this.date, required this.guests});

  factory Reservation.fromFirestore(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return Reservation(
      name: data['nombre'] + ' ' + data['apellidos'],
      date: data['fecha'],
      guests: data['px'],
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
            ? Center(child: CircularProgressIndicator())
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
                          subtitle: Text('Mesa: 2'),
                          trailing: Text('${reservation.guests} px'),
                        ),
                      );
                    },
                  ),
                ),
              ]));
  }
}
