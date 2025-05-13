import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provieasy_proveedores_main/pages/AccountPage.dart';
import 'package:provieasy_proveedores_main/pages/DetailsPage_test.dart';
import 'package:provieasy_proveedores_main/pages/ProposalsPage.dart';
import 'package:provieasy_proveedores_main/services/Connection.dart';

const Color _baseColor = Color.fromARGB(255, 179, 157, 219);

class ProviderHomePage extends StatefulWidget {
  const ProviderHomePage({Key? key}) : super(key: key);

  @override
  _ProviderHomePageState createState() => _ProviderHomePageState();
}

class _ProviderHomePageState extends State<ProviderHomePage> {
  int _selectedIndex = 0;
  final List<Widget> _pages = [
    const _ProviderRequestsPage(),
    const ProposalsPage(),
    const AccountPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
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

class _ProviderRequestsPage extends StatefulWidget {
  const _ProviderRequestsPage({Key? key}) : super(key: key);

  @override
  __ProviderRequestsPageState createState() => __ProviderRequestsPageState();
}

class __ProviderRequestsPageState extends State<_ProviderRequestsPage> {
  late Future<List<dynamic>> _contractsFuture;

  @override
  void initState() {
    super.initState();
    _loadContracts();
  }

  void _loadContracts() {
    _contractsFuture = GetContracts().then((response) {
      if (response['code'] == 200) {
        return response['data']['items'];
      }
      throw Exception('Error fetching contracts');
    });
  }

  Widget _sectionTitle(String title) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      );

  Widget _requestCard(BuildContext context, dynamic contract) {
    final dateFormat = DateFormat.yMMMd().add_jm();
    
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  radius: 24,
                  // backgroundImage: AssetImage('assets/profile_placeholder.png'),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    contract['provider_name'] ?? 'No name',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Service ID: ${contract['contract_id'].substring(0, 8)}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 4),
            Text(
              'Status: ${_mapStatus(contract['status'])}',
              style: TextStyle(
                color: _getStatusColor(contract['status']),
                fontSize: 14
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Requested: ${dateFormat.format(DateTime.parse(contract['request_date']))}',
              style: const TextStyle(fontSize: 12, color: Colors.black54),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  // onPressed: () async {
                  //   final contractDetails = await GetContract(contract['contract_id']);
                  //   Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //       builder: (_) => ProviderRequestDetailsPage(
                  //         contractData: contractDetails['data'],
                  //       ),
                  //     ),
                  //   );
                  // },
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ProviderRequestDetailsPage(
                          contractId: contract['contract_id'],
                        ),
                      ),
                    );
                  },
                  child: const Text('Propose Price'),
                ),
                const SizedBox(width: 8),
                TextButton(
                  onPressed: () => _showDeclineDialog(context, contract['contract_id']),
                  child: const Text('Decline'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _mapStatus(int status) {
    switch (status) {
      case 1: return 'Pending';
      case 2: return 'Approved';
      case 3: return 'Completed';
      default: return 'Unknown';
    }
  }

  Color _getStatusColor(int status) {
    switch (status) {
      case 1: return Colors.orange;
      case 2: return Colors.green;
      case 3: return Colors.blue;
      default: return Colors.grey;
    }
  }

  void _showDeclineDialog(BuildContext context, String contractId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirmación'),
        content: const Text('¿Seguro que quieres rechazar el servicio?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              // TODO: Implementar lógica de rechazo
            },
            child: const Text('Rechazar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: _contractsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Error al cargar contratos'),
                ElevatedButton(
                  onPressed: _loadContracts,
                  child: const Text('Reintentar'),
                ),
              ],
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No hay solicitudes pendientes'));
        }

        return ListView(
          children: [
            _sectionTitle('Solicitudes Pendientes'),
            ...snapshot.data!.map((contract) => _requestCard(context, contract)).toList(),
          ],
        );
      },
    );
  }
}