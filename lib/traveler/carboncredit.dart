import 'package:flutter/material.dart';

class DriverEcoRewardsScreen extends StatelessWidget {
  const DriverEcoRewardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7F5), // Soft eco-grey
      appBar: AppBar(
        title: const Text("Eco-Earnings", style: TextStyle(fontWeight: FontWeight.w800)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
        actions: [
          IconButton(icon: const Icon(Icons.help_outline), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMainStatsCard(),
            const SizedBox(height: 20),
            _buildMilestoneProgress(),
            const SizedBox(height: 25),
            const Text("Your Efficiency Breakdown", 
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            _buildEfficiencyGrid(),
            const SizedBox(height: 25),
            _buildActionableRewards(),
          ],
        ),
      ),
    );
  }

  Widget _buildMainStatsCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF1B4332), // Deep Forest Green
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("CURRENT BALANCE", style: TextStyle(color: Colors.white60, letterSpacing: 1.2, fontSize: 12)),
                  Text("2,840 CC", style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(color: Colors.greenAccent.withOpacity(0.2), borderRadius: BorderRadius.circular(20)),
                child: const Row(
                  children: [
                    Icon(Icons.trending_up, color: Colors.greenAccent, size: 16),
                    Text(" +12%", style: TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold)),
                  ],
                ),
              )
            ],
          ),
          const SizedBox(height: 20),
          const Divider(color: Colors.white10),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _simpleMetric("CO2 Offset", "142kg"),
              _simpleMetric("Fuel Saved", "24L"),
              _simpleMetric("Eco-Trips", "89"),
            ],
          )
        ],
      ),
    );
  }

  Widget _simpleMetric(String label, String value) {
    return Column(
      children: [
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(color: Colors.white54, fontSize: 11)),
      ],
    );
  }

  Widget _buildMilestoneProgress() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.workspace_premium, color: Colors.amber, size: 40),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Level 4: Green Guardian", style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: 0.8,
                        minHeight: 8,
                        backgroundColor: Colors.grey.shade100,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text("Earn 160 more credits to unlock 5% extra payout!", 
              style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildEfficiencyGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 15,
      mainAxisSpacing: 15,
      children: [
        _efficiencyCard("Route Savings", "85%", Icons.alt_route, Colors.blue),
        _efficiencyCard("Idle Reduction", "12m/day", Icons.timer_outlined, Colors.orange),
      ],
    );
  }

  Widget _efficiencyCard(String title, String val, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(backgroundColor: color.withOpacity(0.1), radius: 20, child: Icon(icon, color: color)),
          const Spacer(),
          Text(val, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          Text(title, style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildActionableRewards() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Available Rewards", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: Colors.green.shade100, borderRadius: BorderRadius.circular(12)),
            child: const Icon(Icons.local_gas_station, color: Colors.green),
          ),
          title: const Text("₹500 Fuel Voucher"),
          subtitle: const Text("Redeem for 1500 CC"),
          trailing: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(backgroundColor: Colors.black, foregroundColor: Colors.white),
            child: const Text("Redeem"),
          ),
        ),
      ],
    );
  }
}