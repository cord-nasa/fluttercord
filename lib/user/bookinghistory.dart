// import 'package:flutter/material.dart';
// import 'package:dio/dio.dart';
// // Ensure these paths match your project structure
// import 'package:cord/user/loginpage.dart'; 
// import 'package:cord/user/reg.dart';

// class BookingHistoryPage extends StatefulWidget {
//   const BookingHistoryPage({super.key});

//   @override
//   State<BookingHistoryPage> createState() => _BookingHistoryPageState();
// }

// class _BookingHistoryPageState extends State<BookingHistoryPage>
//     with SingleTickerProviderStateMixin {
//   late TabController _tabController;
//   final Dio _dio = Dio();
//   bool _isLoading = false;

//   // Data storage
//   List<dynamic> _rideHistory = [];
//   List<dynamic> _parcelHistory = [];

//   // Feedback State
//   int? _expandedFeedbackIndex;
//   String? _activeType; // To track if feedback is open in Ride or Parcel tab
//   final TextEditingController _feedbackController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 2, vsync: this);
//     fetchHistory();
//   }

//   /// FETCH DATA FROM API
//   Future<void> fetchHistory() async {
//     setState(() => _isLoading = true);
//     try {
//       // Replace with your actual history endpoint
//       Response response = await _dio.get("$baseurl/ViewBookingHistoryAPI/$loginid");
// print(response.data)''
//       if (response.statusCode == 200 || response.statusCode == 201) {
//         List<dynamic> data = response.data is List ? response.data : [];
        
//         setState(() {
//           // Filter data into respective tabs based on 'type' from API
//           _rideHistory = data.where((item) => item['type'] == 'Ride').toList();
//           _parcelHistory = data.where((item) => item['type'] == 'Parcel').toList();
//         });
//       }
//     } catch (e) {
//       _showSnackBar("Failed to load history: $e", Colors.red);
//     } finally {
//       setState(() => _isLoading = false);
//     }
//   }

//   /// SUBMIT FEEDBACK TO API
//   Future<void> _submitFeedback(var bookingId) async {
//     if (_feedbackController.text.trim().isEmpty) {
//       _showSnackBar("Please enter some feedback", Colors.orange);
//       return;
//     }

//     setState(() => _isLoading = true);
//     try {
//       // Example POST to your feedback endpoint
//       // await _dio.post("$baseurl/submit_feedback", data: {
//       //   "booking_id": bookingId,
//       //   "feedback": _feedbackController.text,
//       //   "user_id": loginid,
//       // });

//       await Future.delayed(const Duration(seconds: 1)); // Simulating network
//       _showSnackBar("Thank you for your feedback!", Colors.green);
      
//       setState(() {
//         _expandedFeedbackIndex = null;
//         _activeType = null;
//         _feedbackController.clear();
//       });
//     } catch (e) {
//       _showSnackBar("Could not submit feedback", Colors.red);
//     } finally {
//       setState(() => _isLoading = false);
//     }
//   }

//   void _showSnackBar(String message, Color color) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text(message), backgroundColor: color),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey.shade50,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.black),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: const Text(
//           "Booking History",
//           style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
//         ),
//         actions: [
//           IconButton(
//             onPressed: fetchHistory,
//             icon: const Icon(Icons.refresh, color: Colors.deepPurple),
//           )
//         ],
//         bottom: TabBar(
//           controller: _tabController,
//           labelColor: Colors.deepPurple,
//           unselectedLabelColor: Colors.grey,
//           indicatorColor: Colors.deepPurple,
//           indicatorWeight: 3,
//           tabs: const [
//             Tab(text: "Rides"),
//             Tab(text: "Parcels"),
//           ],
//         ),
//       ),
//       body: Stack(
//         children: [
//           TabBarView(
//             controller: _tabController,
//             children: [
//               _buildHistoryList(_rideHistory, "Ride"),
//               _buildHistoryList(_parcelHistory, "Parcel"),
//             ],
//           ),
//           if (_isLoading)
//             const Center(child: CircularProgressIndicator(color: Colors.deepPurple)),
//         ],
//       ),
//     );
//   }

//   Widget _buildHistoryList(List<dynamic> list, String type) {
//     if (list.isEmpty && !_isLoading) {
//       return Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(Icons.history, size: 64, color: Colors.grey.shade300),
//             const SizedBox(height: 10),
//             Text("No $type history found", style: const TextStyle(color: Colors.grey)),
//           ],
//         ),
//       );
//     }

//     return RefreshIndicator(
//       onRefresh: fetchHistory,
//       child: ListView.builder(
//         padding: const EdgeInsets.all(16),
//         itemCount: list.length,
//         itemBuilder: (context, index) {
//           return _historyCard(list[index], type, index);
//         },
//       ),
//     );
//   }

//   Widget _historyCard(Map<String, dynamic> item, String type, int index) {
//     bool isCommitted = item['status'] == "Committed";
//     bool isExpanded = _expandedFeedbackIndex == index && _activeType == type;

//     return Container(
//       margin: const EdgeInsets.only(bottom: 16),
//       padding: const EdgeInsets.all(18),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: Colors.grey.shade200),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.03),
//             blurRadius: 10,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 "${item['start_location']} ➔ ${item['end_location']}",
//                 style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
//               ),
//               _statusBadge(item['status']),
//             ],
//           ),
//           const SizedBox(height: 8),
//           Row(
//             children: [
//               const Icon(Icons.calendar_today, size: 14, color: Colors.grey),
//               const SizedBox(width: 5),
//               Text(item['date'] ?? "N/A", style: const TextStyle(fontSize: 12, color: Colors.grey)),
//               const SizedBox(width: 15),
//               const Icon(Icons.access_time, size: 14, color: Colors.grey),
//               const SizedBox(width: 5),
//               Text(item['start_time'] ?? "N/A", style: const TextStyle(fontSize: 12, color: Colors.grey)),
//             ],
//           ),
//           const Divider(height: 25),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text("Fare", style: TextStyle(fontSize: 11, color: Colors.grey)),
//                   Text("₹${item['fare']}", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.deepPurple)),
//                 ],
//               ),
//               if (isCommitted)
//                 ElevatedButton.icon(
//                   onPressed: () {
//                     setState(() {
//                       if (isExpanded) {
//                         _expandedFeedbackIndex = null;
//                         _activeType = null;
//                       } else {
//                         _expandedFeedbackIndex = index;
//                         _activeType = type;
//                       }
//                     });
//                   },
//                   icon: Icon(isExpanded ? Icons.close : Icons.rate_review, size: 16),
//                   label: Text(isExpanded ? "Close" : "Feedback"),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: isExpanded ? Colors.grey : Colors.deepPurple.shade50,
//                     foregroundColor: isExpanded ? Colors.white : Colors.deepPurple,
//                     elevation: 0,
//                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//                   ),
//                 )
//               else
//                 _subTypeBadge(item['parcel_type'] ?? item['car_type'] ?? "Standard"),
//             ],
//           ),

//           // Feedback Input Field (Visible only when 'Feedback' is clicked and status is 'Committed')
//           if (isExpanded) ...[
//             const SizedBox(height: 15),
//             TextField(
//               controller: _feedbackController,
//               maxLines: 2,
//               decoration: InputDecoration(
//                 hintText: "Tell us about the service...",
//                 filled: true,
//                 fillColor: Colors.grey.shade50,
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                   borderSide: BorderSide(color: Colors.grey.shade300),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 10),
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: () => _submitFeedback(item['id']),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.deepPurple,
//                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                 ),
//                 child: const Text("Submit", style: TextStyle(color: Colors.white)),
//               ),
//             ),
//           ],
//         ],
//       ),
//     );
//   }

//   Widget _subTypeBadge(String text) => Container(
//     padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//     decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(8)),
//     child: Text(text, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black54)),
//   );

//   Widget _statusBadge(String status) {
//     bool isCommitted = status == "Committed";
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//       decoration: BoxDecoration(
//         color: isCommitted ? Colors.green.shade50 : Colors.orange.shade50,
//         borderRadius: BorderRadius.circular(20),
//       ),
//       child: Text(
//         status,
//         style: TextStyle(
//           color: isCommitted ? Colors.green.shade700 : Colors.orange.shade700,
//           fontSize: 11,
//           fontWeight: FontWeight.bold,
//         ),
//       ),
//     );
//   }
// }

import 'package:cord/user/sendcomplaints.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:cord/user/loginpage.dart'; 
import 'package:cord/user/reg.dart';

class BookingHistoryPage extends StatefulWidget {
  const BookingHistoryPage({super.key});

  @override
  State<BookingHistoryPage> createState() => _BookingHistoryPageState();
}

class _BookingHistoryPageState extends State<BookingHistoryPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final Dio _dio = Dio();
  bool _isLoading = false;

  // Data storage
  List<dynamic> _rideHistory = [];
  List<dynamic> _parcelHistory = [];

  // Feedback & Rating State
  int? _expandedFeedbackIndex;
  String? _activeType; 
  int _selectedRating = 0; 
  final TextEditingController _feedbackController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    fetchHistory();
  }

  /// FETCH DATA FROM API
  Future<void> fetchHistory() async {
    setState(() => _isLoading = true);
    try {
      Response response = await _dio.get("$baseurl/ViewBookingHistoryAPI/$loginid");
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        List<dynamic> data = response.data is List ? response.data : [];
        
        setState(() {
          _rideHistory = data.where((item) => item['RideType'] == 'Ride').toList();
          _parcelHistory = data.where((item) => item['RideType'] == 'Parcel').toList();
        });
      }
    } catch (e) {
      _showSnackBar("Failed to load history: $e", Colors.red);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  /// SUBMIT FEEDBACK TO API
  Future<void> _submitFeedback(var bookingId) async {
    if (_selectedRating == 0) {
      _showSnackBar("Please select a star rating", Colors.orange);
      return;
    }
    if (_feedbackController.text.trim().isEmpty) {
      _showSnackBar("Please enter some comments", Colors.orange);
      return;
    }

    setState(() => _isLoading = true);
    try {
      // Example POST to your feedback endpoint
      await _dio.post("$baseurl/SendFeedbackAPI/$loginid", data: {
        "booking_id": bookingId,
        "rating": _selectedRating,
        "feedback": _feedbackController.text,
        // "user_id": loginid,
      });

   
      
      setState(() {
        _expandedFeedbackIndex = null;
        _activeType = null;
        _selectedRating = 0;
        _feedbackController.clear();
      });
    } catch (e) {
      _showSnackBar("Could not submit feedback", Colors.red);
    } finally {
      setState(() => _isLoading = false);
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
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "My Bookings",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: fetchHistory,
            icon: const Icon(Icons.refresh, color: Colors.deepPurple),
          )
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.deepPurple,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.deepPurple,
          indicatorWeight: 3,
          tabs: const [
            Tab(text: "Rides"),
            Tab(text: "Parcels"),
          ],
        ),
      ),
      body: Stack(
        children: [
          TabBarView(
            controller: _tabController,
            children: [
              _buildHistoryList(_rideHistory, "Ride"),
              _buildHistoryList(_parcelHistory, "Parcel"),
            ],
          ),
          if (_isLoading)
            const Center(child: CircularProgressIndicator(color: Colors.deepPurple)),
        ],
      ),
    );
  }

  Widget _buildHistoryList(List<dynamic> list, String type) {
    if (list.isEmpty && !_isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.history, size: 64, color: Colors.grey.shade300),
            const SizedBox(height: 10),
            Text("No $type history found", style: const TextStyle(color: Colors.grey)),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: fetchHistory,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: list.length,
        itemBuilder: (context, index) {
          return _historyCard(list[index], type, index);
        },
      ),
    );
  }
Widget _historyCard(Map<String, dynamic> item, String type, int index) {
  String start = item['StartLocation'] ?? "Unknown";
  String end = item['EndLocation'] ?? "Unknown";
  String status = item['BookingStatus'] ?? "Pending";
  String date = item['BookingDate'] ?? "N/A";
  String time = item['StartingTime'] ?? "N/A";
  String amount = item['Amount'].toString();
  String space = item['SpaceAvailability'] ?? "";

  bool isCommitted = status == "Committed";
  bool isExpanded = _expandedFeedbackIndex == index && _activeType == type;

  return Container(
    margin: const EdgeInsets.only(bottom: 16),
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                "$start ➔ $end",
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ),
            _statusBadge(status),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            const Icon(Icons.calendar_today, size: 14, color: Colors.grey),
            const SizedBox(width: 5),
            Text(date, style: const TextStyle(fontSize: 12, color: Colors.grey)),
            const SizedBox(width: 15),
            const Icon(Icons.access_time, size: 14, color: Colors.grey),
            const SizedBox(width: 5),
            Text(time, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
        const Divider(height: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Left side: Fare Amount
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Fare Amount", style: TextStyle(fontSize: 11, color: Colors.grey)),
                  Text("₹$amount", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.deepPurple)),
                ],
              ),
            ),
            
            // Right side: Action Buttons
            if (isCommitted)
              Row(
                mainAxisSize: MainAxisSize.min, // Takes only necessary space
                children: [
                  // --- SEND COMPLAINT BUTTON ---
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ComplaintPage(bookingId: item['id']),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        "Send Complaint",
                        style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 11),
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  
                  // --- GIVE FEEDBACK BUTTON ---
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        if (isExpanded) {
                          _expandedFeedbackIndex = null;
                          _activeType = null;
                          _selectedRating = 0;
                        } else {
                          _expandedFeedbackIndex = index;
                          _activeType = type;
                        }
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      backgroundColor: isExpanded ? Colors.grey.shade200 : const Color(0xFFF0E6FF),
                      foregroundColor: isExpanded ? Colors.grey : Colors.deepPurple,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: Text(
                      isExpanded ? "Close" : "Give Feedback",
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              )
            else
              _infoChip(type == "Ride" ? Icons.airline_seat_recline_normal : Icons.inventory_2, space),
          ],
        ),

        // Expanded Feedback Section
        if (isExpanded) ...[
          const SizedBox(height: 15),
          const Text("How was your trip?", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
          const SizedBox(height: 5),
          Row(
            children: List.generate(5, (starIndex) {
              return GestureDetector(
                onTap: () => setState(() => _selectedRating = starIndex + 1),
                child: Icon(
                  starIndex < _selectedRating ? Icons.star : Icons.star_border,
                  color: Colors.amber,
                  size: 32,
                ),
              );
            }),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _feedbackController,
            maxLines: 2,
            decoration: InputDecoration(
              hintText: "Add a comment...",
              filled: true,
              fillColor: Colors.grey.shade50,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade200),
              ),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _submitFeedback(item['id']),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text("Submit Review", style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ],
    ),
  );
}
  Widget _infoChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.08),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, size: 14, color: Colors.blue),
          const SizedBox(width: 5),
          Text(text, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.blue)),
        ],
      ),
    );
  }

  Widget _statusBadge(String status) {
    bool isCommitted = status == "Committed";
    bool isPending = status == "Pending";
    Color baseColor = isCommitted ? Colors.green : (isPending ? Colors.orange : Colors.red);
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: baseColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: baseColor,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
