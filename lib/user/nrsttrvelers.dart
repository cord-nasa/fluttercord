import 'package:flutter/material.dart';

class NearestTravelersPage extends StatelessWidget {
  final List<Map<String, dynamic>> travelers = [
    {
      "name": "Arun Kumar",
      "vehicle": "Honda City",
      "distance": "1.2 km",
      "phone": "+91 9876543210"
    },
    {
      "name": "Keerthi Raj",
      "vehicle": "Yamaha FZ",
      "distance": "2.4 km",
      "phone": "+91 9123456780"
    },
    {
      "name": "Jeeva",
      "vehicle": "Tata Nexon",
      "distance": "3.1 km",
      "phone": "+91 9988776655"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff6f7fb),
      appBar: AppBar(
        title: Text("Nearest Travelers"),
        backgroundColor: Color(0xff1A73E8),
        elevation: 0,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: travelers.length,
          itemBuilder: (context, index) {
            final t = travelers[index];

            return Card(
              elevation: 6,
              margin: EdgeInsets.only(bottom: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.white,
                      Color(0xffe8f0fe),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      t["name"],
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff1A237E),
                      ),
                    ),

                    SizedBox(height: 6),

                    Row(
                      children: [
                        Icon(Icons.directions_car, color: Colors.blue),
                        SizedBox(width: 8),
                        Text(
                          t["vehicle"],
                          style: TextStyle(fontSize: 16, color: Colors.black87),
                        ),
                      ],
                    ),

                    SizedBox(height: 6),

                    Row(
                      children: [
                        Icon(Icons.location_on, color: Colors.red),
                        SizedBox(width: 8),
                        Text(
                          "${t["distance"]} away",
                          style: TextStyle(fontSize: 16, color: Colors.black87),
                        ),
                      ],
                    ),

                    SizedBox(height: 14),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xff1A73E8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text("Request Ride"),
                        ),

                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xff34A853),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text("Request Parcel"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
