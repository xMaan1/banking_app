import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/app_theme.dart';

class CustomButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final double width;
  final Color backgroundColor;
  final Color textColor;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final bool outlined;
  final IconData? icon;
  final bool elevated;
  
  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.width = double.infinity,
    this.backgroundColor = AppColors.primary,
    this.textColor = Colors.white,
    this.padding = const EdgeInsets.symmetric(vertical: 16),
    this.borderRadius = 12.0,
    this.outlined = false,
    this.icon,
    this.elevated = true,
  }) : super(key: key);

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.98).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        if (widget.onPressed != null && !widget.isLoading) {
          _animationController.forward();
          setState(() => _isPressed = true);
        }
      },
      onTapUp: (_) {
        _animationController.reverse();
        setState(() => _isPressed = false);
        if (widget.onPressed != null && !widget.isLoading) {
          widget.onPressed!();
        }
      },
      onTapCancel: () {
        _animationController.reverse();
        setState(() => _isPressed = false);
      },
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: child,
          );
        },
        child: SizedBox(
          width: widget.width,
          child: _buildButtonContent(),
        ),
      ),
    );
  }

  Widget _buildButtonContent() {
    // If it's an outlined button
    if (widget.outlined) {
      return _buildOutlinedButton();
    } 
    
    // For filled button
    return _buildFilledButton();
  }

  Widget _buildFilledButton() {
    final bgColor = widget.onPressed == null
        ? widget.backgroundColor.withOpacity(0.6)
        : widget.backgroundColor;
    
    return Container(
      padding: widget.padding,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(widget.borderRadius),
        boxShadow: widget.elevated && widget.onPressed != null
            ? [
                BoxShadow(
                  color: widget.backgroundColor.withOpacity(0.4),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                  spreadRadius: -2,
                ),
              ]
            : null,
      ),
      child: _buildButtonInner(),
    );
  }

  Widget _buildOutlinedButton() {
    return Container(
      padding: widget.padding,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(widget.borderRadius),
        border: Border.all(
          color: widget.onPressed == null
              ? widget.backgroundColor.withOpacity(0.6)
              : widget.backgroundColor,
          width: 1.5,
        ),
      ),
      child: _buildButtonInner(),
    );
  }

  Widget _buildButtonInner() {
    final textWidget = Text(
      widget.text,
      style: TextStyle(
        color: widget.onPressed == null
            ? widget.textColor.withOpacity(0.6)
            : widget.textColor,
        fontSize: 16,
        fontWeight: FontWeight.w600,
        letterSpacing: 1.0,
        fontFamily: 'Montserrat',
      ),
      textAlign: TextAlign.center,
    );

    if (widget.isLoading) {
      return Center(
        child: SizedBox(
          height: 24,
          width: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2.5,
            valueColor: AlwaysStoppedAnimation<Color>(widget.textColor),
          ),
        ),
      );
    }

    if (widget.icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            widget.icon,
            color: widget.onPressed == null
                ? widget.textColor.withOpacity(0.6)
                : widget.textColor,
            size: 20,
          ),
          const SizedBox(width: 10),
          textWidget,
        ],
      );
    }

    return textWidget;
  }
} 