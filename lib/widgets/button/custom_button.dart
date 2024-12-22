import 'package:flutter/material.dart';

class CustomSolidButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool isLoading; // New parameter to indicate loading state
  final Color buttonColor; // Parameter to choose button color
  final Color textColor; // Parameter to choose text color

  const CustomSolidButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false, // Default to not loading
    this.buttonColor = const Color(0xFF3c8800), // Default button color
    this.textColor = Colors.white, // Default text color
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: buttonColor, // Use the button color
      ),
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: buttonColor, // Set the background color
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        onPressed: isLoading ? null : onPressed, // Disable button if loading
        child: isLoading
            ? const Center(
                child: SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white, // Progress indicator color
                    strokeWidth: 2, // Adjust thickness if needed
                  ),
                ),
              )
            : Text(
                label,
                style: TextStyle(
                  color: textColor, // Use the specified text color
                  fontSize: 16, // Optional: Adjust the font size
                ),
              ),
      ),
    );
  }
}
