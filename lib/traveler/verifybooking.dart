import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

// Maintaining your specific imports
import 'package:cord/user/loginpage.dart'; 
import 'package:cord/user/reg.dart';

class VerifyPickupDropPage extends StatefulWidget {
  const VerifyPickupDropPage({super.key});

  @override
  State<VerifyPickupDropPage> createState() => _VerifyPickupDropPageState();
}

class _VerifyPickupDropPageState extends State<VerifyPickupDropPage> {
  final Dio _dio = Dio();
  bool _isLoading = false;
  List<dynamic> _bookings = [];
  
  final Map<String, TextEditingController> _otpControllers = {};
  final Map<String, TextEditingController> _pickupControllers = {};
  final Map<String, TextEditingController> _dropControllers = {};
  final Map<String, bool> _isVerifying = {}; 

  @override
  void initState() {
    super.initState();
    fetchBookingData();
  }

  @override
  void dispose() {
    for (var c in _otpControllers.values) c.dispose();
    for (var c in _pickupControllers.values) c.dispose();
    for (var c in _dropControllers.values) c.dispose();
    super.dispose();
  }

  // --- LOGIC FUNCTIONS ---

  Future<void> fetchBookingData() async {
    setState(() => _isLoading = true);
    try {
      Response response = await _dio.get("$baseurl/VerifyRideBookingAPI/$loginid");
      print(response.data);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final List<dynamic> data = response.data is List ? response.data : [response.data];
        
        setState(() {
          _bookings = data;
          for (var booking in _bookings) {
            String id = booking['id'].toString();
            if (!_otpControllers.containsKey(id)) {
              _otpControllers[id] = TextEditingController();
              _isVerifying[id] = false; 
              _pickupControllers[id] = TextEditingController(
                text: booking['PickupLocation']?.toString() ?? "No Pickup Address"
              );
              _dropControllers[id] = TextEditingController(
                text: booking['DropLocation']?.toString() ?? "No Drop Address"
              );
            }
          }
        });
      }
    } catch (e) {
      _showSnackBar("Error loading bookings", Colors.red);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> submitVerification(String bookingId) async {
    final String otp = _otpControllers[bookingId]?.text ?? "";
    if (otp.isEmpty) {
      _showSnackBar("Please enter OTP", Colors.orange);
      return;
    }

    setState(() => _isLoading = true);
    try {
      final response = await _dio.post("$baseurl/verify_otp", data: {
        "booking_id": bookingId,
        "otp": otp,
        "pickup_address": _pickupControllers[bookingId]?.text,
        "drop_address": _dropControllers[bookingId]?.text,
        "status": "verified"
      });

      if (response.statusCode == 200 || response.statusCode == 201) {
        _showSnackBar("Verified! Thank you for sharing your route.", Colors.green);
        fetchBookingData(); 
      }
    } catch (e) {
      _showSnackBar("Verification Failed", Colors.red);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> submitRejection(String bookingId) async {
    bool confirm = await _showConfirmDialog(bookingId);
    if (!confirm) return;

    setState(() => _isLoading = true);
    try {
      await _dio.post("$baseurl/reject_booking_api", data: {
        "booking_id": bookingId,
        "rejected_by": loginid,
        "status": "rejected"
      });
      _showSnackBar("Request Declined", Colors.brown);
      fetchBookingData();
    } catch (e) {
      _showSnackBar("Rejection Failed", Colors.red);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<bool> _showConfirmDialog(String id) async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Decline Request?"),
        content: const Text("Declining helps keep routes optimized. Confirm rejection?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Back", style: TextStyle(color: Colors.grey))),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true), 
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade400, shape: const StadiumBorder()),
            child: const Text("Decline", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    ) ?? false;
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: color, behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
    );
  }

  // --- UI BUILDING ---

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F8E9), 
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF2E7D32), Color(0xFF81C784)], 
            ),
          ),
        ),
        title: const Text("Route Verifier", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
        actions: [
          IconButton(onPressed: fetchBookingData, icon: const Icon(Icons.eco, color: Colors.white))
        ],
      ),
      body: _isLoading && _bookings.isEmpty 
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF2E7D32)))
          : _bookings.isEmpty 
              ? _buildEmptyState()
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
                  itemCount: _bookings.length,
                  itemBuilder: (context, index) => _buildBookingCard(_bookings[index]),
                ),
    );
  }

  Widget _buildBookingCard(Map<String, dynamic> booking) {
    String id = booking['id'].toString();
    bool verifying = _isVerifying[id] ?? false;
    bool isParcel = (booking['RideType'] ?? "").toString().toLowerCase().contains('parcel');
    
    // Dynamic Labels for Space Availability
    String spaceLabel = isParcel ? "WEIGHT" : "SPACE";
    String spaceValue = isParcel 
        ? "${booking['spaceavailability'] ?? '0'} KG" 
        : "${booking['spaceavailability'] ?? '0'} ";
    IconData spaceIcon = isParcel ? Icons.monitor_weight_outlined : Icons.event_seat_outlined;

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5))
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              color: const Color(0xFFE8F5E9),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(isParcel ? Icons.inventory_2_outlined : Icons.directions_car_filled, color: const Color(0xFF2E7D32)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(booking['Name'] ?? "Requester", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF1B5E20))),
                        Text("Contact No: ${booking['PhoneNo']}", style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                      ],
                    ),
                  ),
                  _badge(booking['RideType'] ?? "Ride"),
                ],
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Start Time, Availability, and Fare Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // 1. SCHEDULE
                      Expanded(
                        flex: 3,
                        child: Column(
                          children: [
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.access_time, size: 14, color: Color(0xFF81C784)),
                                SizedBox(width: 4),
                                Text("SCHEDULE", style: TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
                              ],
                            ),
                            const SizedBox(height: 4),
                            FittedBox(
                              child: Row(
                                children: [
                                  Text("${booking['StartingTime']}", style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF2E7D32))),
                                  const Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 6),
                                    child: Icon(Icons.arrow_forward, size: 12, color: Colors.grey),
                                  ),
                                  Text("${booking['EndingTime']}", style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF2E7D32))),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      _vDivider(),

                      // 2. SPACE AVAILABILITY (Added Field)
                      Expanded(
                        flex: 2,
                        child: _infoBlock(spaceIcon, spaceLabel, spaceValue),
                      ),

                      _vDivider(),

                      // 3. FARE
                      Expanded(
                        flex: 2,
                        child: _infoBlock(Icons.payments_outlined, "FARE", "₹${booking['Amount']}"),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  
                  _addressRow(Icons.radio_button_checked, Colors.green, _pickupControllers[id]!, "Pickup"),
                  Padding(
                    padding: const EdgeInsets.only(left: 11),
                    child: Align(alignment: Alignment.centerLeft, child: Container(width: 2, height: 20, color: Colors.grey.shade200)),
                  ),
                  _addressRow(Icons.location_on, Colors.orange.shade700, _dropControllers[id]!, "Drop-off"),
                  
                  const SizedBox(height: 25),

                  if (!verifying) ...[
                    Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: () => submitRejection(id),
                            style: TextButton.styleFrom(foregroundColor: Colors.brown.shade400),
                            child: const Text("Decline", style: TextStyle(fontWeight: FontWeight.w600)),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => setState(() => _isVerifying[id] = true),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF2E7D32),
                              elevation: 0,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              padding: const EdgeInsets.symmetric(vertical: 15),
                            ),
                            child: const Text("VERIFY NOW", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
                    )
                  ] else ...[
                    TweenAnimationBuilder(
                      duration: const Duration(milliseconds: 300),
                      tween: Tween<double>(begin: 0, end: 1),
                      builder: (context, double value, child) {
                        return Opacity(opacity: value, child: child);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF9FBE7),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: const Color(0xFFDCEDC8))
                        ),
                        child: Column(
                          children: [
                            const Text("Secure OTP Verification", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF558B2F))),
                            const SizedBox(height: 12),
                            TextField(
                              controller: _otpControllers[id],
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              maxLength: 4,
                              style: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 10, fontSize: 20, color: Color(0xFF2E7D32)),
                              decoration: InputDecoration(
                                counterText: "",
                                hintText: "••••",
                                hintStyle: const TextStyle(letterSpacing: 10),
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                                contentPadding: const EdgeInsets.symmetric(vertical: 10),
                              ),
                            ),
                            const SizedBox(height: 15),
                            Row(
                              children: [
                                TextButton(
                                  onPressed: () => setState(() => _isVerifying[id] = false),
                                  child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
                                ),
                                const Spacer(),
                                ElevatedButton(
                                  onPressed: () => submitVerification(id),
                                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF558B2F), shape: const StadiumBorder()),
                                  child: const Text("SUBMIT OTP", style: TextStyle(color: Colors.white)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- HELPER COMPONENTS ---

  Widget _vDivider() => Container(width: 1, height: 30, color: Colors.grey.shade200);

  Widget _addressRow(IconData icon, Color color, TextEditingController controller, String label) {
    return Row(
      children: [
        Icon(icon, color: color, size: 22),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(fontSize: 10, color: Colors.grey.shade500, fontWeight: FontWeight.bold)),
              Text(controller.text, style: const TextStyle(fontSize: 13, color: Color(0xFF37474F), fontWeight: FontWeight.w500), overflow: TextOverflow.ellipsis),
            ],
          ),
        ),
      ],
    );
  }

  Widget _infoBlock(IconData icon, String label, String value) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: const Color(0xFF81C784)),
            const SizedBox(width: 4),
            Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF2E7D32))),
      ],
    );
  }

  Widget _badge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF2E7D32),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(text.toUpperCase(), style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.eco_outlined, size: 80, color: Colors.green.shade200),
          const SizedBox(height: 16),
          Text("All routes are clear!", style: TextStyle(color: Colors.green.shade800, fontSize: 18, fontWeight: FontWeight.bold)),
          const Text("No pending verifications for now.", style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}