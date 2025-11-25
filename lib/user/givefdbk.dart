import 'package:flutter/material.dart';


class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final TextEditingController feedbackIdController = TextEditingController();
  final TextEditingController bookingIdController = TextEditingController();
  final TextEditingController ratingController = TextEditingController();
  final TextEditingController commentController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        elevation: 0,
        centerTitle: true,
        title: const Text("Submit Feedback", style: TextStyle(color: Colors.white)),
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
              _header("Feedback ID"),
              _inputField(
                controller: feedbackIdController,
                icon: Icons.confirmation_number_outlined,
                hint: "Enter feedback ID",
              ),

              _header("Booking ID"),
              _inputField(
                controller: bookingIdController,
                icon: Icons.book_online_outlined,
                hint: "Enter booking ID",
              ),

              _header("Rating (1–5)"),
              _inputField(
                controller: ratingController,
                icon: Icons.star_outline,
                hint: "Enter rating",
                isNumber: true,
              ),

              _header("Comments"),
              _inputField(
                controller: commentController,
                icon: Icons.comment_outlined,
                hint: "Write your feedback",
                maxLines: 3,
              ),

              _header("Feedback Date"),
              _inputField(
                controller: dateController,
                icon: Icons.date_range_outlined,
                hint: "YYYY-MM-DD",
              ),

              const SizedBox(height: 25),
              _submitButton("Submit Feedback"),
            ],
          ),
        ),
      ),
    );
  }

  // ---------- UI Components ----------

  Widget _header(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 6, top: 20),
        child: Text(
          text,
          style: const TextStyle(
              fontSize: 15, fontWeight: FontWeight.w600, color: Colors.black87),
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
