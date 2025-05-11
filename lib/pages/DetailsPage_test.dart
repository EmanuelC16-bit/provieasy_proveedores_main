import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProviderRequestDetailsPage extends StatefulWidget {
  final Map<String, dynamic> contractData;

  const ProviderRequestDetailsPage({
    Key? key,
    required this.contractData,
  }) : super(key: key);

  @override
  _ProviderRequestDetailsPageState createState() => _ProviderRequestDetailsPageState();
}

class _ProviderRequestDetailsPageState extends State<ProviderRequestDetailsPage> {
  final TextEditingController _priceController = TextEditingController();
  static const _baseColor = Color.fromARGB(255, 179, 157, 219);
  late DateTime _requestDate;

  String _mapStatus(int statusCode) {
    switch (statusCode) {
      case 1:
        return 'Pending Approval';
      case 2:
        return 'Active';
      case 3:
        return 'Completed';
      case 4:
        return 'Cancelled';
      default:
        return 'Unknown Status';
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

  @override
  void initState() {
    super.initState();
    _requestDate = DateTime.parse(widget.contractData['request_date']);
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MMM dd, yyyy - hh:mm a');
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Contract #${widget.contractData['contract_id'].substring(0, 8).toUpperCase()}',
          style: const TextStyle(color: Colors.black, fontSize: 18)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: EdgeInsets.all(screenWidth > 600 ? 24 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildDetailRow('Status:', 
              Text(_mapStatus(widget.contractData['status']),
                style: TextStyle(
                  color: _getStatusColor(widget.contractData['status']),
                  fontWeight: FontWeight.bold
                ))
            ),
            const Divider(),
            _buildDetailRow('Provider:', Text(widget.contractData['provider_name'])),
            _buildDetailRow('Request Date:', Text(dateFormat.format(_requestDate))),
            if (widget.contractData['estimated_price'] != null)
              _buildDetailRow('Estimated Price:', 
                Text('\$${widget.contractData['estimated_price'].toStringAsFixed(2)}')),
            
            const SizedBox(height: 24),
            const Text('Submit Your Proposal', 
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
                  vertical: 14, horizontal: 16),
              ),
              style: TextStyle(fontSize: screenWidth > 600 ? 18 : 16),
            ),
            const SizedBox(height: 20),
            _buildActionButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, Widget value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(label, 
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.black54
              )),
          ),
          const SizedBox(width: 16),
          Expanded(child: value),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    final isLargeScreen = MediaQuery.of(context).size.width > 600;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        OutlinedButton.icon(
          icon: const Icon(Icons.cancel_outlined),
          label: Text('Decline', 
              style: TextStyle(fontSize: isLargeScreen ? 16 : 14)),
          onPressed: () => _handleDecline(),
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.red,
            side: const BorderSide(color: Colors.red),
            padding: EdgeInsets.symmetric(
              vertical: isLargeScreen ? 16 : 12,
              horizontal: isLargeScreen ? 32 : 24
            ),
          ),
        ),
        ElevatedButton.icon(
          icon: const Icon(Icons.send),
          label: Text('Send Proposal', 
              style: TextStyle(
                fontSize: isLargeScreen ? 16 : 14,
                color: Colors.white
              )),
          onPressed: () => _submitProposal(),
          style: ElevatedButton.styleFrom(
            backgroundColor: _baseColor,
            padding: EdgeInsets.symmetric(
              vertical: isLargeScreen ? 16 : 12,
              horizontal: isLargeScreen ? 32 : 24
            ),
          ),
        ),
      ],
    );
  }

  void _submitProposal() {
    final price = double.tryParse(_priceController.text);
    if (price != null && price > 0) {
      // TODO: Implementar lógica de envío con contractData['contract_id']
      Navigator.pop(context);
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
  }

  void _handleDecline() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirm Decline'),
        content: const Text('Are you sure you want to decline this contract?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              // TODO: Implementar lógica de declive con contractData['contract_id']
              Navigator.pop(context);
            },
            child: const Text('Confirm', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}