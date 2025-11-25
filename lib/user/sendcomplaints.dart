import 'package:flutter/material.dart';

class ComplaintPage extends StatefulWidget {
  const ComplaintPage({super.key});

  @override
  State<ComplaintPage> createState() => _ComplaintPageState();
}

class _ComplaintPageState extends State<ComplaintPage> {
  final TextEditingController complaintIdController = TextEditingController();
  final TextEditingController bookingIdController = TextEditingController();
  final TextEditingController userIdController = TextEditingController();
  final TextEditingController complaintTextController = TextEditingController();
  final TextEditingController complaintDateController = TextEditingController();

  String? status; // Pending / Resolved

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
        title: const Text("Register Complaint", style: TextStyle(color: Colors.white)),
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
              _header("Complaint ID"),
              _inputField(
                controller: complaintIdController,
                icon: Icons.confirmation_number_outlined,
                hint: "Enter complaint ID",
              ),

              _header("Booking ID"),
              _inputField(
                controller: bookingIdController,
                icon: Icons.book_online_outlined,
                hint: "Enter booking ID",
              ),

              _header("User ID"),
              _inputField(
                controller: userIdController,
                icon: Icons.person_outline,
                hint: "Enter user ID",
              ),

              _header("Complaint Text"),
              _inputField(
                controller: complaintTextController,
                icon: Icons.report_problem_outlined,
                hint: "Enter complaint details",
                maxLines: 4,
              ),

              _header("Complaint Date"),
              _inputField(
                controller: complaintDateController,
                icon: Icons.date_range_outlined,
                hint: "YYYY-MM-DD",
              ),

              _header("Status"),
              _dropDown(
                value: status,
                items: ["Pending", "Resolved"],
                onChanged: (v) => setState(() => status = v),
                icon: Icons.flag_outlined,
              ),

              const SizedBox(height: 25),
              _submitButton("Submit Complaint"),
            ],
          ),
        ),
      ),
    );
  }

  // ---------- SHARED COMPONENTS (same as your code) ----------

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

  Widget _submitButton(String text) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.deepPurple,
            content: Text("$text Submitted!"),
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
