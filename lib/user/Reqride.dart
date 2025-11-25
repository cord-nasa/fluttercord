import 'package:flutter/material.dart';



class RideBookingPage extends StatefulWidget {
  const RideBookingPage({super.key});

  @override
  State<RideBookingPage> createState() => _RideBookingPageState();
}

class _RideBookingPageState extends State<RideBookingPage> {
  // Controllers
  final TextEditingController rideRequestIdController = TextEditingController();
  final TextEditingController passengerIdController = TextEditingController();
  final TextEditingController pickupController = TextEditingController();
  final TextEditingController dropController = TextEditingController();
  final TextEditingController passengersController = TextEditingController();
  final TextEditingController finalAmountController = TextEditingController();

  String? bookingStatus;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.deepPurple,
        title: const Text(
          "Ride Booking",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 10,
                offset: const Offset(0, 4),
              )
            ],
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ---------------- TOP FIELDS ----------------

              _header("Ride Request ID"),
              _inputField(
                controller: rideRequestIdController,
                icon: Icons.confirmation_number_outlined,
                hint: "Enter Ride Request ID",
              ),

              _header("Passenger ID"),
              _inputField(
                controller: passengerIdController,
                icon: Icons.person_outline,
                hint: "Enter Passenger ID",
              ),

              // ---------------- LOCATIONS ----------------

              _header("Pickup Location"),
              _inputField(
                controller: pickupController,
                icon: Icons.location_on_outlined,
                hint: "Enter pickup location",
              ),

              _header("Drop Location"),
              _inputField(
                controller: dropController,
                icon: Icons.flag_outlined,
                hint: "Enter drop location",
              ),

              // ---------------- PASSENGERS ----------------

              _header("No. of Passengers"),
              _inputField(
                controller: passengersController,
                icon: Icons.people_alt_outlined,
                hint: "Enter number of passengers",
                isNumber: true,
              ),

              // ---------------- STATUS DROPDOWN ----------------

              _header("Booking Status"),
              _dropDown(
                value: bookingStatus,
                items: ["Pending", "Accepted", "Completed"],
                onChanged: (v) => setState(() => bookingStatus = v),
                icon: Icons.local_taxi_outlined,
              ),

              // ---------------- FINAL AMOUNT ----------------

              _header("Final Amount"),
              _inputField(
                controller: finalAmountController,
                icon: Icons.payments_outlined,
                hint: "0.00",
                isNumber: true,
              ),

              const SizedBox(height: 25),

              _submitButton(),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------------- COMPONENTS ----------------------

  Widget _header(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 6, top: 20),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      );

  Widget _inputField({
    required TextEditingController controller,
    required IconData icon,
    required String hint,
    bool isNumber = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.deepPurple),
          hintText: hint,
          filled: true,
          fillColor: Colors.grey.shade200,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _dropDown({
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(14),
      ),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: const InputDecoration(border: InputBorder.none),
        hint: const Text("Select Status"),
        icon: Icon(icon, color: Colors.deepPurple),
        items: items
            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
            .toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _submitButton() {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Ride Booking Submitted!"),
            backgroundColor: Colors.deepPurple,
          ),
        );
      },
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: const LinearGradient(
            colors: [Color(0xff6A11CB), Color(0xff2575FC)],
          ),
        ),
        child: const Center(
          child: Text(
            "Submit Ride Booking",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
