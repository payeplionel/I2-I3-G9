import 'package:flutter/material.dart';

class NavBar extends StatelessWidget {
  const NavBar({Key? key, required this.selectedIndex, required this.onItemTapped}) : super(key: key);
  final int selectedIndex;
  final Function onItemTapped;

  @override
  Widget build(BuildContext context) {

    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: ImageIcon(AssetImage('assets/images/bone.png')),
          activeIcon: ImageIcon(AssetImage('assets/images/bone-selected.png')),
          label: 'Accueil',
        ),
        BottomNavigationBarItem(
          icon: ImageIcon(AssetImage('assets/images/add.png')),
          activeIcon: ImageIcon(AssetImage('assets/images/add-selected.png')),
          label: 'Ajouter',
        ),
        BottomNavigationBarItem(
          icon: ImageIcon(AssetImage('assets/images/qr.png')),
          label: 'QR',
        ),
        BottomNavigationBarItem(
          icon: ImageIcon(AssetImage('assets/images/settings.png')),
          activeIcon: ImageIcon(AssetImage('assets/images/settings-selected.png')),
          label: 'Paramètres',
        ),
      ],
      currentIndex: selectedIndex,
      selectedItemColor: Theme.of(context).primaryColor,
      unselectedItemColor: Colors.grey,
      onTap: (index){
        onItemTapped(index);
        switch(index){
          case 0 :
            Navigator.pushNamed(context, '/');
            break;
          case 1:
            Navigator.pushNamed(context, '/create');
            break;
          default:
            Navigator.pushNamed(context, '/');
        }
      },
      iconSize: 18,
      selectedFontSize: 12,
    );
  }
}
