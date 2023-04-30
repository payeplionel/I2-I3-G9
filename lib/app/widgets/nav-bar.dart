import 'package:flutter/material.dart';

class NavBar extends StatelessWidget {
  const NavBar({Key? key, required this.selectedIndex, required this.onItemTapped}) : super(key: key);
  final int selectedIndex;
  final Function onItemTapped;

  @override
  Widget build(BuildContext context) {

    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: ImageIcon(AssetImage('assets/images/bone.png')),
          activeIcon: ImageIcon(AssetImage('assets/images/bone-selected.png')),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: ImageIcon(AssetImage('assets/images/add.png')),
          activeIcon: ImageIcon(AssetImage('assets/images/add-selected.png')),
          label: 'Add',
        ),
        BottomNavigationBarItem(
          icon: ImageIcon(AssetImage('assets/images/qr.png')),
          label: 'QR',
        ),
        BottomNavigationBarItem(
          icon: ImageIcon(AssetImage('assets/images/settings.png')),
          activeIcon: ImageIcon(AssetImage('assets/images/settings-selected.png')),
          label: 'Settings',
        ),
      ],
      currentIndex: selectedIndex,
      selectedItemColor: Theme.of(context).primaryColor,
      unselectedItemColor: Theme.of(context).primaryColor,
      onTap: (index){
        onItemTapped(index);
    },
      iconSize: 18,
      selectedFontSize: 12,
      unselectedFontSize: 12,
    );
  }
}
