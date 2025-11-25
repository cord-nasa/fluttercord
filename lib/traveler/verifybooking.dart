import 'package:flutter/material.dart';

class VerifyPickupDropPage extends StatefulWidget {
  const VerifyPickupDropPage({super.key});

  @override
  State<VerifyPickupDropPage> createState() => _VerifyPickupDropPageState();
}

class _VerifyPickupDropPageState extends State<VerifyPickupDropPage> {
  final TextEditingController verificationIdController = TextEditingController();
  final TextEditingController bookingIdController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  String verifyType = "Pickup";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        elevation: 0,
        centerTitle: true,
        title: const Text("Verify Pickup / Drop", style: TextStyle(color: Colors.white)),
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

              _header("Verification ID"),
              _inputField(
                controller: verificationIdController,
                icon: Icons.verified_user_outlined,
                hint: "Enter verification ID",
              ),

              _header("Booking ID"),
              _inputField(
                controller: bookingIdController,
                icon: Icons.book_online_outlined,
                hint: "Enter booking ID",
              ),

              _header("User / Receiver Name"),
              _inputField(
                controller: nameController,
                icon: Icons.person_outline,
                hint: "Enter name",
              ),

              _header("Verify Type"),
              _dropdownField(),

              _header("OTP Code"),
              _inputField(
                controller: otpController,
                icon: Icons.sms_outlined,
                hint: "Enter OTP",
                isNumber: true,
              ),

              _header("Date & Time"),
              _inputField(
                controller: dateController,
                icon: Icons.access_time_rounded,
                hint: "YYYY-MM-DD HH:MM",
              ),

              const SizedBox(height: 25),
              _submitButton("Verify Now"),
            ],
          ),
        ),
      ),
    );
  }

  Widget _header(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 6, top: 20),
        child: Text(text,
            style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.black87)),
      );

  Widget _inputField({
    required TextEditingController controller,
    required IconData icon,
    required String hint,
    bool isNumber = false,
    int maxLines = 1,
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

  Widget _dropdownField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(14),
      ),
      child: DropdownButtonFormField<String>(
        value: verifyType,
        decoration: const InputDecoration(border: InputBorder.none),
        items: const [
          DropdownMenuItem(value: "Pickup", child: Text("Pickup")),
          DropdownMenuItem(value: "Drop", child: Text("Drop")),
        ],
        onChanged: (value) {
          setState(() => verifyType = value!);
        },
      ),
    );
  }

  Widget _submitButton(String text) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.deepPurple,
            content: Text("$text Completed Successfully!"),
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
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
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
