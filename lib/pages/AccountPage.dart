import 'dart:convert';
import 'package:flutter/material.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';
import 'package:provieasy_proveedores_main/AuthStorage.dart';
import 'package:provieasy_proveedores_main/services/UserService.dart' show UserService;
// import 'package:provieasy_main_version/pages/AccountInfoPage.dart';
// import 'package:provieasy_main_version/pages/LegalPage.dart';
// import 'package:provieasy_main_version/pages/MessagesPage.dart';
// import 'package:provieasy_main_version/pages/NotificationsPage.dart';
// import 'package:provieasy_main_version/pages/PaymentPage.dart';
// import 'package:provieasy_main_version/pages/ProgramActivityPage.dart';
// import 'package:provieasy_main_version/pages/SettingsPage.dart';
// import 'package:provieasy_main_version/services/UserService.dart';
// import 'package:provieasy_main_version/main.dart';

final logger = Logger();

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  late Future<Map<String, dynamic>> _userFuture;

  @override
  void initState() {
    super.initState();
    _userFuture = _loadUserProfile();
  }

  Future<Map<String, dynamic>> _loadUserProfile() async {
    final cached = await AuthStorage.userProfileJson;
    if (cached != null) {
      return jsonDecode(cached) as Map<String, dynamic>;
    }
    final fresh = await UserService.fetchUserDetails(context);
    await AuthStorage.saveUserProfile(jsonEncode(fresh));
    return fresh;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _userFuture,
      builder: (ctx, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return const Center(child: Text('Error: \${snapshot.error}'));
        }
        final user = snapshot.data!;
        final name = user['name'] as String? ?? 'User';

        return Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Greeting & Avatar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            style: const TextStyle(
                                fontSize: 24, color: Colors.black),
                            children: [
                              const TextSpan(
                                text: "Hello, ",
                                style: TextStyle(fontWeight: FontWeight.w300),
                              ),
                              TextSpan(
                                text: name,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    CircleAvatar(
                      radius: 30,
                      // backgroundImage:
                      //     const AssetImage('lib/assets/carpenter.png'),
                      backgroundColor: Colors.grey[300],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Payment & Activity Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildCapsuleButton(Icons.payment, 'Payment', context),
                  _buildCapsuleButton(Icons.timeline, 'Activity', context),
                ],
              ),
              const SizedBox(height: 20),
              const Divider(thickness: 1, color: Colors.grey),
              const SizedBox(height: 10),
              // Navigation options
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    _buildOptionItem(context, Icons.person, 'Manage Account'),
                    _buildOptionItem(
                        context, Icons.notifications, 'Notifications'),
                    _buildOptionItem(context, Icons.message, 'Messages'),
                    _buildOptionItem(context, Icons.gavel, 'Legal'),
                    _buildOptionItem(context, Icons.settings, 'Settings'),
                    _buildOptionItem(context, Icons.logout, 'Sign Out',
                        isLogout: true),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCapsuleButton(
      IconData icon, String label, BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        // if (label == 'Payment') {
        //   Navigator.push(
        //       context, MaterialPageRoute(builder: (_) => PaymentPage()));
        // } else if (label == 'Activity') {
        //   Navigator.push(context,
        //       MaterialPageRoute(builder: (_) => ProgramActivityPage()));
        // }
      },
      icon: Icon(icon, color: Colors.white),
      label: Text(label, style: const TextStyle(color: Colors.white)),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 126, 87, 194),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    );
  }

  Widget _buildOptionItem(BuildContext context, IconData icon, String title,
      {bool isLogout = false}) {
    return ListTile(
      leading: Icon(icon, color: isLogout ? Colors.red : Colors.black),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: isLogout ? FontWeight.bold : FontWeight.normal,
          color: isLogout ? Colors.red : Colors.black,
        ),
      ),
      onTap: () async {
        switch (title) {
          case 'Manage Account':
            // Navigator.push(
            //     context, MaterialPageRoute(builder: (_) => const AccountInfoPage()));
            break;
          case 'Notifications':
            // Navigator.push(context,
            //     MaterialPageRoute(builder: (_) => NotificationsPage()));
            break;
          case 'Messages':
            // Navigator.push(
            //     context, MaterialPageRoute(builder: (_) => MessagesPage()));
            break;
          case 'Legal':
            // Navigator.push(
            //     context, MaterialPageRoute(builder: (_) => LegalPage()));
            break;
          case 'Settings':
            // Navigator.push(
            //     context, MaterialPageRoute(builder: (_) => SettingsPage()));
            break;
          case 'Sign Out':
            await AuthStorage.clear();
            // Navigator.pushAndRemoveUntil(
            //   context,
            //   MaterialPageRoute(builder: (_) => const LoginScreen()),
            //   (route) => false,
            // );
            break;
        }
      },
    );
  }
}
