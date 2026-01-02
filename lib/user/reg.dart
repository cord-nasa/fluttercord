import 'package:cord/user/loginpage.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

// --- Theme Constants (Matching Login Screen) ---
const Color kSoftWhite = Color(0xFFF7F9FC);
const Color kDeepEmerald = Color.fromARGB(255, 22, 167, 53);
const Color kDarkText = Color(0xFF1E212D);
const Color kSilverAccent = Color(0xFFE0E0E0);

class Registration extends StatefulWidget {
  const Registration({super.key});

  @override
  State<Registration> createState() => _RegistrationState();
}

final String baseurl = 'http://192.168.1.136:5000';
final Dio dio = Dio();

class _RegistrationState extends State<Registration> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phnoController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pswdController = TextEditingController();
  final TextEditingController _placeController = TextEditingController();

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  String? _selectedUserType;
  final List<String> _userTypes = ['user_pending', 'traveler_pending'];
  bool _obscurePassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _phnoController.dispose();
    _emailController.dispose();
    _pswdController.dispose();
    _placeController.dispose();
    super.dispose();
  }

  // --- Logic Kept Exactly Same ---
  Future<void> _postReg() async {
    if (_selectedUserType == null || _selectedUserType!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a role (User or Traveler)')),
      );
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator(color: kDeepEmerald)),
    );

    try {
      final response = await dio.post(
        '$baseurl/UserReg',
        data: {
          'Name': _nameController.text,
          'PhoneNo': _phnoController.text,
          'Email': _emailController.text,
          'Place': _placeController.text,
          'Password': _pswdController.text,
          "Username": _emailController.text,
          'UserType': _selectedUserType, // Uncommented as it's now selected
        },
      );

      if (!mounted) return;
      Navigator.pop(context); // Remove loading

      if (response.statusCode == 200 || response.statusCode == 201) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Loginscreen()),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registration successful')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
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
            top: -50,
            left: -50,
            child: _buildCircleDeco(150, kDeepEmerald.withOpacity(0.05)),
          ),
          Positioned(
            bottom: -80,
            right: -50,
            child: _buildCircleDeco(250, kDeepEmerald.withOpacity(0.05)),
          ),
          
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              child: Form(
                key: _formkey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back_ios_new_rounded, color: kDarkText),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Join CORD',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        color: kDeepEmerald,
                        letterSpacing: 1,
                      ),
                    ),
                    const Text(
                      'Create an account to start your journey',
                      style: TextStyle(fontSize: 16, color: Colors.grey, fontWeight: FontWeight.w400),
                    ),
                    const SizedBox(height: 40),

                    // Role Selection (Styled Dropdown)
                    _buildDropdownLayer(),
                    const SizedBox(height: 18),

                    // Name
                    _buildInputLayer(
                      label: 'Full Name',
                      icon: Icons.person_outline_rounded,
                      controller: _nameController,
                      validator: (v) => v!.isEmpty ? 'Enter your name' : null,
                    ),
                    const SizedBox(height: 18),

                    // Phone
                    _buildInputLayer(
                      label: 'Phone Number',
                      icon: Icons.phone_android_rounded,
                      controller: _phnoController,
                      keyboardType: TextInputType.phone,
                      validator: (v) => v!.isEmpty ? 'Enter phone number' : null,
                    ),
                    const SizedBox(height: 18),

                    // Email
                    _buildInputLayer(
                      label: 'Email Address',
                      icon: Icons.alternate_email_rounded,
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: (v) => !RegExp(r'\S+@\S+\.\S+').hasMatch(v!) ? 'Enter valid email' : null,
                    ),
                    const SizedBox(height: 18),

                    // Place
                    _buildInputLayer(
                      label: 'Place',
                      icon: Icons.location_on_outlined,
                      controller: _placeController,
                      validator: (v) => v!.isEmpty ? 'Enter your location' : null,
                    ),
                    const SizedBox(height: 18),

                    // Password
                    _buildInputLayer(
                      label: 'Password',
                      icon: Icons.lock_outline_rounded,
                      controller: _pswdController,
                      isPassword: true,
                      obscureText: _obscurePassword,
                      onToggle: () => setState(() => _obscurePassword = !_obscurePassword),
                      validator: (v) => v!.length < 6 ? 'Min 6 characters required' : null,
                    ),

                    const SizedBox(height: 40),

                    // Register Button
                    _buildGradientButton(),
                    
                    const SizedBox(height: 20),
                    Center(
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: RichText(
                          text: const TextSpan(
                            style: TextStyle(color: kDarkText, fontSize: 14),
                            children: [
                              TextSpan(text: "Already have an account? "),
                              TextSpan(
                                text: 'Sign In',
                                style: TextStyle(color: kDeepEmerald, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
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

  Widget _buildDropdownLayer() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: kDarkText.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 5))],
      ),
      child: DropdownButtonFormField<String>(
        value: _selectedUserType,
        decoration: InputDecoration(
          labelText: 'Select Role',
          prefixIcon: const Icon(Icons.badge_outlined, color: kDeepEmerald, size: 22),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
        ),
        items: _userTypes.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value.replaceAll('_pending', '').toUpperCase(), style: const TextStyle(fontWeight: FontWeight.w600)),
          );
        }).toList(),
        onChanged: (newValue) => setState(() => _selectedUserType = newValue),
      ),
    );
  }

  Widget _buildInputLayer({
    required String label,
    required IconData icon,
    required TextEditingController controller,
    bool isPassword = false,
    bool obscureText = false,
    VoidCallback? onToggle,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: kDarkText.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 5))],
      ),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword ? obscureText : false,
        keyboardType: keyboardType,
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
          BoxShadow(color: kDeepEmerald.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10)),
        ],
      ),
      child: ElevatedButton(
        onPressed: () {
          if (_formkey.currentState!.validate()) _postReg();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
        child: const Text(
          'CREATE ACCOUNT',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1.5, color: Colors.white),
        ),
      ),
    );
  }
}