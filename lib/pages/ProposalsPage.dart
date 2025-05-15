import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provieasy_proveedores_main/services/Connection.dart';

class ProposalsPage extends StatefulWidget {
  const ProposalsPage({Key? key}) : super(key: key);

  @override
  _ProposalsPageState createState() => _ProposalsPageState();
}

class _ProposalsPageState extends State<ProposalsPage> {
  late Future<List<dynamic>> _proposalsFuture;

  @override
  void initState() {
    super.initState();
    _loadProposals();
  }

  void _loadProposals() {
    _proposalsFuture = GetProposals().then((response) {
      if (response['code'] == 200) {
        return response['data']['items'] as List<dynamic>;
      }
      throw Exception('Error fetching contracts');
    });
  }

  String _mapStatus(int status) {
    // status = 1 pending, 2.accepted, 3.completed, 4.canceled, 5.in progress, 6. reviewed
    switch (status) {
      case 1:
        return 'Pending';
      case 2:
        return 'Approved';
      case 3:
        return 'Completed';
      case 4:
        return 'Canceled';
      case 5:
        return 'In Progress';
      default:
        return 'Unknown';
    }
  }

  Color _getStatusColor(int status) {
    switch (status) {
      case 1:
        return Colors.orange;
      case 2:
        return Colors.green;
      case 3:
        return Colors.blue;
      case 4:
        return Colors.red;
      case 5:
        return Colors.yellow;
      default:
        return Colors.grey;
    }
  }

  Widget _proposalCard(BuildContext context, dynamic contract) {
    final dateFormat = DateFormat.yMMMd().add_jm();
    final clientName = contract['provider_name'] as String? ?? 'No name';
    final contractId = contract['contract_id'] as String? ?? '';
    final status = contract['status'] as int? ?? 0;
    final requestedAt = DateTime.parse(contract['request_date'] as String);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(radius: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    clientName,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Service ID: ${contractId.substring(0, 8)}',
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 4),
            Text(
              'Status: ${_mapStatus(status)}',
              style: TextStyle(color: _getStatusColor(status), fontSize: 14),
            ),
            const SizedBox(height: 4),
            Text(
              'Requested: ${dateFormat.format(requestedAt)}',
              style: const TextStyle(fontSize: 12, color: Colors.black54),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    // TODO: navegar a detalles usando contractId
                  },
                  child: const Text('View Details'),
                ),
                const SizedBox(width: 8),
                TextButton(
                  onPressed: () {
                    DeclineContract(contractId);
                  },
                  child: const Text('Cancel'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: _proposalsFuture,
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snap.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Error al cargar propuestas'),
                ElevatedButton(
                  onPressed: _loadProposals,
                  child: const Text('Reintentar'),
                ),
              ],
            ),
          );
        }
        final proposals = snap.data;
        if (proposals == null || proposals.isEmpty) {
          return const Center(child: Text('No hay propuestas enviadas'));
        }
        return ListView(
          children: [
            const SizedBox(height: 12),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              child: Text(
                'Sent Proposals',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            ...proposals.map((c) => _proposalCard(context, c)),
          ],
        );
      },
    );
  }
}
