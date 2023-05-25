
import 'package:flutter/material.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
      ),
      body: DefaultTabController(
        length: 2, // Nombre d'onglets
        child: Column(
          children: const [
             TabBar(
               tabs: [
                 Tab(text: 'Courses en cours'),
                 Tab(text: 'Courses terminées'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  // Contenu de l'onglet "Courses en cours"
                  // TODO: Ajoutez le contenu de l'onglet "Courses en cours"

                  // Contenu de l'onglet "Courses terminées"
                  // TODO: Ajoutez le contenu de l'onglet "Courses terminées"
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
