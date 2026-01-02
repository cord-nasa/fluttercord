import 'package:flutter/material.dart';

class ViewEarningsPage extends StatefulWidget {
  const ViewEarningsPage({super.key});

  @override
  State<ViewEarningsPage> createState() => _ViewEarningsPageState();
}

class _ViewEarningsPageState extends State<ViewEarningsPage> {
  // Logic: 5% Commission
  final double commissionRate = 0.05;

  // Mock Raw Earnings Data
  double rawToday = 260.0;
  double rawWeek = 1840.0;
  double rawMonth = 7520.0;
  int totalCarbonCredits = 1250;

  // Redemption Options
  final List<Map<String, dynamic>> redemptionOptions = [
    {"title": "₹100 Cash Bonus", "cost": 500, "icon": Icons.account_balance_wallet, "color": Colors.blue},
    {"title": "₹250 Fuel Voucher", "cost": 1000, "icon": Icons.local_gas_station, "color": Colors.orange},
    {"title": "Eco-Warrior Badge", "cost": 200, "icon": Icons.verified_user, "color": Colors.green},
  ];

  List<Map<String, dynamic>> tripDetails = [
    {"id": "RB1021", "type": "Ride", "amount": 120.0, "date": "22-11-2025", "ccEarned": 15},
    {"id": "PD503", "type": "Parcel", "amount": 80.0, "date": "21-11-2025", "ccEarned": 25},
    {"id": "RB1020", "type": "Ride", "amount": 60.0, "date": "20-11-2025", "ccEarned": 10},
  ];

  // Helper to calculate net amount after 5% cut
  double _getNet(double gross) => gross * (1 - commissionRate);
  double _getCommission(double gross) => gross * commissionRate;

  void _showRedeemDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Redeem Carbon Credits", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text("Your Balance: $totalCarbonCredits CC", style: TextStyle(color: Colors.green.shade700, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            ...redemptionOptions.map((option) {
              bool canAfford = totalCarbonCredits >= option['cost'];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: option['color'].withOpacity(0.1),
                  child: Icon(option['icon'], color: option['color']),
                ),
                title: Text(option['title']),
                subtitle: Text("Costs ${option['cost']} CC"),
                trailing: ElevatedButton(
                  onPressed: canAfford ? () => _processRedemption(option) : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: canAfford ? Colors.deepPurple : Colors.grey,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text("Redeem", style: TextStyle(color: Colors.white)),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  void _processRedemption(Map<String, dynamic> option) {
    setState(() {
      totalCarbonCredits -= option['cost'] as int;
    });
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Success! ${option['title']} added."),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double totalGross = rawToday + rawWeek + rawMonth;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        elevation: 0,
        centerTitle: true,
        title: const Text("Earnings & Rewards", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: Column(
        children: [
          _buildCarbonCreditHeader(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  _earningsRow(),
                  const SizedBox(height: 20),
                  const Text("Recent Activity (Net)", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Expanded(
                    child: ListView.builder(
                      itemCount: tripDetails.length,
                      itemBuilder: (context, index) => _buildTripCard(tripDetails[index]),
                    ),
                  ),
                  _buildSummaryFooter(totalGross),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCarbonCreditHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
      decoration: const BoxDecoration(
        color: Colors.deepPurple,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.12),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white24),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Carbon Credits", style: TextStyle(color: Colors.white70, fontSize: 13)),
                Text("$totalCarbonCredits CC", style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
              ],
            ),
            ElevatedButton(
              onPressed: _showRedeemDialog,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.greenAccent,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text("Redeem"),
            )
          ],
        ),
      ),
    );
  }

  Widget _earningsRow() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: [
          _smallEarningsCard("Today (Net)", _getNet(rawToday), Icons.today),
          _smallEarningsCard("Week (Net)", _getNet(rawWeek), Icons.date_range),
          _smallEarningsCard("Month (Net)", _getNet(rawMonth), Icons.account_balance),
        ],
      ),
    );
  }

  Widget _smallEarningsCard(String title, double value, IconData icon) {
    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.deepPurple, size: 24),
          const SizedBox(height: 12),
          Text(title, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          Text("₹${value.toStringAsFixed(1)}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        ],
      ),
    );
  }

  Widget _buildTripCard(Map<String, dynamic> item) {
    double gross = item['amount'];
    double net = _getNet(gross);

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.deepPurple.shade50,
              child: Icon(item["type"] == "Ride" ? Icons.drive_eta : Icons.inventory_2, color: Colors.deepPurple, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("ID: ${item['id']}", style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text("${item['date']} • Gross: ₹$gross", style: const TextStyle(color: Colors.grey, fontSize: 11)),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text("₹${net.toStringAsFixed(1)}", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blueAccent)),
                Text("CC +${item['ccEarned']}", style: const TextStyle(color: Colors.green, fontSize: 11, fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryFooter(double totalGross) {
    double totalCommission = _getCommission(totalGross);
    double netPayout = _getNet(totalGross);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20)],
      ),
      child: Column(
        children: [
          _summaryRow("Gross Total", "₹${totalGross.toStringAsFixed(1)}", Colors.black87),
          const SizedBox(height: 8),
          _summaryRow("Admin Fee (5%)", "-₹${totalCommission.toStringAsFixed(1)}", Colors.redAccent),
          const Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Total Payout", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text("₹${netPayout.toStringAsFixed(1)}", 
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.deepPurple)),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text("Withdraw Earnings", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryRow(String label, String value, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 14)),
        Text(value, style: TextStyle(color: color, fontWeight: FontWeight.w600, fontSize: 14)),
      ],
    );
  }
}