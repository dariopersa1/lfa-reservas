import 'package:flutter/material.dart';

class ReservationCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final double value;

  ReservationCard(
      {required this.title,
      required this.subtitle,
      required this.icon,
      required this.value});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {
          // Do something when the card is tapped
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            ListTile(
              leading: Icon(icon),
              title: Text(title),
              trailing: Text(
                '\$$value',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // Body
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: Text(
                subtitle,
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
