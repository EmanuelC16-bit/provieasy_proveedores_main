import 'package:flutter/material.dart';
import 'package:provieasy_proveedores_main/pages/HomePage.dart';

void main() {
  runApp(const ProviEasyProviderApp());
}

class ProviEasyProviderApp extends StatelessWidget {
  const ProviEasyProviderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ProviEasy Proveedores',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.purple,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscureText = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          ClipPath(
            clipper: CurveClipper(),
            child: Container(
              height: height * 0.4,
              color: const Color.fromARGB(255, 179, 157, 219),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Welcome back!",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Login to access your account",
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Form(
                key: _formKey,
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(40),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.email, color: Colors.grey),
                          labelText: "Email",
                        ),
                        validator: (v) => v == null || v.trim().isEmpty
                            ? 'Please enter your email'
                            : null,
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscureText,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.lock, color: Colors.grey),
                          labelText: "Password",
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureText
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.grey,
                            ),
                            onPressed: () => setState(() {
                              _obscureText = !_obscureText;
                            }),
                          ),
                        ),
                        validator: (v) => v == null || v.isEmpty
                            ? 'Please enter your password'
                            : null,
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Forgot password clicked'))),
                          child: const Text(
                            "Forgot password?",
                            style: TextStyle(color: Colors.purple),
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            // Navegar a la vista de proveedores
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProviderHomePage(),
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 126, 87, 194),
                          minimumSize: const Size(double.infinity, 50),
                          shape: const StadiumBorder(),
                        ),
                        child: const Text(
                          "Login",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Don’t have an account? "),
                          GestureDetector(
                            onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Sign up clicked'))),
                            child: const Text(
                              "Sign Up",
                              style: TextStyle(
                                color: Colors.purple,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
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
}

class CurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 100);
    path.quadraticBezierTo(
      size.width / 2,
      size.height,
      size.width,
      size.height - 100,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
