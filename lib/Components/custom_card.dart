import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final Widget child;
  final Color? backgroundColor;
  final EdgeInsetsGeometry? padding;
  final double borderRadius;
  final VoidCallback? onTap;
  final double elevation;
  final Gradient? gradient;

  const CustomCard({
    Key? key,
    required this.child,
    this.backgroundColor,
    this.padding,
    this.borderRadius = 16.0,
    this.onTap,
    this.elevation = 4.0,
    this.gradient,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: elevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(borderRadius),
        child: Container(
          padding: padding ?? const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
            color: gradient == null ? backgroundColor : null,
            gradient: gradient,
          ),
          child: child,
        ),
      ),
    );
  }
}