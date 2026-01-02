import 'package:cord/traveler/home.dart';
import 'package:cord/user/home.dart';
import 'package:cord/user/reg.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

// --- Theme Constants (Kept as provided) ---
const Color kSoftWhite = Color(0xFFF7F9FC);
const Color kDeepEmerald = Color.fromARGB(255, 22, 167, 53);
const Color kDarkText = Color(0xFF1E212D);
const Color kSilverAccent = Color(0xFFE0E0E0);

String? usertype;
int? loginid;

class Loginscreen extends StatefulWidget {
  const Loginscreen({super.key});

  @override
  State<Loginscreen> createState() => _LoginscreenState();
}

class _LoginscreenState extends State<Loginscreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true; // Added for password toggle UI

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // --- LOGIC KEPT EXACTLY SAME ---
  Future<void> _postlogin() async {
    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator(color: kDeepEmerald)),
    );

    try {
      final response = await Dio().post(
        '$baseurl/LoginAPI',
        data: {
          'username': _usernameController.text.trim(),
          'Password': _passwordController.text,
        },
      );
      if (!mounted) return;
      Navigator.pop(context); // Remove loading

      usertype = response.data['userrole'];
      loginid = response.data['login_id'];

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (usertype == 'user') {
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const HomePage()), (route) => false);
        } else if (usertype == 'traveler') {
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const TravelerHomePage()), (route) => false);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Admin login not allowed')));
        }
      }
    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kSoftWhite,
      body: Stack(
        children: [
          // Background Aesthetic Decoration
          Positioned(
            top: -100,
            right: -50,
            child: _buildCircleDeco(300, kDeepEmerald.withOpacity(0.05)),
          ),
          Positioned(
            bottom: -50,
            left: -50,
            child: _buildCircleDeco(200, kDeepEmerald.withOpacity(0.05)),
          ),
          
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Enhanced Logo Section
                      _buildEnhancedLogo(),
                      const SizedBox(height: 20),
                      const Text(
                        'C O R D',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                          color: kDeepEmerald,
                          letterSpacing: 6,
                        ),
                      ),
                      const Text(
                        'Sustainable Movement',
                        style: TextStyle(
                          fontSize: 14,
                          color: kDarkText,
                          letterSpacing: 1.2,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      const SizedBox(height: 60),

                      // Username Field
                      _buildInputLayer(
                        label: 'Username',
                        icon: Icons.person_outline_rounded,
                        controller: _usernameController,
                        validator: (v) => v!.isEmpty ? 'Please enter username' : null,
                      ),
                      const SizedBox(height: 18),

                      // Password Field
                      _buildInputLayer(
                        label: 'Password',
                        icon: Icons.lock_outline_rounded,
                        controller: _passwordController,
                        isPassword: true,
                        obscureText: _obscurePassword,
                        onToggle: () => setState(() => _obscurePassword = !_obscurePassword),
                        validator: (v) => v!.length < 6 ? 'Password too short' : null,
                      ),
                      
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {},
                          child: Text('Forgot Password?', style: TextStyle(color: kDarkText.withOpacity(0.6))),
                        ),
                      ),
                      
                      const SizedBox(height: 30),

                      // Sign In Button
                      _buildGradientButton(),

                      const SizedBox(height: 40),
                      
                      // Registration Link
                      _buildRegisterLink(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- UI COMPONENTS ---

  Widget _buildCircleDeco(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }

  Widget _buildEnhancedLogo() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: kDeepEmerald.withOpacity(0.15),
            blurRadius: 40,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: const Icon(Icons.travel_explore_rounded, size: 80, color: kDeepEmerald),
    );
  }

  Widget _buildInputLayer({
    required String label,
    required IconData icon,
    required TextEditingController controller,
    bool isPassword = false,
    bool obscureText = false,
    VoidCallback? onToggle,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: kDarkText.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword ? obscureText : false,
        validator: validator,
        style: const TextStyle(color: kDarkText, fontWeight: FontWeight.w500),
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: kDeepEmerald, size: 22),
          suffixIcon: isPassword 
            ? IconButton(
                icon: Icon(obscureText ? Icons.visibility_off : Icons.visibility, color: kSilverAccent),
                onPressed: onToggle,
              ) 
            : null,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
          contentPadding: const EdgeInsets.symmetric(vertical: 20),
        ),
      ),
    );
  }

  Widget _buildGradientButton() {
    return Container(
      width: double.infinity,
      height: 58,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        gradient: LinearGradient(
          colors: [kDeepEmerald, kDeepEmerald.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: kDeepEmerald.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) _postlogin();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
        child: const Text(
          'SIGN IN',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 2, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildRegisterLink() {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => Registration())),
      child: RichText(
        text: const TextSpan(
          style: TextStyle(color: kDarkText, fontSize: 14),
          children: [
            TextSpan(text: "Don't have an account? "),
            TextSpan(
              text: 'Register Now',
              style: TextStyle(color: kDeepEmerald, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}