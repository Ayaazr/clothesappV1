import 'package:clothes_app/models/models.dart';
import 'package:clothes_app/provider/auth_provider.dart';
import 'package:clothes_app/screens/edit_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isActive = true;

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        UserModel? user = authProvider.user; // Get current user

        // If no user is logged in, show a message
        if (user == null) {
     
          return const Scaffold(
            body: Center(
              child: Text('Please log in'),
            ),
          );
        }

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              children: [
                _buildProfileBox(
                    user, context), // Pass user data to the profile box
                const SizedBox(height: 20),
                const SizedBox(height: 10),

                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: Text(
                    "More Options",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                ),

                // Logout section with confirmation dialog
                BoxedSection(
                  icon: LucideIcons.logOut,
                  title: 'Logout',
                  subTitle: 'Sign out of your account',
                  onPress: () async {
                    // Show confirmation dialog before logging out
                    bool? shouldLogout = await _showLogoutDialog(context);
                    if (shouldLogout == true) {
                      authProvider.signOut(context);
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Method to show logout confirmation dialog
  Future<bool?> _showLogoutDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to log out?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }
}

Widget _buildProfileBox(UserModel user, BuildContext context) {
  return Container(
    height: 90,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      color: const Color(0xFF00396f),
    ),
    child: Row(
      children: [
        Container(
          padding: const EdgeInsets.only(left: 9),
          width: 60,
          child: CircleAvatar(
            radius: 30,
            backgroundImage: user.profilePicture != null
                ? NetworkImage(
                    user.profilePicture!) // If profile picture URL exists
                : const AssetImage('assets/profile_picture.png')
                    as ImageProvider, // Placeholder
          ),
        ),
        Container(
          width: 150,
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 9),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.displayName ?? 'No name', // Display user's name
                  style: GoogleFonts.poppins(color: Colors.white, fontSize: 14),
                ),
                Text(
                  user.email ?? 'No email', // Display user's email
                  style: GoogleFonts.poppins(color: Colors.white, fontSize: 14),
                ),
              ],
            ),
          ),
        ),
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const EditProfileScreen()),
            );
          },
          child: Container(
            width: 130,
            alignment: Alignment.centerRight,
            child: const Icon(
              LucideIcons.pencil,
              color: Colors.white,
            ),
          ),
        ),
      ],
    ),
  );
}

class BoxedSection extends StatelessWidget {
  final String title;
  final String subTitle;
  final IconData icon;
  final VoidCallback onPress;

  const BoxedSection({
    super.key,
    required this.title,
    required this.subTitle,
    required this.onPress,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPress,
      borderRadius: BorderRadius.circular(12),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  spreadRadius: 2,
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                CircleAvatar(
                    backgroundColor: const Color(0xFF00396f),
                    child: Center(
                        child: Icon(icon,
                            color: const Color(0xFF03DAC5), size: 25))),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.poppins(
                          fontSize: constraints.maxWidth < 600
                              ? 16
                              : 18, // Larger text for desktop/web
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subTitle,
                        style: GoogleFonts.poppins(
                          fontSize: constraints.maxWidth < 600
                              ? 14
                              : 16, // Larger text for desktop/web
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 18,
                  color: Colors.grey[400],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
