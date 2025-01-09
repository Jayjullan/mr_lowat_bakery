import 'package:flutter/material.dart';
import 'package:mr_lowat_bakery/userscreens/services/auth_services.dart'; // Import AuthService
import 'package:mr_lowat_bakery/userscreens/login/sign_in.dart'; // Import the sign-in screen

class NewAccount extends StatefulWidget {
  const NewAccount({super.key});

  @override
  _NewAccountState createState() => _NewAccountState();
}

class _NewAccountState extends State<NewAccount> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Account'),
        backgroundColor: Colors.pink,
      ),
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/CustomerLogin.jpg', // Ensure the image path is correct
              fit: BoxFit.cover,
            ),
          ),
          // Form Content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 20),
                Container(
                  alignment: Alignment.center,
                  child: const Text(
                    'Sign Up',
                    style: TextStyle(
                      fontSize: 40,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // First Name Field
                buildTextField("First Name", controller: _firstNameController),
                const SizedBox(height: 20),
                // Last Name Field
                buildTextField("Last Name", controller: _lastNameController),
                const SizedBox(height: 20),
                // Username Field
                buildTextField("Username", controller: _usernameController),
                const SizedBox(height: 20),
                // Email Field
                buildTextField("Email", controller: _emailController),
                const SizedBox(height: 20),
                // Phone Number Field
                buildTextField("Phone Number", controller: _phoneController),
                const SizedBox(height: 20),
                // Password Field
                buildTextField("Password", controller: _passwordController, obscureText: true),
                const SizedBox(height: 30),
                // Error Message Display
                if (_errorMessage != null)
                  Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                const SizedBox(height: 10),
                // Sign-Up Button
                Center(
                  child: SizedBox(
                    width: 150,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pink,
                      ),
                      onPressed: _isLoading ? null : _signUp,
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              "Sign Up",
                              style: TextStyle(fontSize: 20, color: Colors.white),
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to build a text field
  Widget buildTextField(String hintText, {bool obscureText = false, required TextEditingController controller}) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: Colors.white.withOpacity(0.8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 15,
        ),
      ),
    );
  }

  // Sign up method with Firebase Authentication and Firestore using AuthService
  Future<void> _signUp() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    // Get input values
    String firstName = _firstNameController.text.trim();
    String lastName = _lastNameController.text.trim();
    String username = _usernameController.text.trim();
    String email = _emailController.text.trim();
    String phone = _phoneController.text.trim();
    String password = _passwordController.text.trim();

    // Simple validation checks
    if (firstName.isEmpty || lastName.isEmpty || username.isEmpty || email.isEmpty || phone.isEmpty || password.isEmpty) {
      setState(() {
        _errorMessage = 'All fields are required.';
      });
      setState(() => _isLoading = false);
      return;
    }

    // Validate email format
    if (!RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$").hasMatch(email)) {
      setState(() {
        _errorMessage = 'Please enter a valid email address.';
      });
      setState(() => _isLoading = false);
      return;
    }

    try {
      // Call the sign-up method from AuthService
      await _authService.signUp(
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
        phone: phone,
      );

      // Navigate to the login screen after successful sign-up
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sign Up successful!')),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    } catch (e) {
      setState(() {
        _errorMessage = 'An error occurred: $e';
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }
}
