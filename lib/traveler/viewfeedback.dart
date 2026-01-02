import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:cord/user/loginpage.dart'; // Ensure baseurl and loginid are accessible here
import 'package:cord/user/reg.dart';

class ViewFeedbackPage extends StatefulWidget {
  const ViewFeedbackPage({super.key});

  @override
  State<ViewFeedbackPage> createState() => _ViewFeedbackPageState();
}

class _ViewFeedbackPageState extends State<ViewFeedbackPage> {
  final Dio _dio = Dio();
  bool _isLoading = false;
  List<dynamic> _feedbackList = [];

  @override
  void initState() {
    super.initState();
    _fetchFeedback();
  }

  /// FETCH FEEDBACK FROM API
  Future<void> _fetchFeedback() async {
    setState(() => _isLoading = true);
    try {
      // Logic: Fetching feedback specific to the logged-in user or general feedback
      Response response = await _dio.get("$baseurl/ViewFeedbackAPI/$loginid");

      if (response.statusCode == 200 || response.statusCode == 201) {
        setState(() {
          _feedbackList = response.data is List ? response.data : [];
        });
      }
    } catch (e) {
      debugPrint("Error fetching feedback: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'My Reviews',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.deepPurple))
          : RefreshIndicator(
              onRefresh: _fetchFeedback,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                    child: Text(
                      'All Feedback (${_feedbackList.length})',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    child: _feedbackList.isEmpty
                        ? _buildEmptyState()
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: _feedbackList.length,
                            itemBuilder: (context, index) {
                              return _buildFeedbackCard(_feedbackList[index]);
                            },
                          ),
                  )
                ],
              ),
            ),
    );
  }

  Widget _buildFeedbackCard(Map<String, dynamic> item) {
    // Parsing variables safely
    int rating = int.tryParse(item['rating'].toString()) ?? 0;
    String comment = item['feedback'] ?? "No comment provided";
    String date = item['date'] ?? "Recent";

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.deepPurple.shade50,
                  child: const Icon(Icons.person, color: Colors.deepPurple),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Trip Review",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      Text(date, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                ),
                // Star Rating Display
                Row(
                  children: List.generate(5, (index) {
                    return Icon(
                      index < rating ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                      size: 16,
                    );
                  }),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              comment,
              style: TextStyle(color: Colors.grey.shade800, height: 1.4),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.speaker_notes_off_outlined, size: 64, color: Colors.grey.shade300),
          const SizedBox(height: 12),
          const Text("No feedback found", style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}