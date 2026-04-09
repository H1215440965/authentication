import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'authentication_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthService _authService = AuthService();
  final TextEditingController _newPasswordController =
      TextEditingController();

  void logout() async {
    await _authService.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const AuthenticationScreen()),
    );
  }

  void changePassword() async {
    try {
      await _authService.changePassword(_newPasswordController.text);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Password updated")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = _authService.currentUser;

    return Scaffold(
      appBar: AppBar(title: const Text("Profile")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text("Email: ${user?.email ?? "No user"}"),

            const SizedBox(height: 20),

            TextField(
              controller: _newPasswordController,
              decoration:
                  const InputDecoration(labelText: "New Password"),
              obscureText: true,
            ),

            ElevatedButton(
              onPressed: changePassword,
              child: const Text("Change Password"),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: logout,
              child: const Text("Logout"),
            ),
          ],
        ),
      ),
    );
  }
}