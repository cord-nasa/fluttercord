import 'package:cord/user/loginpage.dart';
import 'package:cord/user/reg.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class ComplaintPage extends StatefulWidget {
  final dynamic bookingId; // Pass this from BookingHistoryPage
  const ComplaintPage({super.key, this.bookingId});

  @override
  State<ComplaintPage> createState() => _ComplaintPageState();
}

class _ComplaintPageState extends State<ComplaintPage> {
  final Dio _dio = Dio();
  final TextEditingController complaintTextController = TextEditingController();

  bool _loading = false;
  bool _fetching = false;
  List complaints = [];

  @override
  void initState() {
    super.initState();
    fetchComplaints();
  }

  /// ================= FETCH COMPLAINTS =================
  Future<void> fetchComplaints() async {
    setState(() => _fetching = true);
    try {
      // Assuming your API returns complaints for this specific user
      final response = await _dio.get("$baseurl/ComplaintReplyAPI/$loginid");

      setState(() {
        complaints = response.data is List ? response.data : [];
        _fetching = false;
      });
    } catch (e) {
      setState(() => _fetching = false);
      _showSnackBar("Failed to fetch complaints", Colors.red);
    }
  }

  /// ================= POST COMPLAINT =================
  Future<void> submitComplaint() async {
    if (complaintTextController.text.trim().isEmpty) {
      _showSnackBar("Please enter complaint details", Colors.orange);
      return;
    }

    setState(() => _loading = true);

    try {
      await _dio.post(
        "$baseurl/ComplaintReplyAPI/$loginid",
        data: {
          "user_id": loginid,
          "booking_id": widget.bookingId ?? "General", // Linked ID
          "complaint_text": complaintTextController.text,
          "complaint_date": DateTime.now().toString().split('.')[0], // Cleaner format
        },
      );

      complaintTextController.clear();
      fetchComplaints(); 
      _showSnackBar("Complaint submitted successfully", Colors.green);
    } catch (e) {
      _showSnackBar("Failed to submit complaint", Colors.red);
    } finally {
      setState(() => _loading = false);
    }
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: color),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.deepPurple,
        title: const Text("Complaints & Support", style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          _complaintForm(),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            child: Divider(),
          ),
          Expanded(child: _complaintList()),
        ],
      ),
    );
  }

  Widget _complaintForm() {
    return Container(
      margin: const EdgeInsets.all(18),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.bookingId != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text("Reporting Booking ID: #${widget.bookingId}", 
                style: const TextStyle(color: Colors.deepPurple, fontWeight: FontWeight.bold)),
            ),
          _inputField(
            controller: complaintTextController,
            icon: Icons.edit_note,
            hint: "What happened? Describe your issue...",
            maxLines: 3,
          ),
          const SizedBox(height: 15),
          _submitButton(),
        ],
      ),
    );
  }

  Widget _complaintList() {
    if (_fetching) return const Center(child: CircularProgressIndicator());
    if (complaints.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.chat_bubble_outline, size: 50, color: Colors.grey.shade300),
            const Text("No history found", style: TextStyle(color: Colors.grey)),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      itemCount: complaints.length,
      itemBuilder: (context, index) {
        final item = complaints[index];
        final String reply = item["reply"] ?? "Waiting for admin response...";
        final bool isResolved = item["status"] == "Resolved";

        return Container(
          margin: const EdgeInsets.only(bottom: 15),
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(item["complaint_date"] ?? "", style: const TextStyle(fontSize: 11, color: Colors.grey)),
                  _statusTag(item["status"] ?? "Pending", isResolved),
                ],
              ),
              const SizedBox(height: 8),
              Text(item["complaint_text"] ?? "", style: const TextStyle(fontWeight: FontWeight.w500)),
              const SizedBox(height: 12),
              // --- Admin Reply Section ---
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.deepPurple.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Admin Reply:", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.deepPurple)),
                    const SizedBox(height: 4),
                    Text(reply, style: TextStyle(fontSize: 13, color: Colors.grey.shade800, fontStyle: FontStyle.italic)),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _statusTag(String status, bool resolved) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: resolved ? Colors.green.withOpacity(0.1) : Colors.orange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(status, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: resolved ? Colors.green : Colors.orange)),
    );
  }

  Widget _inputField({required TextEditingController controller, required IconData icon, required String hint, int maxLines = 1}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.deepPurple),
        hintText: hint,
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
      ),
    );
  }

  Widget _submitButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: _loading ? null : submitComplaint,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.deepPurple,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          elevation: 0,
        ),
        child: _loading 
          ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) 
          : const Text("Submit Complaint", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
      ),
    );
  }
}