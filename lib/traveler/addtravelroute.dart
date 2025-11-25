import 'package:flutter/material.dart';

class AddTravelRoutePage extends StatefulWidget {
  const AddTravelRoutePage({super.key});

  @override
  State<AddTravelRoutePage> createState() => _AddTravelRoutePageState();
}

class _AddTravelRoutePageState extends State<AddTravelRoutePage> {
  final TextEditingController routeIdController = TextEditingController();
  final TextEditingController fromController = TextEditingController();
  final TextEditingController toController = TextEditingController();
  final TextEditingController fareController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();

  Future<void> _pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      dateController.text = picked.toString().substring(0, 10);
    }
  }

  Future<void> _pickTime() async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      timeController.text = picked.format(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
        title: const Text("Add Travel Route",
            style: TextStyle(color: Colors.white)),
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
              _header("Route ID"),
              _inputField(
                controller: routeIdController,
                icon: Icons.confirmation_number_outlined,
                hint: "Enter route ID",
              ),

              _header("From"),
              _inputField(
                controller: fromController,
                icon: Icons.location_on_outlined,
                hint: "Enter start location",
              ),

              _header("To"),
              _inputField(
                controller: toController,
                icon: Icons.place_outlined,
                hint: "Enter destination location",
              ),

              _header("Fare Price"),
              _inputField(
                controller: fareController,
                icon: Icons.currency_rupee,
                hint: "Enter fare amount",
                isNumber: true,
              ),

              _header("Travel Date"),
              GestureDetector(
                onTap: _pickDate,
                child: AbsorbPointer(
                  child: _inputField(
                    controller: dateController,
                    icon: Icons.date_range_outlined,
                    hint: "Select Date",
                  ),
                ),
              ),

              _header("Travel Time"),
              GestureDetector(
                onTap: _pickTime,
                child: AbsorbPointer(
                  child: _inputField(
                    controller: timeController,
                    icon: Icons.access_time,
                    hint: "Select Time",
                  ),
                ),
              ),

              const SizedBox(height: 25),
              _submitButton("Save Route"),
            ],
          ),
        ),
      ),
    );
  }

  // ---------- Components Reused ----------

  Widget _header(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 8, top: 18),
        child: Text(
          text,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
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
        keyboardType:
            isNumber ? TextInputType.number : TextInputType.text,
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

  Widget _submitButton(String text) => GestureDetector(
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.deepPurple,
              content: Text("$text Successfully Saved ✓"),
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
