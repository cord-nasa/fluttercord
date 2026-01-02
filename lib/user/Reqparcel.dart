import 'dart:async';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cord/user/loginpage.dart'; 
import 'package:cord/user/reg.dart';       

/// ================= DATA MODEL =================
class ParcelListing {
  final int travelerId;
  final int id;
  final String from;
  final String to;
  final String availability;
  final String startTime;
  final String endTime;
  final String rideType;
  final String weightCapacity;
  final String amount;
  final String driverName;
  final String driverPhone;

  ParcelListing({
    required this.travelerId,
    required this.id,
    required this.from,
    required this.to,
    required this.availability,
    required this.startTime,
    required this.endTime,
    required this.rideType,
    required this.weightCapacity,
    required this.amount,
    required this.driverName,
    required this.driverPhone,
  });

  factory ParcelListing.fromJson(Map<String, dynamic> json) {
    return ParcelListing(
      travelerId: json['TRAVELERID'],
      from: json['StartLocation'] ?? "Unknown",
      to: json['EndLocation'] ?? "Unknown",
      availability: json['RideAvailability'] ?? "Not Specified",
      startTime: json['StartingTime'] ?? "",
      endTime: json['EndingTime'] ?? "",
      rideType: json['RideType'] ?? "Parcel",
      weightCapacity: json['SpaceAvailability'] ?? "N/A",
      amount: json['Amount'].toString(),
      id: json['id'].toInt(),
      driverName: json['drivername'] ?? "Eco Traveler",
      driverPhone: json['driverphone'] ?? "",
    );
  }
}

/// ================= MAIN PARCEL PAGE =================
class ParcelBookingPage extends StatefulWidget {
  const ParcelBookingPage({super.key});

  @override
  State<ParcelBookingPage> createState() => _ParcelBookingPageState();
}

class _ParcelBookingPageState extends State<ParcelBookingPage> {
  final Dio _dio = Dio();
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _pickupController = TextEditingController();
  final TextEditingController _dropController = TextEditingController();

  List<ParcelListing> _allRoutes = [];
  List<ParcelListing> _filteredRoutes = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    fetchParcelRoutes();
  }

  // --- CHAT NAVIGATION FUNCTION ---
  void _openChat(ParcelListing item) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatPage(
          receiverId: item.travelerId,
          receiverName: item.driverName,
        ),
      ),
    );
  }

  Future<void> fetchParcelRoutes() async {
    try {
      final response = await _dio.get("$baseurl/ViewParcelTravelRouteAPI");
      List data = response.data;
      setState(() {
        _allRoutes = data.map((e) => ParcelListing.fromJson(e)).toList();
        _filteredRoutes = _allRoutes;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
    }
  }

  void _applyFilter(String query) {
    setState(() {
      _filteredRoutes = _allRoutes
          .where((e) =>
              e.from.toLowerCase().contains(query.toLowerCase()) ||
              e.to.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    }
  }

  Future<void> bookParcel(ParcelListing item) async {
    try {
      await _dio.post(
        "$baseurl/BookingAPI",
        data: {
          'USERID': loginid,
          "TRAVELERID": item.id,
          "TRAVELERID1": item.travelerId,
          "PickupLocation": _pickupController.text,
          "DropLocation": _dropController.text,
        },
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Parcel request sent! 🌱"),
          backgroundColor: Colors.green.shade800,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Booking failed")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9F7),
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text("Eco Parcel Finder", 
          style: TextStyle(fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 0.5)),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF1B5E20), Color(0xFF388E3C)]),
          ),
        ),
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator(color: Color(0xFF2E7D32)))
                : _filteredRoutes.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        itemCount: _filteredRoutes.length,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) => _parcelCard(_filteredRoutes[index]),
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: TextField(
        controller: _searchController,
        onChanged: _applyFilter,
        decoration: InputDecoration(
          hintText: "Search delivery routes...",
          prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFF2E7D32)),
          filled: true,
          fillColor: const Color(0xFFF1F4F1),
          contentPadding: const EdgeInsets.symmetric(vertical: 0),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
        ),
      ),
    );
  }

  Widget _parcelCard(ParcelListing item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [BoxShadow(color: Colors.green.withOpacity(0.08), blurRadius: 20, offset: const Offset(0, 10))],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 22,
                  backgroundColor: Color(0xFFE8F5E9),
                  child: Icon(Icons.inventory_2_rounded, color: Color(0xFF2E7D32)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.driverName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      const Text("Verified Eco-Courier", style: TextStyle(color: Colors.green, fontSize: 11, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
                _roundActionBtn(Icons.chat_bubble_rounded, Colors.blue, () => _openChat(item)),
                const SizedBox(width: 8),
                _roundActionBtn(Icons.call_rounded, Colors.green, () => _makePhoneCall(item.driverPhone)),
              ],
            ),
          ),
          const Divider(height: 1, indent: 16, endIndent: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: IntrinsicHeight(
              child: Row(
                children: [
                  Column(
                    children: [
                      const Icon(Icons.radio_button_checked_rounded, color: Colors.green, size: 16),
                      Expanded(child: Container(width: 2, decoration: BoxDecoration(color: Colors.green.shade100, borderRadius: BorderRadius.circular(2)))),
                      const Icon(Icons.location_on_rounded, color: Colors.orange, size: 18),
                    ],
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      children: [
                        _routeDetail(item.from, item.startTime, true),
                        const SizedBox(height: 25),
                        _routeDetail(item.to, item.endTime, false),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(color: const Color(0xFFF9FBF9), borderRadius: BorderRadius.circular(16)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("FARE", style: TextStyle(fontSize: 9, color: Colors.grey, fontWeight: FontWeight.w800)),
                    Text("₹${item.amount}", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFF1B5E20))),
                  ],
                ),
                Row(
                  children: [
                    _chip(Icons.scale_rounded, item.weightCapacity),
                    const SizedBox(width: 6),
                    _chip(Icons.calendar_month_rounded, item.availability),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () => _showBookingSheet(item),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2E7D32),
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                child: const Text("SEND PARCEL", 
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, letterSpacing: 1)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _routeDetail(String city, String time, bool isMain) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: Text(city, style: TextStyle(fontSize: 15, fontWeight: isMain ? FontWeight.w700 : FontWeight.w500, color: const Color(0xFF37474F)))),
        Text(time, style: TextStyle(color: isMain ? const Color(0xFF2E7D32) : Colors.blueGrey, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _roundActionBtn(IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
        child: Icon(icon, color: color, size: 18),
      ),
    );
  }

  Widget _chip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.green.shade50)),
      child: Row(children: [Icon(icon, size: 12, color: Colors.green), const SizedBox(width: 5), Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold))]),
    );
  }

  void _showBookingSheet(ParcelListing item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 24, right: 24, top: 12),
        decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(32))),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10))),
            const SizedBox(height: 20),
            const Text("Delivery Confirmation", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
            const SizedBox(height: 20),
            _sheetField(_pickupController, "Pickup Point", Icons.my_location_rounded),
            const SizedBox(height: 15),
            _sheetField(_dropController, "Recipient's Point", Icons.flag_rounded),
            const SizedBox(height: 25),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () { 
                   if(_pickupController.text.isNotEmpty && _dropController.text.isNotEmpty){
                     Navigator.pop(context); bookParcel(item); 
                   }
                },
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1B5E20), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                child: const Text("Request Eco-Delivery", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ),
            const SizedBox(height: 25),
          ],
        ),
      ),
    );
  }

  Widget _sheetField(TextEditingController controller, String label, IconData icon) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.green, size: 20),
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.inventory_2_outlined, size: 70, color: Colors.grey[300]),
        const SizedBox(height: 16),
        Text("No delivery routes found", style: TextStyle(color: Colors.grey[500], fontSize: 16, fontWeight: FontWeight.w600)),
      ],
    ));
  }
}

/// ================= CHAT PAGE =================
class ChatPage extends StatefulWidget {
  final int receiverId;
  final String receiverName;

  const ChatPage({super.key, required this.receiverId, required this.receiverName});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _msgController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<dynamic> _messages = [];
  Timer? _refreshTimer;
  final Dio _chatDio = Dio();

  @override
  void initState() {
    super.initState();
    _getMessages();
    _refreshTimer = Timer.periodic(const Duration(seconds: 3), (t) => _getMessages());
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  Future<void> _getMessages() async {
    try {
      final res = await _chatDio.get("$baseurl/ViewChatAPI", queryParameters: {
        "sender_id": loginid,
        "receiver_id": widget.receiverId,
      });
      if (res.statusCode == 200) setState(() => _messages = res.data);
    } catch (e) { debugPrint(e.toString()); }
  }

  Future<void> _send() async {
    if (_msgController.text.trim().isEmpty) return;
    String text = _msgController.text.trim();
    _msgController.clear();
    try {
      await _chatDio.post("$baseurl/ChatAPI", data: {
        "from_id": loginid,
        "to_id": widget.receiverId,
        "message": text,
        "date": DateTime.now().toString(),
      });
      _getMessages();
    } catch (e) { debugPrint(e.toString()); }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F4F1),
      appBar: AppBar(
        title: Text(widget.receiverName, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: const Color(0xFF1B5E20),
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              itemCount: _messages.length,
              itemBuilder: (context, i) {
                bool isMe = _messages[i]['from_id'].toString() == loginid.toString();
                return Align(
                  alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    margin: const EdgeInsets.only(bottom: 8),
                    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
                    decoration: BoxDecoration(
                      color: isMe ? const Color(0xFF2E7D32) : Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(16),
                        topRight: const Radius.circular(16),
                        bottomLeft: Radius.circular(isMe ? 16 : 0),
                        bottomRight: Radius.circular(isMe ? 0 : 16),
                      ),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5)],
                    ),
                    child: Text(_messages[i]['message'], 
                      style: TextStyle(color: isMe ? Colors.white : Colors.black87, fontSize: 15)),
                  ),
                );
              },
            ),
          ),
          _buildChatInput(),
        ],
      ),
    );
  }

  Widget _buildChatInput() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -2))]),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(color: const Color(0xFFF1F3F1), borderRadius: BorderRadius.circular(25)),
                child: TextField(
                  controller: _msgController,
                  decoration: const InputDecoration(hintText: "Message...", border: InputBorder.none),
                ),
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: _send,
              child: const CircleAvatar(radius: 24, backgroundColor: Color(0xFF1B5E20), child: Icon(Icons.send_rounded, color: Colors.white, size: 20)),
            ),
          ],
        ),
      ),
    );
  }
}