import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProviderRequestDetailsPage extends StatefulWidget {
  final String clientName;
  final String serviceTitle;
  final String serviceDescription;
  final DateTime requestedAt;
  final String requestId;
  final double distance;

  const ProviderRequestDetailsPage({
    Key? key,
    required this.clientName,
    required this.serviceTitle,
    required this.serviceDescription,
    required this.requestedAt,
    required this.requestId,
    required this.distance,
  }) : super(key: key);

  @override
  _ProviderRequestDetailsPageState createState() => _ProviderRequestDetailsPageState();
}

class _ProviderRequestDetailsPageState extends State<ProviderRequestDetailsPage> {
  final TextEditingController _priceController = TextEditingController();
  static const _baseColor = Color.fromARGB(255, 179, 157, 219);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Request Details', style: TextStyle(color: Colors.black, fontSize: 18)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(widget.serviceTitle,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(widget.serviceDescription, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text('Requested by: ${widget.clientName}',
                style: const TextStyle(fontSize: 14, color: Colors.black54)),
            const SizedBox(height: 4),
            Text('On: ${DateFormat.yMMMd().add_jm().format(widget.requestedAt)}',
                style: const TextStyle(fontSize: 14, color: Colors.black54)),
            const SizedBox(height: 4),
            Text('Distance: ${widget.distance.toStringAsFixed(1)} km',
                style: const TextStyle(fontSize: 14, color: Colors.black54)),
            const SizedBox(height: 24),
            TextField(
              controller: _priceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Proposed Price',
                prefixText: '\$',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red),
                    shape: const StadiumBorder(),
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                  ),
                  child: const Text('Decline'),
                ),
                ElevatedButton(
                  onPressed: () {
                    final price = double.tryParse(_priceController.text);
                    if (price != null) {
                      // TODO: send proposed price back via widget.requestId
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _baseColor,
                    shape: const StadiumBorder(),
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                  ),
                  child: const Text('Send Proposal', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
