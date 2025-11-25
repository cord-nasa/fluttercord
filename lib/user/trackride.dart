import 'package:flutter/material.dart';

class TrackRidePage extends StatefulWidget {
  const TrackRidePage({super.key});

  @override
  State<TrackRidePage> createState() => _TrackRidePageState();
}

class _TrackRidePageState extends State<TrackRidePage> {
  String rideStatus = "On the Way"; 
  // Options: "Waiting for Pickup", "Picked Up", "On the Way", "Completed"

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text("Track Ride"),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        elevation: 0,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            _rideInfoCard(),

            const SizedBox(height: 20),

            _statusTimeline(),

            const SizedBox(height: 20),

            _mapPlaceholder(),

            const SizedBox(height: 20),

            _refreshButton(),
          ],
        ),
      ),
    );
  }

  // -------------------------- RIDE INFO CARD -------------------------------

  Widget _rideInfoCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Ride Details",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple,
            ),
          ),
          const SizedBox(height: 10),

          _infoRow(Icons.person_outline, "Driver: Kishore"),

          _infoRow(Icons.local_taxi_outlined, "Vehicle: Tata Indigo"),

          _infoRow(Icons.phone, "Phone: +91 9876543210"),

          _infoRow(Icons.location_on_outlined, "Pickup: City Bus Stand"),

          _infoRow(Icons.flag_outlined, "Drop: Central Railway Station"),

          const Divider(height: 25),

          _infoRow(Icons.info_outline, "Status: $rideStatus",
              valueColor: Colors.deepPurple),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, {Color valueColor = Colors.black87}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Icon(icon, color: Colors.deepPurple),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: TextStyle(fontSize: 16, color: valueColor),
            ),
          ),
        ],
      ),
    );
  }

  // -------------------------- STATUS TIMELINE -------------------------------

  Widget _statusTimeline() {
    List<String> timeline = [
      "Waiting for Pickup",
      "Picked Up",
      "On the Way",
      "Completed"
    ];

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Ride Progress",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple,
            ),
          ),
          const SizedBox(height: 16),

          Column(
            children: timeline.map((step) {
              bool reached = timeline.indexOf(step) <= timeline.indexOf(rideStatus);
              return _timelineTile(step, reached);
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _timelineTile(String title, bool reached) {
    return Row(
      children: [
        Icon(
          reached ? Icons.check_circle : Icons.radio_button_unchecked,
          color: reached ? Colors.deepPurple : Colors.grey,
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: reached ? FontWeight.bold : FontWeight.normal,
            color: reached ? Colors.deepPurple : Colors.black87,
          ),
        ),
      ],
    );
  }

  // -------------------------- MAP PLACEHOLDER -------------------------------

  Widget _mapPlaceholder() {
    return Container(
      height: 220,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.deepPurple.shade100,
      ),
      child: const Center(
        child: Text(
          "Map Tracking Coming Soon...",
          style: TextStyle(
            color: Colors.deepPurple,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // -------------------------- BUTTON -------------------------------

  Widget _refreshButton() {
    return GestureDetector(
      onTap: () {
        setState(() {
          // For demo only — you can update with backend
        });
      },
      child: Container(
        height: 50,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: const LinearGradient(
            colors: [
              Color(0xff6A11CB),
              Color(0xff2575FC),
            ],
          ),
        ),
        child: const Center(
          child: Text(
            "Refresh Status",
            style: TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
