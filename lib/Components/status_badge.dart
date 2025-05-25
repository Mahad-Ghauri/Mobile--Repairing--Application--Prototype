import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StatusBadge extends StatelessWidget {
  final String text;
  final Color color;
  final double fontSize;

  const StatusBadge({
    Key? key,
    required this.text,
    required this.color,
    this.fontSize = 14.0,
  }) : super(key: key);

  factory StatusBadge.inProgress({double fontSize = 14.0}) {
    return StatusBadge(
      text: 'In Progress',
      color: Colors.blue,
      fontSize: fontSize,
    );
  }

  factory StatusBadge.completed({double fontSize = 14.0}) {
    return StatusBadge(
      text: 'Completed',
      color: Colors.green,
      fontSize: fontSize,
    );
  }

  factory StatusBadge.pending({double fontSize = 14.0}) {
    return StatusBadge(
      text: 'Pending',
      color: Colors.orange,
      fontSize: fontSize,
    );
  }

  factory StatusBadge.cancelled({double fontSize = 14.0}) {
    return StatusBadge(
      text: 'Cancelled',
      color: Colors.red,
      fontSize: fontSize,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Text(
        text,
        style: GoogleFonts.poppins(
          color: color,
          fontWeight: FontWeight.w500,
          fontSize: fontSize,
        ),
      ),
    );
  }
}