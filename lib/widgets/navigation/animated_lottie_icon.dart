import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class AnimatedLottieIcon extends StatefulWidget {
  final String assetPath;
  final bool isSelected;
  final double size;
  final Color? color;

  const AnimatedLottieIcon({
    super.key,
    required this.assetPath,
    required this.isSelected,
    this.size = 28,
    this.color,
  });

  @override
  State<AnimatedLottieIcon> createState() => _AnimatedLottieIconState();
}

class _AnimatedLottieIconState extends State<AnimatedLottieIcon> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,

      child: Lottie.asset(
        widget.assetPath,
        repeat: false, // Selected hone par ek baar chale
        animate: widget.isSelected, // Selected hone par hi start ho
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return Icon(
            Icons.animation_rounded,
            size: widget.size,
            color: widget.color?.withValues(alpha: 0.5) ?? Colors.grey.withValues(alpha: 0.5),
          );
        },
      ),
    );
  }
}
