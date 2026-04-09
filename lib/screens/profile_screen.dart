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
  final TextEditingController _passwordController =
      TextEditingController();

  void logout() async {
    await _authService.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const AuthenticationScreen()),
    );
  }

  void changePassword() async {
    if (_passwordController.text.length < 6) return;

    await _authService.changePassword(_passwordController.text);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Password updated")),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = _authService.currentUser;

    return Scaffold(
      appBar: AppBar(title: const Text("Profile")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            CircleAvatar(
              radius: 40,
              child: Text(
                user?.email?[0].toUpperCase() ?? "U",
                style: const TextStyle(fontSize: 30),
              ),
            ),

            const SizedBox(height: 20),

            Text(
              user?.email ?? "",
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 30),

            TextField(
              controller: _passwordController,
              decoration:
                  const InputDecoration(labelText: "New Password"),
              obscureText: true,
            ),

            const SizedBox(height: 10),

            ElevatedButton(
              onPressed: changePassword,
              child: const Text("Change Password"),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: logout,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: const Text("Logout"),
            ),
          ],
        ),
      ),
    );
  }
}