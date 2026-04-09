import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'profile_screen.dart';

class AuthenticationScreen extends StatefulWidget {
  const AuthenticationScreen({super.key});

  @override
  State<AuthenticationScreen> createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  bool isLogin = true;
  bool isLoading = false;

  void submit() async {
    if (_formKey.currentState!.validate()) {
      setState(() => isLoading = true);

      try {
        if (isLogin) {
          await _authService.signIn(
              _emailController.text, _passwordController.text);
        } else {
          await _authService.register(
              _emailController.text, _passwordController.text);
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Success!")),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const ProfileScreen()),
        );
      } catch (e) {
        String message = "Something went wrong";

        if (e.toString().contains('invalid-credential')) {
          message = "Wrong email or password";
        } else if (e.toString().contains('email-already-in-use')) {
          message = "Email already registered";
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      }

      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.deepPurple, Colors.blue],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Center(
              child: Card(
                elevation: 10,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          isLogin ? "Welcome Back" : "Create Account",
                          style: const TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 20),

                        TextFormField(
                          controller: _emailController,
                          decoration:
                              const InputDecoration(labelText: "Email"),
                          validator: (v) =>
                              v!.contains('@') ? null : "Invalid email",
                        ),

                        TextFormField(
                          controller: _passwordController,
                          decoration:
                              const InputDecoration(labelText: "Password"),
                          obscureText: true,
                          validator: (v) =>
                              v!.length >= 6 ? null : "Min 6 chars",
                        ),

                        const SizedBox(height: 20),

                        ElevatedButton(
                          onPressed: submit,
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 50),
                          ),
                          child: Text(isLogin ? "Login" : "Register"),
                        ),

                        TextButton(
                          onPressed: () {
                            setState(() => isLogin = !isLogin);
                          },
                          child: Text(isLogin
                              ? "Create account"
                              : "Already have account?"),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          /// 🔥 Loading overlay
          if (isLoading)
            Container(
              color: Colors.black.withOpacity(0.4),
              child: const Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
            )
        ],
      ),
    );
  }
}