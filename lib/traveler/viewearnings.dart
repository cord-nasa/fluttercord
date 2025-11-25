import 'package:flutter/material.dart';

class ViewEarningsPage extends StatefulWidget {
  const ViewEarningsPage({super.key});

  @override
  State<ViewEarningsPage> createState() => _ViewEarningsPageState();
}

class _ViewEarningsPageState extends State<ViewEarningsPage> {
  // Dummy values to be replaced by DB/API later
  double today = 260.0;
  double week = 1840.0;
  double month = 7520.0;

  List<Map<String, dynamic>> tripDetails = [
    {"id": "RB1021", "type": "Ride", "amount": "₹120", "date": "22-11-2025"},
    {"id": "PD503", "type": "Parcel", "amount": "₹80", "date": "21-11-2025"},
    {"id": "RB1020", "type": "Ride", "amount": "₹60", "date": "20-11-2025"},
    {"id": "PD499", "type": "Parcel", "amount": "₹50", "date": "19-11-2025"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "View Earnings",
          style: TextStyle(color: Colors.white),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _earningsCard("Today’s Earnings", "₹$today", Icons.calendar_today),
            _earningsCard("This Week", "₹$week", Icons.date_range),
            _earningsCard("This Month", "₹$month", Icons.payments_rounded),

            const SizedBox(height: 12),
            const Text(
              "Completed Trips",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: tripDetails.length,
                itemBuilder: (context, index) {
                  final item = tripDetails[index];
                  return Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: ListTile(
                      leading: Icon(
                        item["type"] == "Ride"
                            ? Icons.directions_car
                            : Icons.local_shipping,
                        color: Colors.deepPurple,
                        size: 32,
                      ),
                      title: Text("ID: ${item['id']}"),
                      subtitle: Text("Type: ${item['type']}  •  ${item['date']}"),
                      trailing: Text(
                        item["amount"],
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.green),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 10),
            _totalButton("Total Earnings: ₹${today + week + month}"),
          ],
        ),
      ),
    );
  }

  Widget _earningsCard(String title, String value, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.deepPurple, size: 32),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w600)),
              const SizedBox(height: 5),
              Text(value,
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _totalButton(String text) {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          colors: [Color(0xff6A11CB), Color(0xff2575FC)],
        ),
      ),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
