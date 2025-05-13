import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProposalsPage extends StatelessWidget {
  const ProposalsPage({Key? key}) : super(key: key);

  Widget _sectionTitle(String title) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      );

  Widget _proposalCard(
    BuildContext context,
    String clientName,
    String serviceTitle,
    double proposedPrice,
    DateTime proposedAt,
    double distance,
    String proposalId,
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
                  // backgroundImage: AssetImage('assets/profile_placeholder.png'),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(clientName, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(serviceTitle, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            const SizedBox(height: 4),
            Text('Proposed: \$${proposedPrice.toStringAsFixed(2)}', style: const TextStyle(fontSize: 14)),
            const SizedBox(height: 4),
            Text('Distance: ${distance.toStringAsFixed(1)} km', style: const TextStyle(fontSize: 12, color: Colors.black54)),
            const SizedBox(height: 4),
            Text('On: ${DateFormat.yMMMd().add_jm().format(proposedAt)}', style: const TextStyle(fontSize: 12, color: Colors.black54)),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  // TODO: navigate to proposal details using proposalId
                },
                child: const Text('View Details'),
              ),
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
        'proposedPrice': 75.00,
        'proposedAt': DateTime.now().subtract(const Duration(hours: 1)),
        'distance': 3.4,
        'proposalId': 'prop_001',
      },
      {
        'clientName': 'Carlos Mendoza',
        'serviceTitle': 'Gardening Service',
        'proposedPrice': 120.50,
        'proposedAt': DateTime.now().subtract(const Duration(hours: 3)),
        'distance': 8.2,
        'proposalId': 'prop_002',
      },
    ];

    return ListView(
      children: [
        _sectionTitle('Sent Proposals'),
        for (var p in sample)
          _proposalCard(
            context,
            p['clientName'],
            p['serviceTitle'],
            p['proposedPrice'],
            p['proposedAt'],
            p['distance'],
            p['proposalId'],
          ),
      ],
    );
  }
}
