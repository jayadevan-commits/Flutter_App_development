import 'package:flutter/material.dart';
import 'package:my_form_app/services/api_service.dart';
import 'login_screen.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String email;
   final String otp;

  const ResetPasswordScreen({super.key,
  required this. email,
  required this. otp,});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {

  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool isLoading = false;

  Future<void> resetPassword() async {
    if (newPasswordController.text.trim().isEmpty ||
        confirmPasswordController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Password fields cannot be empty")),
      );
      return;
    }
    
    if (newPasswordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Passwords do not match")),
      );
      return;
    }

    setState(() => isLoading = true);

    final sucess = await ApiService.resetPassword(
      widget.email, // same user email
      widget.otp,
      newPasswordController.text.trim(),
      confirmPasswordController.text.trim(),
    );
  
    setState(() => isLoading = false);
    
  if (sucess) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text(" Password reset successful")),
      );

     Navigator.pushAndRemoveUntil(
      context, 
     MaterialPageRoute(builder: (_)=> const LoginScreen()),
     (route) => false,
     ) ;
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("OTP verification required or failed")),
    );
  }
  }

  @override
  void dispose() {
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
  
     return Scaffold(
      appBar: AppBar(title: const Text("Reset Password")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: newPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "New Password",
                prefixIcon: Icon(Icons.lock),
              ),
            ),

             const SizedBox(height: 16),

            TextField(
              controller: confirmPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Confirm Password",
                prefixIcon: Icon(Icons.lock_outline),
              ),
            ),

            const SizedBox(height: 24),

             SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: isLoading ? null : resetPassword,
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Update Password"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
