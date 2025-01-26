import 'package:flutter/material.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 30),
            const Text(
              "IEEE-VESIT",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Login to your account",
              style: TextStyle(
                fontSize: 18,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 30),
            _buildTextField(
              icon: Icons.person,
              hintText: "Username",
            ),
            const SizedBox(height: 20),
            _buildTextField(
              icon: Icons.lock,
              hintText: "Password",
              obscureText: true,
              trailing: GestureDetector(
                onTap: () {
                  // Handle "Forgot password" action
                },
                child: const Text(
                  "Forgot password?",
                  style: TextStyle(
                    color: Color(0xFF002855),
                    fontSize: 12,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                // Handle login
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF002855), // Dark blue color
                padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                "Login",
                style: TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "—Or Login with—",
              style: TextStyle(color: Colors.black54),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {
                // Handle Google login
              },
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
              child: const Text(
                "Login with Google",
                style: TextStyle(
                  color: Color(0xFF002855),
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 30),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/signup'); // Navigate to SignUp page
              },
              child: const Text.rich(
                TextSpan(
                  text: "Don’t have an account? ",
                  style: TextStyle(color: Colors.black54),
                  children: [
                    TextSpan(
                      text: "Sign Up",
                      style: TextStyle(
                        color: Color(0xFF002855),
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
    );
  }

  Widget _buildTextField({
    required IconData icon,
    required String hintText,
    bool obscureText = false,
    Widget? trailing,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.3), // Shadow color
            spreadRadius: 2, // Spread of the shadow
            blurRadius: 5, // Softness of the shadow
            offset: Offset(0, 3), // Shadow position (horizontal, vertical)
          ),
        ],
      ),
      child: TextField(
        obscureText: obscureText,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: const Color(0xFF002855)), // Icon color
          hintText: hintText,
          filled: true,
          fillColor: Colors.white, // Fill color for text field
          contentPadding:
              const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none, // No visible border
          ),
          suffixIcon:
              trailing, // Optional trailing widget (e.g., "Forgot Password")
        ),
      ),
    );
  }
}