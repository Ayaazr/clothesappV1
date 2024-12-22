import 'package:clothes_app/models/models.dart';
import 'package:clothes_app/provider/auth_provider.dart';
import 'package:clothes_app/screens/register_screen.dart';
import 'package:clothes_app/widgets/button/custom_button.dart';
import 'package:clothes_app/widgets/common/squelleton.dart';
import 'package:clothes_app/widgets/input/custom_input.dart';
import 'package:clothes_app/widgets/squelleton.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoading = false;
  int _selectedIndex = 0;
  final AuthProvider _authService = AuthProvider();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  final Toastification toastification = Toastification();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isTablet = screenWidth > 600;

    final double padding = screenWidth * 0.05;
    final double logoSize = screenWidth * 0.4;
    final double textSize = isTablet ? 20 : 16;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: padding),
          child: Padding(
            padding: EdgeInsets.only(top: screenHeight * 0.1),
            child: Column(
              children: [
                _buildLogo(logoSize),
                const SizedBox(height: 30),
                _buildHeaderText(textSize),
                const SizedBox(height: 30),
                const SizedBox(height: 40),
                _buildAdminLogin(),
                const SizedBox(height: 20),
                _buildRegisterPrompt(),
                const SizedBox(height: 10),
                _buildRegisterButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo(double logoSize) {
    return SizedBox(
      width: logoSize,
      child: AspectRatio(
        aspectRatio: 1,
        child: Image.asset(
          'assets/images/clotheslogo.jpg',
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildHeaderText(double textSize) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Connexion au Compte",
            style: GoogleFonts.poppins(fontSize: textSize),
          ),
          const SizedBox(height: 10),
          Text(
            "Bonjour, bienvenue de nouveau sur votre compte",
            style: GoogleFonts.poppins(fontSize: textSize),
          ),
        ],
      ),
    );
  }

  Widget _buildAdminLogin() {
    return Column(
      children: [
        CustomTextField(
          labelText: 'Email Administrateur',
          controller: _emailController,
          prefixIcon: const Icon(LucideIcons.user),
          obscureText: false,
        ),
        const SizedBox(height: 16),
        CustomTextField(
          labelText: 'Mot de passe Administrateur',
          controller: _passwordController,
          obscureText: true,
          prefixIcon: const Icon(LucideIcons.lock),
        ),
        const SizedBox(height: 16),
        CustomSolidButton(
          label: 'Connexion',
          onPressed: _handleAdminLogin,
          isLoading: _isLoading,
          buttonColor: const Color(0xFF00396f),
        ),
        const SizedBox(
          height: 15,
        ),
      ],
    );
  }

  Widget _buildUserLogin() {
    return Column(
      children: [
        CustomTextField(
          labelText: 'Code Utilisateur',
          controller: _codeController,
          prefixIcon: const Icon(LucideIcons.key),
          obscureText: false,
        ),
        const SizedBox(height: 16),
        CustomSolidButton(
          label: 'Connexion',
          onPressed: _handleUserLogin,
          isLoading: _isLoading,
          buttonColor: const Color(0xFF00396f),
        ),
        // Do not show the forgot password button for normal users
      ],
    );
  }

  void _handleAdminLogin() async {
    final authProvider = Provider.of<AuthProvider>(context,
        listen: false); // listen: false to avoid rebuild

    setState(() {
      _isLoading = true;
    });

    try {
      UserModel? user = await authProvider.signInWithEmail(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      _showSuccessToast("Bienvenue, ${user?.email}");
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) =>  Squelleton()),
      );
    } catch (e) {
      _showErrorToast('Une erreur est survenue.');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _handleUserLogin() async {
    final authProvider = Provider.of<AuthProvider>(context,
        listen: false); // listen: false to avoid rebuild

    setState(() {
      _isLoading = true;
    });

    try {
      UserModel? user = await authProvider.signInWithCode(
        _codeController.text.trim(),
      );

      _showSuccessToast("Bienvenue, ${user?.email}");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Squelleton()),
      );
    } catch (e) {
      _showErrorToast('Une erreur est survenue.');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showSuccessToast(String message) {
    toastification.show(
      type: ToastificationType.success,
      title: const Text('Connexion réussie!'),
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
      title: const Text('Erreur!'),
      description: Text(message),
      backgroundColor: Colors.red,
      foregroundColor: Colors.white,
      style: ToastificationStyle.fillColored,
      autoCloseDuration: const Duration(milliseconds: 5000),
      showProgressBar: true,
    );
  }

  Widget _buildRegisterButton() {
    return CustomSolidButton(
      label: "S'inscrire",
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const RegisterScreen()),
        );
      },
      buttonColor:  Colors.orange,
    );
  }

  Widget _buildRegisterPrompt() {
    return Text(
      "T'es pas encore enregistré ?",
      style: GoogleFonts.poppins(color: Colors.grey),
    );
  }
}
