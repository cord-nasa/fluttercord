import 'package:cord/traveler/home.dart';
import 'package:cord/user/home.dart';
import 'package:cord/user/reg.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

// --- PLACEHOLDER SCREENS (Used to make the file compile and run independently) ---
// These simulate the imported external screen files: `reg.dart` and `home.dart`.

// -----------------------------------------------------------------------------

// --- Theme Constants for White-Green Aesthetic (Ecofriendly Theme) ---
const Color kSoftWhite = Color(0xFFF7F9FC); // Primary background
const Color kDeepEmerald = Color.fromARGB(
  255,
  22,
  167,
  53,
); // Primary accent color (Deep Green)
const Color kDarkText = Color(0xFF1E212D); // Secondary accent/text color
const Color kSilverAccent = Color(0xFFE0E0E0); // Light gray for borders

// The main widget is a StatefulWidget for managing form state and inputs.
class Loginscreen extends StatefulWidget {
  const Loginscreen({super.key});

  @override
  State<Loginscreen> createState() => _LoginscreenState();
}

final String _baseurl = 'http://192.168.1.74:5000';
final Dio _dio = Dio();

class _LoginscreenState extends State<Loginscreen> {
  // Form State and Controllers for full functionality
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String? usertype;

  Future<void> _postlogin() async {
    try {
      final response = await _dio.post(
        '$_baseurl/LoginAPI',
        data: {
          'username': _usernameController.text,
          'Password': _passwordController.text,
        },
      );

      print(response.data);
      usertype=response.data['userrole'];

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (usertype == 'user') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
        } else if (usertype == 'traveler') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const TravelerHomePage()),
          );
        } else {
          if (!mounted) return;
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text(' Admin login not allowed')));
        }
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Login failed')));
      }
    } catch (e) {
      print('Login Error: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: ${e.toString()}')),
      );
    }
  }

  // Login logic with form validation and navigation

  // Helper method for consistent aesthetic text fields
  Widget _buildAestheticTextField({
    required String label,
    required TextEditingController controller,
    bool isPassword = false,
    String? Function(String?)? validator,
    TextInputAction inputAction = TextInputAction.next,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword,
        validator: validator,
        textInputAction: inputAction,
        style: const TextStyle(color: kDarkText, letterSpacing: 0.5),
        cursorColor: kDeepEmerald,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            color: kDarkText.withOpacity(0.6),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          filled: true,
          fillColor: Colors.white, // Pure white fill
          contentPadding: const EdgeInsets.symmetric(
            vertical: 20.0,
            horizontal: 20.0,
          ),

          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: const BorderSide(color: kSilverAccent, width: 1.0),
          ),

          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: const BorderSide(
              color: kDeepEmerald,
              width: 2.0,
            ), // Emerald focus border
          ),

          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(color: Colors.green, width: 1.0),
          ),

          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(color: Colors.green, width: 2.0),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kSoftWhite,

      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'C O R D',
          style: TextStyle(
            color: kDeepEmerald,
            fontWeight: FontWeight.bold,
            letterSpacing: 3.0,
            fontSize: 22,
          ),
        ),
        iconTheme: const IconThemeData(color: kDarkText),
      ),

      body: Center(
        child: SingleChildScrollView(
          child: Form(
            // Form widget enables validation via the key
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 80),

                // Travel Icon with subtle Green lift
                Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: kDeepEmerald.withOpacity(0.1),
                        blurRadius: 30,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.travel_explore, // Aesthetic travel/explore icon
                    size: 90,
                    color: kDeepEmerald,
                  ),
                ),

                const Padding(
                  padding: EdgeInsets.only(bottom: 40.0),
                  child: Text(
                    'Welcome Back',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: kDarkText,
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                // Input Fields with validation and controllers
                _buildAestheticTextField(
                  label: 'Username',
                  controller: _usernameController,
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please enter your username.'
                      : null,
                ),
                _buildAestheticTextField(
                  label: 'Password',
                  controller: _passwordController,
                  isPassword: true,
                  inputAction: TextInputAction.done,
                  validator: (value) => value == null || value.length < 6
                      ? 'Password must be at least 6 characters.'
                      : null,
                ),

                const SizedBox(height: 40),

                // Login Button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _postlogin(); 
                       
                        
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kDeepEmerald,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 56),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 8,
                      shadowColor: kDeepEmerald.withOpacity(0.4),
                    ),
                    child: const Text(
                      'SIGN IN',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Registration Text Button
                TextButton(
                  onPressed: () {
                    // Navigate to Registration screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Registration()),
                    );
                  },
                  child: RichText(
                    text: const TextSpan(
                      style: TextStyle(
                        fontSize: 14,
                        color: kDarkText,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.5,
                      ),
                      children: <TextSpan>[
                        TextSpan(text: "Don't have an account? "),
                        TextSpan(
                          text: 'Register Now',
                          style: TextStyle(
                            color: kDeepEmerald,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
