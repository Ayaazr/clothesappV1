import 'dart:io';
import 'package:clothes_app/widgets/button/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:toastification/toastification.dart';

import '../provider/auth_provider.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  File? _profileImage;
  bool _isLoading = false; // Loading state for button
  final Toastification toastification = Toastification();

  @override
  void initState() {
    super.initState();
    final user = Provider.of<AuthProvider>(context, listen: false).user;
    if (user != null) {
      _nameController.text = user.displayName ?? '';
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
        source: ImageSource.gallery); // Can change to .camera for camera
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  void _saveProfile() async {
    setState(() {
      _isLoading = true;
    });

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final user = authProvider.user;

    if (user != null) {
      try {
        // If there's a new profile image, upload it
        if (_profileImage != null) {
          await authProvider.updateProfilePicture(user.uid, _profileImage!);
        }

        // Update user name
        await _saveUserData(authProvider);

        // Show success toast
        _showSuccessToast(authProvider.user!.displayName);
      } catch (e) {
        // Show error toast if anything goes wrong
        _showErrorToast('Failed to update profile');
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _saveUserData(AuthProvider authProvider) async {
    final user = authProvider.user;
    await authProvider.updateUser(user!.uid, displayName: _nameController.text);
  }

  void _showSuccessToast(String message) {
    toastification.show(
      type: ToastificationType.success,
      title: const Text('Profile Updated Successfully'),
      description: Text(message),
      primaryColor: Colors.green,
      backgroundColor: Colors.green,
      foregroundColor: Colors.white,
      style: ToastificationStyle.fillColored,
      autoCloseDuration: const Duration(milliseconds: 5000),
      showProgressBar: true,
    );
  }

  void _showErrorToast(String message) {
    toastification.show(
      type: ToastificationType.error,
      title: const Text('Profile Update Failed'),
      description: Text(message),
      backgroundColor: Colors.red,
      foregroundColor: Colors.white,
      style: ToastificationStyle.fillColored,
      autoCloseDuration: const Duration(milliseconds: 5000),
      showProgressBar: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xFF00396f),
        title: Text(
          "Edit Profile",
          style: GoogleFonts.poppins(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            _buildProfileBox(),
            const SizedBox(height: 20),
            _buildEditField("Name", _nameController),
            const SizedBox(height: 30),
            CustomSolidButton(
              label: 'Save Profile',
              onPressed: _saveProfile, // Disable button while loading
              isLoading: _isLoading,
              buttonColor: const Color(0xFF00396f),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileBox() {
    final user = Provider.of<AuthProvider>(context).user;
    return Container(
      height: 90,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: const Color(0xFF00396f),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: _pickImage,
            child: Container(
              padding: const EdgeInsets.only(left: 9),
              width: 60,
              child: CircleAvatar(
                radius: 30,
                backgroundImage: _profileImage != null
                    ? FileImage(_profileImage!)
                    : const AssetImage('assets/profile_picture.png') as ImageProvider,
              ),
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
                    user?.displayName ?? "Loading...",
                    style:
                        GoogleFonts.poppins(color: Colors.white, fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () {},
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

  Widget _buildEditField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.poppins(color: Colors.grey[700], fontSize: 14),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF00396f)),
        ),
      ),
    );
  }
}
