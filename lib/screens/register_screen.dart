
import 'package:clothes_app/models/models.dart';
import 'package:clothes_app/screens/login_screen.dart';
import 'package:clothes_app/services/auth_services.dart';
import 'package:clothes_app/widgets/input/custom_input.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:toastification/toastification.dart';

import '../widgets/button/custom_button.dart'; // Import the LoginScreen

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  AuthService authService = AuthService();
 final Toastification toastification = Toastification();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _postalCodeController = TextEditingController();
  final TextEditingController _birthdayController = TextEditingController();


  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
     _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _cityController.dispose();
    _addressController.dispose();
    _postalCodeController.dispose();
    _birthdayController.dispose();
    super.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      UserModel? user = await authService.signUp(
        _emailController.text.trim(),
        _passwordController.text.trim(),
        _usernameController.text.trim(),
     
        _cityController.text.trim(),
        _addressController.text.trim(),
        int.tryParse(_postalCodeController.text.trim()) ?? 0,
        _birthdayController.text.trim(),
      );

      setState(() {
        _isLoading = false;
      });

      if (user != null) {
        // Success notification
        toastification.show(
          type: ToastificationType.success,
          title: const Text('Inscription réussie!'),
          description: RichText(
            text: TextSpan(text: 'Bienvenue, ${user.email}.'),
          ),
          primaryColor: Colors.green,
          backgroundColor: Colors.green,
          foregroundColor: const Color.fromARGB(255, 255, 255, 255),
          style: ToastificationStyle.fillColored,
          autoCloseDuration: const Duration(milliseconds: 5000),
          showProgressBar: true,
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      } else {
        // Failure notification
        toastification.show(
          type: ToastificationType.error,
          title: const Text('Échec de l\'inscription!'),
          description: RichText(
            text: const TextSpan(text: 'Veuillez réessayer.'),
          ),
          primaryColor: Colors.red,
          backgroundColor: Colors.red,
          foregroundColor: const Color.fromARGB(255, 255, 255, 255),
          style: ToastificationStyle.fillColored,
          autoCloseDuration: const Duration(milliseconds: 5000),
          showProgressBar: false,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white,scrolledUnderElevation: 0,),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _buildLogo(),
                const SizedBox(height: 30),
                _buildHeaderText(),
                const SizedBox(height: 30),
                _buildRegistrationForm(),
                const SizedBox(height: 10),
                _buildLoginPrompt(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Image.asset(
      'assets/images/clotheslogo.jpg',
      height: 170,
      width: 170,
      fit: BoxFit.cover,
    );
  }

  Widget _buildHeaderText() {
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Créer un Compte",
            style: GoogleFonts.poppins(),
          ),
          const SizedBox(height: 10),
          Text(
            "Bienvenue, veuillez remplir les informations ci-dessous",
            style: GoogleFonts.poppins(),
          ),
        ],
      ),
    );
  }

  Widget _buildRegistrationForm() {
    return Container(
      constraints: const BoxConstraints(maxWidth: 400),
      child: Column(
        children: [
          CustomTextField(
            labelText: 'Nom d’utilisateur',
            controller: _usernameController,
            prefixIcon: const Icon(Icons.person),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Veuillez entrer un nom d’utilisateur';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          CustomTextField(
            labelText: 'Email',
            controller: _emailController,
            prefixIcon: const Icon(Icons.email),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Veuillez entrer votre email';
              }
              if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                return 'Veuillez entrer un email valide';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          CustomTextField(
            labelText: 'Mot de passe',
            controller: _passwordController,
            obscureText: true,
            prefixIcon: const Icon(Icons.lock),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Veuillez entrer un mot de passe';
              }
              if (value.length < 6) {
                return 'Le mot de passe doit contenir au moins 6 caractères';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          CustomTextField(
            labelText: 'Confirmer le mot de passe',
            controller: _confirmPasswordController,
            obscureText: true,
            prefixIcon: const Icon(Icons.lock),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Veuillez confirmer votre mot de passe';
              }
              if (value != _passwordController.text) {
                return 'Les mots de passe ne correspondent pas';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          CustomTextField(
            labelText: 'Ville',
            controller: _cityController,
            prefixIcon: const Icon(Icons.location_city),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Veuillez entrer votre ville';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          CustomTextField(
            labelText: 'Adresse',
            controller: _addressController,
            prefixIcon: const Icon(Icons.home),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Veuillez entrer votre adresse';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          CustomTextField(
            labelText: 'Code postal',
            controller: _postalCodeController,
            prefixIcon: const Icon(Icons.local_post_office),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Veuillez entrer votre code postal';
              }
              if (int.tryParse(value) == null) {
                return 'Veuillez entrer un code postal valide';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          CustomTextField(
            labelText: 'Date de naissance',
            controller: _birthdayController,
            prefixIcon: const Icon(Icons.cake),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Veuillez entrer votre date de naissance';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          CustomSolidButton(
            label: 'S’inscrire',
            onPressed: _register,
            isLoading: _isLoading,
            buttonColor: const Color(0xFF00396f),
          ),
        ],
      ),
    );
  }
  Widget _buildLoginPrompt() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Déjà un compte ?",
          style: GoogleFonts.poppins(color: Colors.grey),
        ),
        TextButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LoginScreen()),
            );
          },
          child: Text(
            "Se connecter",
            style: GoogleFonts.poppins(color:Colors.orange),
          ),
        ),
      ],
    );
  }
}
