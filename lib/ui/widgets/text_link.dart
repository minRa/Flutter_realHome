import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextLink extends StatelessWidget {
  final String text;
  final Function onPressed;
  const TextLink(this.text, {this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Text(
        text,
        style: GoogleFonts.mcLaren(fontWeight: FontWeight.w700, fontSize: 14)
      ),
    );
  }
}
