import 'package:flutter/material.dart';

void main() {
  runApp(const ParcelApp());
}

class ParcelApp extends StatelessWidget {
  const ParcelApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Parcel Booking",
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        fontFamily: "Roboto",
      ),
      home: const ParcelBookingPage(),
    );
  }
}

class ParcelBookingPage extends StatefulWidget {
  const ParcelBookingPage({super.key});

  @override
  State<ParcelBookingPage> createState() => _ParcelBookingPageState();
}

class _ParcelBookingPageState extends State<ParcelBookingPage> {
  // NEW FIELDS
  final TextEditingController parcelBookingIdController = TextEditingController();
  final TextEditingController senderIdController = TextEditingController();

  // Existing fields
  final TextEditingController pickupController = TextEditingController();
  final TextEditingController dropController = TextEditingController();
  final TextEditingController parcelDetailsController = TextEditingController();
  final TextEditingController initialFareController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  final TextEditingController finalAmountController = TextEditingController();

  String? category;
  String? bookingStatus;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
        title: const Text(
          "Parcel Booking",
          style: TextStyle(color: Colors.white),
        ),
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
              ),
            ],
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ---------------------------------------
              // NEW FIELDS ADDED HERE
              // ---------------------------------------

              _header("Parcel Booking ID"),
              _inputField(
                controller: parcelBookingIdController,
                icon: Icons.confirmation_number_outlined,
                hint: "Enter parcel booking ID",
              ),

              _header("Sender ID"),
              _inputField(
                controller: senderIdController,
                icon: Icons.person_outline,
                hint: "Enter sender ID",
              ),

              // ---------------------------------------
              // EXISTING FIELDS
              // ---------------------------------------

              _header("Pickup Location"),
              _inputField(
                controller: pickupController,
                icon: Icons.location_on_outlined,
                hint: "Enter pickup address",
              ),

              _header("Drop Location"),
              _inputField(
                controller: dropController,
                icon: Icons.flag_outlined,
                hint: "Enter drop address",
              ),

              _header("Parcel Details"),
              _inputField(
                controller: parcelDetailsController,
                icon: Icons.description_outlined,
                hint: "Describe parcel details",
                maxLines: 3,
              ),

              _header("Initial Fare"),
              _inputField(
                controller: initialFareController,
                icon: Icons.currency_rupee,
                hint: "0.00",
                isNumber: true,
              ),

              _header("Category"),
              _dropDown(
                value: category,
                items: ["Electronics", "Food", "Documents", "Fragile", "Others"],
                onChanged: (v) => setState(() => category = v),
                icon: Icons.category_outlined,
              ),

              _header("Booking Status"),
              _dropDown(
                value: bookingStatus,
                items: ["Pending", "Picked Up", "Delivered"],
                onChanged: (v) => setState(() => bookingStatus = v),
                icon: Icons.local_shipping_outlined,
              ),

              _header("OTP Code"),
              _inputField(
                controller: otpController,
                icon: Icons.lock_outline,
                hint: "Enter delivery OTP",
              ),

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
    int maxLines = 1,
    bool isNumber = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
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
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(14),
      ),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: const InputDecoration(border: InputBorder.none),
        hint: const Text("Select"),
        icon: Icon(icon, color: Colors.deepPurple),
        items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _submitButton() {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.deepPurple,
            content: Text("Parcel Booking Submitted!"),
          ),
        );
      },
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          gradient: const LinearGradient(
            colors: [Color(0xff6A11CB), Color(0xff2575FC)],
          ),
        ),
        child: const Center(
          child: Text(
            "Book Parcel",
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
