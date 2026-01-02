import 'package:cord/traveler/addtravelroute.dart';
import 'package:cord/traveler/viewearnings.dart';
import 'package:cord/traveler/viewfeedback.dart';
import 'package:cord/traveler/locateuser.dart';
import 'package:cord/traveler/verifybooking.dart';
import 'package:cord/user/loginpage.dart';
import 'package:flutter/material.dart';

class TravelerHomePage extends StatelessWidget {
  const TravelerHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Soft mint background to match the eco-theme
      backgroundColor: const Color(0xFFF0F4F0),
      body: Stack(
        children: [
          // 1. Forest Gradient Header (Slightly taller for better visual balance)
          _buildHeaderBackground(),

          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 2. Custom Navigation Bar
                _buildTopBar(context),

                const SizedBox(height: 20),

                // 3. Welcome Section (Simplified without Stats)
                _buildWelcomeHeader(),

                const SizedBox(height: 35),

                // 4. White Body Sheet
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 20,
                          offset: Offset(0, -5),
                        )
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                      ),
                      child: GridView.count(
                        padding: const EdgeInsets.fromLTRB(24, 40, 24, 24),
                        crossAxisCount: 2,
                        childAspectRatio: 0.88,
                        mainAxisSpacing: 20,
                        crossAxisSpacing: 20,
                        physics: const BouncingScrollPhysics(),
                        children: [
                          _homeCard(
                            context,
                            title: "Locate Users",
                            subtitle: "Find active requests",
                            icon: Icons.person_search_rounded,
                            color: const Color(0xFF2E7D32),
                            page: const LocateUsersPage(),
                          ),
                          _homeCard(
                            context,
                            title: "Verify Bookings",
                            subtitle: "Confirm pickups",
                            icon: Icons.qr_code_scanner_rounded,
                            color: const Color(0xFF1565C0),
                            page: const VerifyPickupDropPage(),
                          ),
                          _homeCard(
                            context,
                            title: "View Earnings",
                            subtitle: "Check your balance",
                            icon: Icons.account_balance_wallet_rounded,
                            color: Colors.teal.shade700,
                            page: const ViewEarningsPage(),
                          ),
                          _homeCard(
                            context,
                            title: "Add Route",
                            subtitle: "Post your journey",
                            icon: Icons.add_road_rounded,
                            color: Colors.orange.shade800,
                            page: const AddTravelRoutePage(),
                          ),
                          _homeCard(
                            context,
                            title: "View Feedback",
                            subtitle: "Driver rating",
                            icon: Icons.stars_rounded,
                            color: Colors.redAccent.shade700,
                            page: const ViewFeedbackPage(),
                          ),
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

  // --- UI: Header Gradient with Abstract Decoration ---
  Widget _buildHeaderBackground() {
    return Container(
      height: 320,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF00332E), // Deep Dark Green
            Color(0xFF1B5E20), // Forest Green
            Color(0xFF2E7D32), // Emerald
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -40,
            right: -40,
            child: CircleAvatar(
              radius: 100,
              backgroundColor: Colors.white.withOpacity(0.05),
            ),
          ),
        ],
      ),
    );
  }

  // --- UI: Top Bar ---
  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "CORD TRAVELER",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.8,
                ),
              ),
              Text(
                "Partner Dashboard",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(15),
            ),
            child: IconButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => Loginscreen()),
                  (route) => false,
                );
              },
              icon: const Icon(Icons.power_settings_new_rounded, color: Colors.white, size: 24),
            ),
          ),
        ],
      ),
    );
  }

  // --- UI: Welcome Header (Clean & Modern) ---
  Widget _buildWelcomeHeader() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Welcome, Partner! 👋",
            style: TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.5,
            ),
          ),
          SizedBox(height: 8),
          Text(
            "Manage your routes and contribute to a\ngreener planet today.",
            style: TextStyle(
              color: Colors.white70,
              fontSize: 15,
              height: 1.4,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  // --- UI: Enhanced Feature Card ---
  Widget _homeCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required Widget page,
  }) {
    return InkWell(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => page)),
      borderRadius: BorderRadius.circular(28),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: Colors.grey.shade100, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.08),
              blurRadius: 15,
              offset: const Offset(0, 8),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const Spacer(),
            Text(
              title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A1A1A),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey.shade500,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}