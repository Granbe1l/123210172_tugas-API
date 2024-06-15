import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login.dart';

class ProfilePage extends StatelessWidget {
  Future<Map<String, String>> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('loggedInUser') ?? 'Unknown';
    final users = prefs.getStringList('users') ?? [];
    final user = users.firstWhere((user) => user.split('|')[0] == email, orElse: () => '');

    if (user.isNotEmpty) {
      final parts = user.split('|');
      return {
        'Nama': parts[2],
        'Email': parts[0],
        'Tanggal Lahir': parts[3]
      };
    }

    return {
      'Nama': 'Unknown',
      'Email': 'Unknown',
      'Tanggal Lahir': 'Unknown',
    };
  }

  void _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    await prefs.remove('loggedInUser');

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
          (route) => false,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Logout successful!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black12,
        title: Text('Profile', style: TextStyle(color: Colors.black)),
      ),
      body: Container(
        color: Color(0xFF222831), // Ubah warna background
        child: Center(
          child: FutureBuilder<Map<String, String>>(
            future: _loadUserData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasData) {
                final data = snapshot.data!;
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/logo.png',
                      width: 120,
                      height: 120,
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Nama: ${data['Nama']}',
                      style: TextStyle(color: Colors.white), // Ubah warna teks
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Email: ${data['Email']}',
                      style: TextStyle(color: Colors.white), // Ubah warna teks
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Tanggal Lahir: ${data['Tanggal Lahir']}',
                      style: TextStyle(color: Colors.white), // Ubah warna teks
                    ),
                    SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () => _logout(context),
                      child: Text('Logout', style: TextStyle(color: Colors.white)), // Ubah warna teks
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF222831)), // Ubah warna latar belakang
                        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                          EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                        ),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),

                  ],
                );
              } else {
                return Text('Error loading profile');
              }
            },
          ),
        ),
      ),
    );
  }



}
