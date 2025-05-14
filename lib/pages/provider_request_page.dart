import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'DetailsPage.dart';

class ProviderRequestsPage extends StatelessWidget {
  const ProviderRequestsPage({Key? key}) : super(key: key);

  Widget _sectionTitle(String title) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      );

  Widget _requestCard(
    BuildContext context,
    String clientName,
    String serviceTitle,
    String serviceDescription,
    DateTime requestedAt,
    String requestId,
    double distance,

  ) {
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
                  backgroundImage: AssetImage('assets/profile_placeholder.png'),
                ),
                const SizedBox(width: 12),
                Expanded(
                    child: Text(clientName,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600))),
              ],
            ),
            const SizedBox(height: 8),
            Text(serviceTitle, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            const SizedBox(height: 4),
            Text(serviceDescription, style: const TextStyle(fontSize: 14)),
            const SizedBox(height: 4),
            Text('Distance: ${distance.toStringAsFixed(1)} km', style: const TextStyle(fontSize: 12, color: Colors.black54)),
            const SizedBox(height: 4),
            Text('Requested: ${DateFormat.yMMMd().add_jm().format(requestedAt)}', style: const TextStyle(fontSize: 12, color: Colors.black54)),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ProviderRequestDetailsPage(
                          clientName: clientName,
                          serviceTitle: serviceTitle,
                          serviceDescription: serviceDescription,
                          requestedAt: requestedAt,
                          requestId: requestId,
                          distance: distance,
                          
                        ),
                      ),
                    );
                  },
                  child: const Text('Propose Price'),
                ),
                const SizedBox(width: 8),
              TextButton(
                onPressed: () {
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
                            // TODO: aquí va la lógica para declinar realmente el servicio
                          },
                          child: const Text('Rechazar'),
                        ),
                      ],
                    ),
                  );
                },
                child: const Text('Decline'),
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
    final List<Map<String, dynamic>> sample = [
      {
        'clientName': 'Emily Clark',
        'serviceTitle': 'Home Cleaning',
        'serviceDescription': 'Deep clean kitchen and bathroom.',
        'requestedAt': DateTime.now().subtract(const Duration(hours: 2)),
        'requestId': 'req_001',
        'distance': 3.4,
      },
      {
        'clientName': 'Carlos Mendoza',
        'serviceTitle': 'Gardening Service',
        'serviceDescription': 'Trim hedges and mow lawn.',
        'requestedAt': DateTime.now().subtract(const Duration(hours: 5)),
        'requestId': 'req_002',
        'distance': 8.2,
      },
    ];

    return ListView(
      children: [
        _sectionTitle('Pending Requests'),
        for (var r in sample)
          _requestCard(
            context,
            r['clientName'],
            r['serviceTitle'],
            r['serviceDescription'],
            r['requestedAt'],
            r['requestId'],
            r['distance'],
          ),
      ],
    );
  }
}
