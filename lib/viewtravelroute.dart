import 'package:flutter/material.dart';

void main() {
  runApp(const TravelRouteApp());
}

class TravelRouteApp extends StatelessWidget {
  const TravelRouteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Travel Route",
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        fontFamily: "Roboto",
      ),
      home: const TravelRoutePage(),
    );
  }
}

class TravelRoutePage extends StatefulWidget {
  const TravelRoutePage({super.key});

  @override
  State<TravelRoutePage> createState() => _TravelRoutePageState();
}

class _TravelRoutePageState extends State<TravelRoutePage> {
  // FIELDS
  final TextEditingController routeIdController = TextEditingController();
  final TextEditingController travelerIdController = TextEditingController();
  final TextEditingController fromLocationController = TextEditingController();
  final TextEditingController toLocationController = TextEditingController();
  final TextEditingController distanceController = TextEditingController();
  final TextEditingController vehicleTypeController = TextEditingController();
  final TextEditingController fareController = TextEditingController();

  String? travelStatus;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
        title: const Text(
          "Travel Route",
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
              _header("Route ID"),
              _inputField(
                controller: routeIdController,
                icon: Icons.numbers,
                hint: "Enter route ID",
              ),

              _header("Traveler ID"),
              _inputField(
                controller: travelerIdController,
                icon: Icons.person_outline,
                hint: "Enter traveler ID",
              ),

              _header("From Location"),
              _inputField(
                controller: fromLocationController,
                icon: Icons.location_on_outlined,
                hint: "Enter starting point",
              ),

              _header("To Location"),
              _inputField(
                controller: toLocationController,
                icon: Icons.flag_outlined,
                hint: "Enter destination",
              ),

              _header("Distance (km)"),
              _inputField(
                controller: distanceController,
                icon: Icons.straighten,
                hint: "Enter distance",
                isNumber: true,
              ),

              _header("Vehicle Type"),
              _inputField(
                controller: vehicleTypeController,
                icon: Icons.directions_car_outlined,
                hint: "Bike, Auto, Car, etc.",
              ),

              _header("Fare Amount"),
              _inputField(
                controller: fareController,
                icon: Icons.currency_rupee,
                hint: "0.00",
                isNumber: true,
              ),

              _header("Travel Status"),
              _dropDown(
                value: travelStatus,
                items: ["Scheduled", "Ongoing", "Completed"],
                onChanged: (v) => setState(() => travelStatus = v),
                icon: Icons.check_circle_outline,
              ),

              const SizedBox(height: 25),
              _submitButton(),
            ],
          ),
        ),
      ),
    );
  }

  // --------------------------------------
  // COMPONENTS (same as your parcel UI)
  // --------------------------------------

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
            content: Text("Travel Route Saved!"),
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
            "Save Route",
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
