import 'package:cord/sendcomplaints.dart';
import 'package:flutter/material.dart';
import 'Reqparcel.dart';
import 'ReQride.dart';
import 'nrsttrvelers.dart';
import 'trackride.dart';
import 'givefdbk.dart';
import 'viewtravelroute.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xff6A11CB), Color(0xff2575FC)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: const Text("Community Cab & Parcel", 
          style: TextStyle(color: Colors.white)
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const Text(
              "Welcome User 👋",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              "Choose a service to continue",
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),

            const SizedBox(height: 30),

            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                childAspectRatio: 1.05,
                mainAxisSpacing: 20,
                crossAxisSpacing: 20,
                children: [

                  _homeCard(
                    context,
                    title: "Book Parcel",
                    icon: Icons.local_shipping_outlined,
                    color: Colors.blueAccent,
                    page: ParcelBookingPage(),
                  ),

                  _homeCard(
                    context,
                    title: "Book Ride",
                    icon: Icons.directions_car_outlined,
                    color: Colors.deepPurple,
                    page: RideApp(),
                  ),

                  _homeCard(
                    context,
                    title: "Nearest Travelers",
                    icon: Icons.person_pin_circle_outlined,
                    color: Colors.green,
                    page: NearestTravelersPage(),
                  ),

                  _homeCard(
                    context,
                    title: "Track Ride",
                    icon: Icons.location_searching,
                    color: Colors.orange,
                    page: TrackRidePage(),
                  ),

                  _homeCard(
                    context,
                    title: "Travel Routes",
                    icon: Icons.alt_route,
                    color: Colors.redAccent,
                    page: TravelRouteApp(),
                  ),

                  _homeCard(
                    context,
                    title: "Send Complaint",
                    icon: Icons.report_problem_outlined,
                    color: Colors.pink,
                    page: ComplaintPage(),
                  ),

                  _homeCard(
                    context,
                    title: "Give Feedback",
                    icon: Icons.feedback_outlined,
                    color: Colors.teal,
                    page: FeedbackPage(),
                  ),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------- Home Feature Card ----------
  Widget _homeCard(BuildContext context,
      {required String title,
      required IconData icon,
      required Color color,
      required Widget page}) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => page));
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 32,
              backgroundColor: color.withOpacity(0.15),
              child: Icon(icon, color: color, size: 32),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            )
          ],
        ),
      ),
    );
  }
}
