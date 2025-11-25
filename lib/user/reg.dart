import 'package:cord/user/loginpage.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';



class Registration extends StatefulWidget {
  const Registration({super.key});

  @override
  State<Registration> createState() => _RegistrationState();
}
  final String _baseurl = 'http://192.168.1.74:5000';
  final Dio _dio = Dio();
class _RegistrationState extends State<Registration> {
  // Reintroduced form controllers and networking setup
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phnoController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pswdController = TextEditingController();
  final TextEditingController _placeController = TextEditingController();
  
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  
  String? _selectedUserType; // State for the new dropdown
  final List<String> _userTypes = ['user_pending', 'traveler_pending'];



  @override
  void dispose() {
    _nameController.dispose();
    _phnoController.dispose();
    _emailController.dispose();
    _pswdController.dispose();
    _placeController.dispose();
    super.dispose();
  }

  Future<void> _postReg() async {
    // Check if a user type has been selected
    if (_selectedUserType == null || _selectedUserType!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a role (User or Traveler)')),
      );
      return;
    }

    try {
      final response = await _dio.post(
        '$_baseurl/UserReg',
        data: {
          'Name': _nameController.text,
          'PhoneNo': _phnoController.text,
          'Email': _emailController.text,
          'Place': _placeController.text,
          'Password': _pswdController.text,
          "Username": _emailController.text,
          // Sending the selected user type to the backend
          'UserType': _selectedUserType, 
        },
      );

      print(response.data);

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Loginscreen()),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registration successful')),
        );
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registration failed')),
        );
      }
    } catch (e) {
      print('Registration Error: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: ${e.toString()}')),
      );
    }
  }

  // Common input decoration style
  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      label: Text(label),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(color: Colors.green),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(color: Colors.green, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(color: Colors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(color: Colors.red, width: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 22, 167, 53),
        title: const Text(
          'User Registration',
          style: TextStyle(color: Color.fromARGB(255, 249, 247, 250)),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formkey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Create Your Account',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),

              // --- New: User Type Dropdown ---
              DropdownButtonFormField<String>(
                decoration: _inputDecoration('Select Role'),
                hint: const Text('Choose role (User or Traveler)'),
                value: _selectedUserType,
                validator: (value) => value == null ? 'Please select a role' : null,
                items: _userTypes
                    .map((String value) => DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        ))
                    .toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedUserType = newValue;
                  });
                },
              ),
              const SizedBox(height: 20),

              // --- Name Field ---
              TextFormField(
                controller: _nameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
                decoration: _inputDecoration('Name'),
              ),
              const SizedBox(height: 20),

              // --- Phone Number Field ---
              TextFormField(
                controller: _phnoController,
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  return null;
                },
                decoration: _inputDecoration('Phone No.'),
              ),
              const SizedBox(height: 20),

              // --- Email Field ---
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  // Simple email format check
                  if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                    return 'Enter a valid email address';
                  }
                  return null;
                },
                decoration: _inputDecoration('Email'),
              ),
              const SizedBox(height: 20),

              // --- Place Field ---
              TextFormField(
                controller: _placeController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your Place';
                  }
                  return null;
                },
                decoration: _inputDecoration('Place'),
              ),
              const SizedBox(height: 20),

              // --- Password Field ---
              TextFormField(
                controller: _pswdController,
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your Password';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters long';
                  }
                  return null;
                },
                decoration: _inputDecoration('Password'),
              ),
              const SizedBox(height: 30),

              // --- Registration Button ---
              ElevatedButton(
                onPressed: () {
                  if (_formkey.currentState!.validate()) {
                    _postReg();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 22, 167, 53),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 5,
                ),
                child: const Text(
                  'Register',
                  style: TextStyle(
                    color: Color.fromARGB(255, 249, 247, 250),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Removed the main/MyApp functions that were only for demonstration