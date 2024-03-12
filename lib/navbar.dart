import 'package:crystal_tarea_seis/acerca_de.dart';
import 'package:crystal_tarea_seis/climate_page.dart';
import 'package:crystal_tarea_seis/country_uni_page.dart';
import 'package:crystal_tarea_seis/edad_page.dart';
import 'package:crystal_tarea_seis/wordpress_page.dart';
import 'package:flutter/material.dart';
import 'package:crystal_tarea_seis/genero_page.dart';
import 'package:crystal_tarea_seis/main.dart';
class NavBar extends StatelessWidget {
  const NavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
         children: [
           UserAccountsDrawerHeader(
              accountName: const Text('Crystal Duran'),
              accountEmail: const Text('20220553@itla.edu.do'),
              currentAccountPicture: CircleAvatar(
                child: ClipOval(child: Image.asset('assets/images/crystal1.jpeg')),
              ),
             decoration: BoxDecoration(
               color: Colors.pinkAccent
             ),
          ),
           ListTile(
             leading: Icon(Icons.construction),
             title: Text('Inicio'),
             onTap: () => Navigator.push(
               context,
               MaterialPageRoute(builder: (context) => MyApp()),
             ),
           ),
           ListTile(
               leading: Icon(Icons.female),
               title: Text('Género'),
               onTap: () => Navigator.push(
                   context,
                   MaterialPageRoute(builder: (context) => GeneroPage())
               ),
           ),
           ListTile(
               leading: Icon(Icons.elderly),
               title: Text('Edad'),
               onTap: () => Navigator.push(
                 context,
                 MaterialPageRoute(builder: (context) => EdadPage())
               ),
           ),
           ListTile(
               leading: Icon(Icons.book),
               title: Text('Universidades de países'),
               onTap: () => Navigator.push(
                   context,
                   MaterialPageRoute(builder: (context) => UniversityListPage())
               ),
           ),
           ListTile(
               leading: Icon(Icons.cloudy_snowing),
               title: Text('Clima en RD'),
               onTap: () => Navigator.push(
                 context,
                 MaterialPageRoute(builder: (context) => ClimatePage())
               ),
           ),
           ListTile(
               leading: Icon(Icons.newspaper),
               title: Text('Página de WordPress'),
               onTap: () => Navigator.push(
                   context,
                   MaterialPageRoute(builder: (context) => NoticiaPage())
               ),
           ),
           ListTile(
               leading: Icon(Icons.info),
               title: Text('Acerca de'),
               onTap: () => Navigator.push(
                   context,
                   MaterialPageRoute(builder: (context) => AcercaDePage())
               ),
           ),
        ],
      ),
    );
  }
}
