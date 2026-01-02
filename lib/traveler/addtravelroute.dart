import 'package:cord/user/loginpage.dart';
import 'package:cord/user/reg.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class AddTravelRoutePage extends StatefulWidget {
  const AddTravelRoutePage({super.key});

  @override
  State<AddTravelRoutePage> createState() => _AddTravelRoutePageState();
}

class _AddTravelRoutePageState extends State<AddTravelRoutePage> {
  // Controllers - Maintaining your exact naming convention
  final fromController = TextEditingController();
  final toController = TextEditingController();
  final fareController = TextEditingController();
  final starttimeController = TextEditingController();
  final timeController = TextEditingController();
  final availabilityController = TextEditingController();
  final spaceController = TextEditingController();

  final Dio _dio = Dio();
  bool _isLoading = false;

  String? selectedRideType;
  final rideTypes = ["Ride", "Parcel"];
  final weightOptions = ["3kg", "5kg", "10kg", "15kg", "20kg", "50kg"];
  final seatOptions = ["1 seat", "2 seats", "3 seats", "4 seats", "5 seats"];

  bool get isParcel => selectedRideType == "Parcel";

  /// HH:mm:ss Format for Django
  String _formatTimeForDjango(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return "$hour:$minute:00";
  }

  // ---------------- API ----------------
  Future<void> _sendDataToApi() async {
    if (loginid == null) {
      _showSnackBar("Session expired. Login again.", Colors.red);
      return;
    }

    setState(() => _isLoading = true);

    final apiUrl = "$baseurl/AddTravelRouteAPI/$loginid";

    try {
      final response = await _dio.post(
        apiUrl,
        data: {
          "StartLocation": fromController.text.trim(),
          "EndLocation": toController.text.trim(),
          "RideType": selectedRideType,
          "Amount": fareController.text.trim(),
          "RideAvailability": availabilityController.text.trim(),
          "SpaceAvailability": spaceController.text.trim(),
          "StartingTime": starttimeController.text.trim(),
          "EndingTime": timeController.text.trim(),
          "created_at": DateTime.now().toIso8601String(),
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        _showSnackBar("Route saved successfully! 🌱", Colors.green);
        _clearForm();
      } else {
        _showSnackBar("Server error", Colors.red);
      }
    } on DioException catch (e) {
      debugPrint("Dio Error: ${e.response?.data}");
      _showSnackBar("Failed to save route", Colors.red);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _clearForm() {
    fromController.clear();
    toController.clear();
    fareController.clear();
    starttimeController.clear();
    timeController.clear();
    availabilityController.clear();
    spaceController.clear();
    setState(() => selectedRideType = null);
  }

  void _showSnackBar(String msg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  // ---------------- TIME PICKERS ----------------
  Future<void> _pickStartTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) => Theme(
        data: ThemeData.light().copyWith(
          colorScheme: const ColorScheme.light(primary: Color(0xFF2E7D32)),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() => starttimeController.text = _formatTimeForDjango(picked));
    }
  }

  Future<void> _pickEndTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) => Theme(
        data: ThemeData.light().copyWith(
          colorScheme: const ColorScheme.light(primary: Color(0xFF2E7D32)),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() => timeController.text = _formatTimeForDjango(picked));
    }
  }

  Future<void> _addRoute() async {
    if (fromController.text.isEmpty ||
        toController.text.isEmpty ||
        selectedRideType == null ||
        spaceController.text.isEmpty ||
        starttimeController.text.isEmpty ||
        timeController.text.isEmpty) {
      _showSnackBar("Please fill all required fields", Colors.orange);
      return;
    }
    await _sendDataToApi();
  }

  // ---------------- UI ----------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F8E9), // Light Eco-Green Background
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF1B5E20), Color(0xFF4CAF50)],
            ),
          ),
        ),
        centerTitle: true,
        title: const Text(
          "Add Eco Route",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Eco Impact Header Banner
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFDCEDC8),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: const Color(0xFFAED581)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.eco, color: Color(0xFF2E7D32)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      "Share your ride and help lower CO2 emissions!",
                      style: TextStyle(
                        color: Colors.green.shade900,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _header("Route Details"),
                  _input(fromController, Icons.my_location, "From Location", iconColor: Colors.green),
                  _input(toController, Icons.location_on, "Destination", iconColor: Colors.redAccent),

                  _header("Sharing Type"),
                  _rideTypeDropdown(),

                  if (selectedRideType != null) ...[
                    _header(isParcel ? "Select Weight Capacity" : "Select Available Seats"),
                    SizedBox(
                      height: 48,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: isParcel ? weightOptions.length : seatOptions.length,
                        itemBuilder: (context, index) {
                          final option = isParcel ? weightOptions[index] : seatOptions[index];
                          bool isSelected = spaceController.text == option;
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: ChoiceChip(
                              label: Text(option),
                              selected: isSelected,
                              selectedColor: const Color(0xFF2E7D32),
                              labelStyle: TextStyle(
                                color: isSelected ? Colors.white : Colors.black87,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              ),
                              onSelected: (_) => setState(() => spaceController.text = option),
                            ),
                          );
                        },
                      ),
                    ),
                  ],

                  _header("Fare & Availability"),
                  _input(fareController, Icons.payments_outlined, "Amount (₹)", number: true),
                  _input(availabilityController, Icons.calendar_month, "Days (e.g., Mon-Fri)"),

                  _header("Timings"),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: _pickStartTime,
                          child: AbsorbPointer(
                            child: _input(starttimeController, Icons.login, "Start Time", readOnly: true),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: GestureDetector(
                          onTap: _pickEndTime,
                          child: AbsorbPointer(
                            child: _input(timeController, Icons.logout, "End Time", readOnly: true),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),
                  _submitButton(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _header(String text) => Padding(
        padding: const EdgeInsets.only(top: 20, bottom: 10),
        child: Text(
          text,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: Color(0xFF1B5E20),
            letterSpacing: 0.5,
          ),
        ),
      );

  Widget _input(TextEditingController c, IconData icon, String hint,
      {bool number = false, bool readOnly = false, Color iconColor = const Color(0xFF558B2F)}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextField(
        controller: c,
        readOnly: readOnly,
        keyboardType: number ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: iconColor, size: 20),
          hintText: hint,
          hintStyle: const TextStyle(fontSize: 14, color: Colors.grey),
          filled: true,
          fillColor: const Color(0xFFF9FBE7),
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Color(0xFF2E7D32), width: 1.5),
          ),
        ),
      ),
    );
  }

  Widget _rideTypeDropdown() {
    return DropdownButtonFormField<String>(
      value: selectedRideType,
      items: rideTypes
          .map((e) => DropdownMenuItem(
                value: e,
                child: Row(
                  children: [
                    Icon(e == "Ride" ? Icons.directions_car : Icons.inventory_2, 
                         size: 18, color: const Color(0xFF2E7D32)),
                    const SizedBox(width: 10),
                    Text(e),
                  ],
                ),
              ))
          .toList(),
      onChanged: (v) => setState(() {
        selectedRideType = v;
        spaceController.clear();
      }),
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFFF9FBE7),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
      ),
    );
  }

  Widget _submitButton() => GestureDetector(
        onTap: _isLoading ? null : _addRoute,
        child: Container(
          height: 56,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: _isLoading
                  ? [Colors.grey, Colors.grey.shade400]
                  : [const Color(0xFF1B5E20), const Color(0xFF4CAF50)],
            ),
            boxShadow: [
              if (!_isLoading)
                BoxShadow(
                  color: Colors.green.withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                )
            ],
          ),
          child: Center(
            child: _isLoading
                ? const SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                  )
                : const Text(
                    "Publish Green Route",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.8,
                    ),
                  ),
          ),
        ),
      );
}