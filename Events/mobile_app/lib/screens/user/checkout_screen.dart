import 'package:flutter/material.dart';

const Color apexPrimary = Color(0xFF5A67D8);
const Color apexBg = Color(0xFFF8F9FF);
const Color apexText = Color(0xFF0B1C30);

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({Key? key}) : super(key: key);

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  int _selectedTier = 1; // 0: Early, 1: Standard, 2: VIP
  int _selectedPayment = 0; // 0: Card, 1: Apple Pay

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: apexBg,
      appBar: AppBar(
        backgroundColor: apexBg,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: apexText),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Apex Events',
          style: TextStyle(color: apexText, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: false,
        actions: [
          Center(
            child: Container(
              margin: const EdgeInsets.only(right: 20),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text('STEP 2 OF 3', style: TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1)),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Image
            Container(
              height: 120,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                image: const DecorationImage(
                  image: NetworkImage('https://images.unsplash.com/photo-1540575467063-178a50c2df87?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80'),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(Colors.black45, BlendMode.darken),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(color: apexPrimary, borderRadius: BorderRadius.circular(20)),
                      child: const Text('FEATURED EVENT', style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold)),
                    ),
                    const Spacer(),
                    const Text('Global Tech Summit 2024', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    const Row(
                      children: [
                        Icon(Icons.calendar_today, color: Colors.white70, size: 12),
                        SizedBox(width: 4),
                        Text('Oct 24-26', style: TextStyle(color: Colors.white70, fontSize: 10)),
                        SizedBox(width: 12),
                        Icon(Icons.location_on_outlined, color: Colors.white70, size: 12),
                        SizedBox(width: 4),
                        Text('Convention Center, NYC', style: TextStyle(color: Colors.white70, fontSize: 10)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Select Your Experience
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Select Your\nExperience', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: apexText, height: 1.2)),
                Text('3 Tiers\nAvailable', textAlign: TextAlign.right, style: TextStyle(fontSize: 12, color: Colors.grey[600], height: 1.2)),
              ],
            ),
            const SizedBox(height: 20),

            // Tiers
            _buildTierCard(
              index: 0,
              icon: Icons.access_time,
              title: 'Early Bird',
              price: '\$299',
              badge: 'Ends Tonight',
              badgeColor: Colors.red[100]!,
              badgeTextColor: Colors.red[700]!,
              features: ['Standard Seating', 'Digital Materials', 'Welcome Kit'],
            ),
            _buildTierCard(
              index: 1,
              icon: Icons.confirmation_number_outlined,
              title: 'Standard',
              price: '\$499',
              badge: 'MOST POPULAR',
              badgeColor: apexPrimary,
              badgeTextColor: Colors.white,
              features: ['Preferred Seating', 'Networking Access', 'Lunch Included'],
            ),
            _buildTierCard(
              index: 2,
              icon: Icons.star_border,
              title: 'VIP Luxe',
              price: '\$899',
              badge: '',
              badgeColor: Colors.transparent,
              badgeTextColor: Colors.transparent,
              features: ['Front Row Access', 'Private Lounge', '1-on-1 Mentorship'],
            ),
            const SizedBox(height: 30),

            // Payment Method
            const Text('Payment Method', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: apexText)),
            const SizedBox(height: 16),
            _buildPaymentOption(0, Icons.credit_card, 'Credit / Debit Card'),
            const SizedBox(height: 12),
            if (_selectedPayment == 0) _buildCreditCardForm(),
            if (_selectedPayment == 0) const SizedBox(height: 12),
            _buildPaymentOption(1, Icons.apple, 'Apple Pay'),
            const SizedBox(height: 30),

            // Booking Summary
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFE0E7FF).withOpacity(0.5),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Booking Summary', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: apexText)),
                  const SizedBox(height: 20),
                  _buildSummaryRow('Standard Ticket x 1', '\$499.00'),
                  const SizedBox(height: 12),
                  _buildSummaryRow('Processing Fee (2.5%)', '\$12.48'),
                  const SizedBox(height: 12),
                  _buildSummaryRow('Tax (GST 8%)', '\$39.92'),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 44,
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                          child: const TextField(
                            decoration: InputDecoration(
                              hintText: 'Promo Code',
                              hintStyle: TextStyle(fontSize: 12),
                              contentPadding: EdgeInsets.symmetric(horizontal: 16),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        height: 44,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(8)),
                        alignment: Alignment.center,
                        child: const Text('Apply', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Divider(),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text('Total', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: apexText)),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text('\$551.40', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: apexPrimary)),
                          const SizedBox(height: 4),
                          Text('CHARGED IN USD', style: TextStyle(fontSize: 8, color: Colors.grey[600], letterSpacing: 1)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.lock_outline, size: 16, color: Colors.white),
                      label: const Text('Complete Booking', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: apexPrimary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.security, size: 12, color: Colors.grey[500]),
                      const SizedBox(width: 6),
                      Text('SECURE 256-BIT SSL CHECKOUT', style: TextStyle(fontSize: 8, color: Colors.grey[500], letterSpacing: 1, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            
            // Footer Info
            _buildFooterInfo(Icons.verified_user_outlined, 'Apex Verified Partner.', 'Your purchase is protected by our global event insurance policy.'),
            const SizedBox(height: 12),
            _buildFooterInfo(Icons.event_available_outlined, 'Flexible Refunds.', 'Full refund available if cancelled within 24 hours of booking.'),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildTierCard({
    required int index,
    required IconData icon,
    required String title,
    required String price,
    required String badge,
    required Color badgeColor,
    required Color badgeTextColor,
    required List<String> features,
  }) {
    final isSelected = _selectedTier == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedTier = index),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isSelected ? apexPrimary : Colors.transparent, width: 2),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (badge.isNotEmpty)
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(color: badgeColor, borderRadius: BorderRadius.circular(20)),
                  child: Text(badge, style: TextStyle(color: badgeTextColor, fontSize: 8, fontWeight: FontWeight.bold, letterSpacing: 1)),
                ),
              ),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: const Color(0xFFE0E7FF), borderRadius: BorderRadius.circular(8)),
              child: Icon(icon, color: apexPrimary, size: 16),
            ),
            const SizedBox(height: 16),
            Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: apexText)),
            const SizedBox(height: 4),
            Text(price, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: apexPrimary)),
            const SizedBox(height: 16),
            ...features.map((f) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Icon(Icons.check_circle_outline, size: 14, color: apexPrimary.withOpacity(0.8)),
                  const SizedBox(width: 8),
                  Text(f, style: TextStyle(fontSize: 12, color: Colors.grey[700])),
                ],
              ),
            )).toList(),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => setState(() => _selectedTier = index),
                style: OutlinedButton.styleFrom(
                  backgroundColor: isSelected ? apexPrimary : Colors.transparent,
                  foregroundColor: isSelected ? Colors.white : apexPrimary,
                  side: BorderSide(color: apexPrimary),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: Text(isSelected ? 'Selected' : 'Select'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentOption(int index, IconData icon, String label) {
    final isSelected = _selectedPayment == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedPayment = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSelected ? apexPrimary : Colors.grey[300]!),
        ),
        child: Row(
          children: [
            Icon(icon, color: apexText, size: 20),
            const SizedBox(width: 12),
            Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: apexText)),
            const Spacer(),
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: isSelected ? apexPrimary : Colors.grey[400]!, width: 2),
              ),
              child: isSelected ? Center(child: Container(width: 8, height: 8, decoration: const BoxDecoration(color: apexPrimary, shape: BoxShape.circle))) : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCreditCardForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTextField('Cardholder Name', 'Alex Sterling'),
        const SizedBox(height: 12),
        _buildTextField('Card Number', '**** **** **** 4242', trailingIcon: Icons.credit_card),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(flex: 2, child: _buildTextField('Expiry Date', 'MM/YY')),
            const SizedBox(width: 12),
            Expanded(flex: 1, child: _buildTextField('CVC', '***')),
          ],
        ),
      ],
    );
  }

  Widget _buildTextField(String label, String hint, {IconData? trailingIcon}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 10, color: Colors.grey[600])),
        const SizedBox(height: 4),
        Container(
          height: 44,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: TextField(
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(fontSize: 13, color: Colors.grey[400]),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              suffixIcon: trailingIcon != null ? Icon(trailingIcon, size: 16, color: Colors.grey) : null,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[700])),
        Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: apexText)),
      ],
    );
  }

  Widget _buildFooterInfo(IconData icon, String boldText, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 14, color: apexPrimary),
        const SizedBox(width: 8),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: TextStyle(fontSize: 10, color: Colors.grey[600], height: 1.5),
              children: [
                TextSpan(text: boldText, style: const TextStyle(fontWeight: FontWeight.bold, color: apexText)),
                const TextSpan(text: ' '),
                TextSpan(text: text),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
