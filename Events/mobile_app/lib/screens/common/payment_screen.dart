import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/event.dart';
import '../../providers/event_provider.dart';

class PaymentScreen extends StatefulWidget {
  final Event event;
  const PaymentScreen({Key? key, required this.event}) : super(key: key);

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  bool _isProcessing = false;
  final Color apexPrimary = const Color(0xFF5A67D8);

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
    final theme = Theme.of(context);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: theme.cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 80),
            const SizedBox(height: 24),
            Text("Payment Successful!", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: theme.textTheme.bodyLarge?.color)),
            const SizedBox(height: 12),
            Text("You have successfully booked a ticket for ${widget.event.title}.", textAlign: TextAlign.center, style: TextStyle(color: Colors.grey[500])),
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
    final theme = Theme.of(context);
    final textColor = theme.textTheme.bodyLarge?.color ?? Colors.black87;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text("Checkout", style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: textColor),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildOrderSummary(theme, textColor),
            const SizedBox(height: 32),
            Text("Payment Method", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor)),
            const SizedBox(height: 16),
            _buildPaymentMethodCard(),
            const SizedBox(height: 32),
            Text("Card Details", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor)),
            const SizedBox(height: 16),
            _buildCardInputFields(theme),
            const SizedBox(height: 48),
            _buildPayButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderSummary(ThemeData theme, Color textColor) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: theme.cardColor, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 15, offset: const Offset(0, 5))]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Event Ticket", style: TextStyle(fontSize: 16, color: Colors.grey)),
              Text("${widget.event.title}", style: TextStyle(fontWeight: FontWeight.bold, color: textColor)),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Total Amount", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor)),
              Text("\$${widget.event.price?.toStringAsFixed(2) ?? '0.00'}", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: apexPrimary)),
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
          Icon(Icons.credit_card, color: apexPrimary),
          const SizedBox(width: 16),
          Text("Credit / Debit Card", style: TextStyle(fontWeight: FontWeight.bold, color: apexPrimary)),
          const Spacer(),
          Icon(Icons.check_circle, color: apexPrimary, size: 20),
        ],
      ),
    );
  }

  Widget _buildCardInputFields(ThemeData theme) {
    return Column(
      children: [
        _buildTextField(theme, "Cardholder Name", Icons.person_outline),
        const SizedBox(height: 16),
        _buildTextField(theme, "Card Number", Icons.credit_card, keyboardType: TextInputType.number),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: _buildTextField(theme, "Expiry Date", Icons.calendar_today, keyboardType: TextInputType.datetime)),
            const SizedBox(width: 16),
            Expanded(child: _buildTextField(theme, "CVV", Icons.lock_outline, keyboardType: TextInputType.number)),
          ],
        ),
      ],
    );
  }

  Widget _buildTextField(ThemeData theme, String label, IconData icon, {TextInputType? keyboardType}) {
    return TextFormField(
      keyboardType: keyboardType,
      style: TextStyle(color: theme.textTheme.bodyLarge?.color),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: apexPrimary, size: 20),
        labelStyle: TextStyle(color: Colors.grey[600], fontSize: 14),
        filled: true,
        fillColor: theme.cardColor,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: apexPrimary, width: 1.5)),
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
