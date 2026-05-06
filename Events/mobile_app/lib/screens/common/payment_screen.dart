import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/event.dart';
import '../../providers/event_provider.dart';

const Color apexPrimary = Color(0xFF5A67D8);
const Color apexBg = Color(0xFFF8F9FF);
const Color apexText = Color(0xFF0B1C30);

class PaymentScreen extends StatefulWidget {
  final Event event;
  const PaymentScreen({Key? key, required this.event}) : super(key: key);

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  bool _isProcessing = false;

  void _processPayment() async {
    setState(() => _isProcessing = true);
    
    // Simulate payment processing
    await Future.delayed(const Duration(seconds: 2));
    
    if (mounted) {
      final eventProvider = Provider.of<EventProvider>(context, listen: false);
      eventProvider.bookTicket(widget.event.id);
      
      setState(() => _isProcessing = false);
      
      _showSuccessDialog();
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 80),
            const SizedBox(height: 24),
            const Text("Payment Successful!", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Text("You have successfully booked a ticket for ${widget.event.title}.", textAlign: TextAlign.center, style: TextStyle(color: Colors.grey[600])),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(ctx); // Close dialog
                  Navigator.pop(context); // Back to detail
                },
                style: ElevatedButton.styleFrom(backgroundColor: apexPrimary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), padding: const EdgeInsets.symmetric(vertical: 16)),
                child: const Text("Done", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: apexBg,
      appBar: AppBar(
        title: const Text("Checkout", style: TextStyle(color: apexText, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: apexText),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildOrderSummary(),
            const SizedBox(height: 32),
            const Text("Payment Method", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: apexText)),
            const SizedBox(height: 16),
            _buildPaymentMethodCard(),
            const SizedBox(height: 32),
            const Text("Card Details", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: apexText)),
            const SizedBox(height: 16),
            _buildCardInputFields(),
            const SizedBox(height: 48),
            _buildPayButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderSummary() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 15, offset: const Offset(0, 5))]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Event Ticket", style: TextStyle(fontSize: 16, color: Colors.grey)),
              Text("${widget.event.title}", style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Total Amount", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: apexText)),
              Text("\$${widget.event.price?.toStringAsFixed(2) ?? '0.00'}", style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: apexPrimary)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: apexPrimary.withOpacity(0.05), borderRadius: BorderRadius.circular(15), border: Border.all(color: apexPrimary.withOpacity(0.2))),
      child: Row(
        children: [
          const Icon(Icons.credit_card, color: apexPrimary),
          const SizedBox(width: 16),
          const Text("Credit / Debit Card", style: TextStyle(fontWeight: FontWeight.bold, color: apexPrimary)),
          const Spacer(),
          const Icon(Icons.check_circle, color: apexPrimary, size: 20),
        ],
      ),
    );
  }

  Widget _buildCardInputFields() {
    return Column(
      children: [
        _buildTextField("Cardholder Name", Icons.person_outline),
        const SizedBox(height: 16),
        _buildTextField("Card Number", Icons.credit_card, keyboardType: TextInputType.number),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: _buildTextField("Expiry Date", Icons.calendar_today, keyboardType: TextInputType.datetime)),
            const SizedBox(width: 16),
            Expanded(child: _buildTextField("CVV", Icons.lock_outline, keyboardType: TextInputType.number)),
          ],
        ),
      ],
    );
  }

  Widget _buildTextField(String label, IconData icon, {TextInputType? keyboardType}) {
    return TextFormField(
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: apexPrimary, size: 20),
        labelStyle: TextStyle(color: Colors.grey[600], fontSize: 14),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: apexPrimary, width: 1.5)),
      ),
    );
  }

  Widget _buildPayButton() {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        onPressed: _isProcessing ? null : _processPayment,
        style: ElevatedButton.styleFrom(
          backgroundColor: apexPrimary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          elevation: 5,
          shadowColor: apexPrimary.withOpacity(0.3),
        ),
        child: _isProcessing
            ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
            : Text("Pay \$${widget.event.price?.toStringAsFixed(2) ?? '0.00'}", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
      ),
    );
  }
}
