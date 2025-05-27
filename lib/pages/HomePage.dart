import 'package:flutter/material.dart';
import 'package:provieasy_proveedores_main/pages/AccountPage.dart';
import 'package:provieasy_proveedores_main/pages/provider_request_page.dart';
// import 'package:provieasy_proveedores_main/services/Connection.dart';
import 'package:provieasy_proveedores_main/pages/ProposalsPage.dart';

const Color _baseColor = Color.fromARGB(255, 179, 157, 219);

class ProviderHomePage extends StatefulWidget {
  const ProviderHomePage({Key? key}) : super(key: key);

  @override
  _ProviderHomePageState createState() => _ProviderHomePageState();
}

class _ProviderHomePageState extends State<ProviderHomePage> {
  int _selectedIndex = 0;
  static final List<Widget> _pages = [
    const ProviderRequestsPage(),
    const ProposalsPage(),
    const AccountPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      // GetContracts();
      // GetProvider();
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _baseColor,
      appBar: AppBar(
        title: const Text('ProviEasy', style: TextStyle(color: Colors.black)),
        backgroundColor: _baseColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color.fromARGB(255, 126, 87, 194),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Requests'),
          BottomNavigationBarItem(icon: Icon(Icons.send), label: 'Proposals'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Account'),
        ],
      ),
    );
  }
}


// class _AccountPage extends StatelessWidget {
//   const _AccountPage({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Text(
//         'Account',
//         style: TextStyle(fontSize: 16, color: Colors.black54),
//       ),
//     );
//   }
// }