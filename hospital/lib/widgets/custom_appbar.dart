import 'package:flutter/material.dart';
import 'package:hospital/screens/about_us_page.dart';
import 'package:hospital/screens/add_data_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Function to handle logout
Future<void> _logout(BuildContext context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove('isLoggedIn'); // Clear login state

  // Navigate to the Sign-In screen
  Navigator.of(context).pushNamedAndRemoveUntil(
    '/signin', // Make sure this matches your sign-in page route
    (Route<dynamic> route) => false, // Removes all previous routes
  );

  // Optionally, show a logout success message
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text('Logged out successfully')),
  );
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text(
        'Chemo Drug Dilution',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: Colors.green,
      actions: [
        PopupMenuButton<String>(
          onSelected: (String result) {
            switch (result) {
              case 'Add Data':
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const AddDataPage()), // Navigate to AddDataPage
                );
                break;
              case 'Logout':
                _logout(context); // Call the logout function
                break;
              case 'About Us':
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const AboutUsPage()), // Navigate to AboutUsPage
                );
                break;
            }
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
            const PopupMenuItem<String>(
              value: 'Add Data',
              child: ListTile(
                leading: Icon(Icons.add, color: Colors.blueAccent),
                title: Text('Add Data'),
              ),
            ),
            const PopupMenuItem<String>(
              value: 'Logout',
              child: ListTile(
                leading: Icon(Icons.logout, color: Colors.redAccent),
                title: Text('Logout'),
              ),
            ),
            const PopupMenuItem<String>(
              value: 'About Us',
              child: ListTile(
                leading: Icon(Icons.info, color: Colors.green),
                title: Text('About Us'),
              ),
            ),
          ],
          icon: const Icon(
            Icons.menu,
            color: Colors.white,
          ),
          color: Colors.white,
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
