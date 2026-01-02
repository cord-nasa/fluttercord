import 'package:cord/user/bookinghistory.dart';
import 'package:cord/user/loginpage.dart';
import 'package:cord/user/sendcomplaints.dart' hide ComplaintPage;
import 'package:flutter/material.dart';
import 'package:cord/user/Reqparcel.dart';
import 'package:cord/user/Reqride.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Soft background color for a clean eco-look
      backgroundColor: const Color(0xFFF8FAF8),
      body: Stack(
        children: [
          // 1. Modern Curved Gradient Header
          _buildHeaderBackground(),

          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 2. Refined App Bar
                _buildCustomAppBar(context),

                const SizedBox(height: 20),

                // 3. Personalized Greeting
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Welcome back, User 👋",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Which eco-friendly service do you need today?",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white.withOpacity(0.85),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 35),

                // 4. Grid Container with rounded corners
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                      ),
                      child: GridView.count(
                        padding: const EdgeInsets.fromLTRB(24, 40, 24, 24),
                        crossAxisCount: 2,
                        childAspectRatio: 0.9,
                        mainAxisSpacing: 20,
                        crossAxisSpacing: 20,
                        children: [
                          _homeCard(
                            context,
                            title: "Book Parcel",
                            icon: Icons.local_shipping_outlined,
                            color: const Color(0xFF2E7D32), // Emerald Green
                            page: const ParcelBookingPage(),
                          ),
                          _homeCard(
                            context,
                            title: "Book Ride",
                            icon: Icons.directions_car_outlined,
                            color: const Color(0xFF1565C0), // Royal Blue
                            page: const RideBookingPage(),
                          ),
                          _homeCard(
                            context,
                            title: "BOOKING HISTORY",
                            icon: Icons.history_rounded,
                            color: const Color(0xFF00897B), // Teal
                            page: const BookingHistoryPage(),
                          ),
                          // You can uncomment your other cards here later
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- UI Component: Header Gradient and Curve ---
  Widget _buildHeaderBackground() {
    return Container(
      height: 320,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF1B5E20), // Dark Green
            Color(0xFF43A047), // Light Green
            Color(0xFF2196F3), // Flutter Blue
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(80),
        ),
      ),
    );
  }

  // --- UI Component: Custom App Bar ---
  Widget _buildCustomAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text(
              "Eco Cab & Parcel",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 18,
                letterSpacing: 1,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => Loginscreen()),
                  (route) => false,
                );
              },
              icon: const Icon(Icons.logout_rounded, color: Colors.white, size: 22),
            ),
          ),
        ],
      ),
    );
  }

  // ---------- Enhanced Home Feature Card ----------
  Widget _homeCard(BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required Widget page,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => page));
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.12),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
          border: Border.all(
            color: Colors.grey.shade100,
            width: 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon Container with soft background
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: color,
                size: 36,
              ),
            ),
            const SizedBox(height: 16),
            // Text with better contrast
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}