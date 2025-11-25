import 'package:flutter/material.dart';

class LocateUsersPage extends StatefulWidget {
  const LocateUsersPage({super.key});

  @override
  State<LocateUsersPage> createState() => _LocateUsersPageState();
}

class _LocateUsersPageState extends State<LocateUsersPage> {
  // Temporary dummy data (replace later with DB results)
  List<Map<String, dynamic>> requests = [
    {
      "name": "Ravi Kumar",
      "type": "Ride Request",
      "pickup": "TNSTC Bus Stand",
      "drop": "Central Railway Station",
      "distance": "1.5 km away",
      "fare": "₹120",
    },
    {
      "name": "Sahana",
      "type": "Parcel Delivery",
      "pickup": "City Mall",
      "drop": "Tech Park Tower A",
      "distance": "2.8 km away",
      "fare": "₹80",
    },
    {
      "name": "Arun",
      "type": "Ride Request",
      "pickup": "ABC College",
      "drop": "Main Market",
      "distance": "900m away",
      "fare": "₹60",
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
        elevation: 0,
        title: const Text("Locate Users", style: TextStyle(color: Colors.white)),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // Search bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.07),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Search by name / route / type",
                  icon: Icon(Icons.search, color: Colors.deepPurple),
                ),
              ),
            ),

            const SizedBox(height: 16),
            const Text(
              "Nearby Requests",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: requests.length,
                itemBuilder: (context, index) {
                  final item = requests[index];

                  return Card(
                    margin: const EdgeInsets.only(bottom: 14),
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      leading: CircleAvatar(
                        radius: 26,
                        backgroundColor: Colors.deepPurple.shade100,
                        child: Icon(
                          item["type"] == "Ride Request"
                              ? Icons.directions_car
                              : Icons.local_shipping,
                          color: Colors.deepPurple,
                          size: 28,
                        ),
                      ),
                      title: Text(
                        item["name"],
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("${item['type']}",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.deepPurple.shade700)),
                          const SizedBox(height: 4),
                          Text("Pickup: ${item['pickup']}"),
                          Text("Drop: ${item['drop']}"),
                          const SizedBox(height: 4),
                          Text(item["distance"], style: const TextStyle(color: Colors.green)),
                        ],
                      ),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(item["fare"],
                              style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black)),
                          const SizedBox(height: 6),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepPurple,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: Colors.deepPurple,
                                  content:
                                      Text("Request from ${item['name']} Accepted"),
                                ),
                              );
                            },
                            child: const Text("Accept",
                                style: TextStyle(color: Colors.white)),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
