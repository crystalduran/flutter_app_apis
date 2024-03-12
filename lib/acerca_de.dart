import 'package:flutter/material.dart';
import 'package:crystal_tarea_seis/navbar.dart';

class AcercaDePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavBar(),
      appBar: AppBar(
        title: Text(
          "Acerca de la desarrolladora",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.pink,
      ),
      body: Center(
        child: Card(
          margin: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(height: 20),
              CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('assets/images/crystal1.jpeg'), // Reemplaza 'tu_foto.jpg' con la ruta de tu foto
              ),
              SizedBox(height: 20),
              Text(
                'Crystal Durán Núñez',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              ListTile(
                leading: Icon(Icons.email),
                title: Text('crystal12.duran@gmail.com'),
              ),
              ListTile(
                leading: Icon(Icons.phone),
                title: Text('+1 829 407 0912'),
              ),
              ListTile(
                leading: Icon(Icons.location_history),
                title: Text('Santo Domingo'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}