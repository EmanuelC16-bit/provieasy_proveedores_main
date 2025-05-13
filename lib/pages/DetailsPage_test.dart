import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provieasy_proveedores_main/services/Connection.dart';

class ProviderRequestDetailsPage extends StatefulWidget {
  final String contractId;

  const ProviderRequestDetailsPage({
    Key? key,
    required this.contractId,
  }) : super(key: key);

  @override
  _ProviderRequestDetailsPageState createState() => _ProviderRequestDetailsPageState();
}

class _ProviderRequestDetailsPageState extends State<ProviderRequestDetailsPage> {
  late Future<Map<String, dynamic>> _contractFuture;
  final TextEditingController _priceController = TextEditingController();
  static const _baseColor = Color.fromARGB(255, 179, 157, 219);

  @override
  void initState() {
    super.initState();
    // Fetch only the 'data' section to avoid null-cast issues
    _contractFuture = GetContract(widget.contractId)
        .then((response) => response['data'] as Map<String, dynamic>);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _contractFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasError || !snapshot.hasData) {
          return Scaffold(
            body: Center(child: Text('Error loading contract: ${snapshot.error}')),
          );
        }

        final contract = snapshot.data!;
        final service = contract['contract_service'] as Map<String, dynamic>? ?? {};
        final details = contract['contract_details'] as List<dynamic>? ?? [];

        // Safely parse request_date
        DateTime requestDate;
        try {
          requestDate = DateTime.parse(contract['request_date'] as String);
        } catch (_) {
          requestDate = DateTime.now();
        }

        final dateFormat = DateFormat('MMM dd, yyyy - hh:mm a');
        final screenWidth = MediaQuery.of(context).size.width;

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text(
              'Contract #${widget.contractId.substring(0, 8).toUpperCase()}',
              style: const TextStyle(color: Colors.black, fontSize: 18),
            ),
            backgroundColor: Colors.white,
            elevation: 0,
            iconTheme: const IconThemeData(color: Colors.black),
          ),
          body: Padding(
            padding: EdgeInsets.all(screenWidth > 600 ? 24 : 16),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildDetailRow(
                    'Status:',
                    Text(
                      _mapStatus(contract['status'] as int),
                      style: TextStyle(
                        color: _getStatusColor(contract['status'] as int),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Divider(),
                  if (contract.containsKey('client_id'))
                    _buildDetailRow('Client ID:', Text(contract['client_id'] as String)),
                  _buildDetailRow(
                    'Request Date:',
                    Text(dateFormat.format(requestDate)),
                  ),
                  if (service.containsKey('agreed_price'))
                    _buildDetailRow(
                      'Agreed Price:',
                      Text('\$${service['agreed_price']}'),
                    ),
                  if (service.containsKey('location_service'))
                    _buildDetailRow(
                      'Location:',
                      Text(service['location_service'] as String),
                    ),
                  if (service.containsKey('user_request'))
                    _buildDetailRow(
                      'Description:',
                      Text(service['user_request'] as String),
                    ),
                  const SizedBox(height: 16),
                  if (details.isNotEmpty) ...[
                    const Text(
                      'Details:',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    ...details.map((item) {
                      final detailMap = item as Map<String, dynamic>;
                      return _buildDetailRow(
                        detailMap['detail'] as String,
                        Text('\$${detailMap['price']}'),
                      );
                    }).toList(),
                    const SizedBox(height: 24),
                  ],
                  const Text(
                    'Submit Your Proposal',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _priceController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Proposed Amount',
                      prefixText: '\$',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 16,
                      ),
                    ),
                    style: TextStyle(fontSize: screenWidth > 600 ? 18 : 16),
                  ),
                  const SizedBox(height: 20),
                  _buildActionButtons(context),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  String _mapStatus(int status) {
    switch (status) {
      case 1:
        return 'Pending Approval';
      case 2:
        return 'Active';
      case 3:
        return 'Completed';
      case 4:
        return 'Cancelled';
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
      default:
        return Colors.grey;
    }
  }

  Widget _buildDetailRow(String label, Widget value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.black54,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(child: value),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    final isLarge = MediaQuery.of(context).size.width > 600;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        OutlinedButton.icon(
          icon: const Icon(Icons.cancel_outlined),
          label: Text('Decline', style: TextStyle(fontSize: isLarge ? 16 : 14)),
          onPressed: () => Navigator.pop(context),
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.red,
            side: const BorderSide(color: Colors.red),
            padding: EdgeInsets.symmetric(
              vertical: isLarge ? 16 : 12,
              horizontal: isLarge ? 32 : 24,
            ),
          ),
        ),
        ElevatedButton.icon(
                        icon: const Icon(Icons.send),
                        label: Text(
                          'Send Proposal',
                          style: TextStyle(fontSize: isLarge ? 16 : 14, color: Colors.white),
                        ),
                        onPressed: () async {
                          final price = double.tryParse(_priceController.text);
                          if (price != null && price > 0) {
                            try {
                              await UpdateContract(widget.contractId, price);
                              Navigator.pop(context, true);
                            } catch (e) {
                              showDialog(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: const Text('Error'),
                                  content: Text('Could not update contract. ' + e.toString()),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(ctx),
                                      child: const Text('OK'),
                                    ),
                                  ],
                                ),
                              );
                            }
                          } else {
                            showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: const Text('Invalid Input'),
                                content: const Text('Please enter a valid price amount'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(ctx),
                                    child: const Text('OK'),
                                  ),
                                ],
                              ),
                            );
                          }
                        },
          style: ElevatedButton.styleFrom(
            backgroundColor: _baseColor,
            padding: EdgeInsets.symmetric(
              vertical: isLarge ? 16 : 12,
              horizontal: isLarge ? 32 : 24,
            ),
          ),
        ),
      ],
    );
  }
}
