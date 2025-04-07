import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../utils/app_colors.dart';
import '../utils/app_theme.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final String? labelText;
  final bool obscureText;
  final TextInputType keyboardType;
  final FormFieldValidator<String>? validator;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixIconPressed;
  final bool isEnabled;
  final FocusNode? focusNode;
  final bool autofocus;
  final String? initialValue;
  final bool isDense;
  final bool hasBorder;
  final Color? backgroundColor;

  const CustomTextField({
    Key? key,
    required this.controller,
    required this.hintText,
    this.labelText,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixIconPressed,
    this.isEnabled = true,
    this.focusNode,
    this.autofocus = false,
    this.initialValue,
    this.isDense = false,
    this.hasBorder = false,
    this.backgroundColor,
  }) : super(key: key);

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_handleFocusChange);
    
    if (widget.initialValue != null && widget.controller.text.isEmpty) {
      widget.controller.text = widget.initialValue!;
    }
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.removeListener(_handleFocusChange);
      _focusNode.dispose();
    }
    super.dispose();
  }

  void _handleFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.labelText != null) ...[
          Text(
            widget.labelText!,
            style: TextStyle(
              color: _isFocused 
                  ? AppColors.primary 
                  : AppColors.textSecondary,
              fontSize: 14,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.2,
              fontFamily: 'Montserrat',
            ),
          ).animate(target: _isFocused ? 1 : 0)
            .color(
              begin: AppColors.textSecondary, 
              end: AppColors.primary,
              duration: 200.ms
            ),
          const SizedBox(height: 8),
        ],
        Container(
          decoration: BoxDecoration(
            color: widget.backgroundColor ?? AppColors.backgroundDark,
            borderRadius: BorderRadius.circular(12),
            boxShadow: _isFocused ? [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ] : null,
            border: widget.hasBorder ? Border.all(
              color: _isFocused 
                  ? AppColors.primary 
                  : AppColors.neutral300,
              width: 1.0,
            ) : null,
          ),
          child: TextFormField(
            controller: widget.controller,
            obscureText: widget.obscureText,
            keyboardType: widget.keyboardType,
            enabled: widget.isEnabled,
            validator: widget.validator,
            focusNode: _focusNode,
            autofocus: widget.autofocus,
            style: const TextStyle(
              fontSize: 16.0,
              color: AppColors.textPrimary,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w400,
              letterSpacing: 0.15,
            ),
            decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle: const TextStyle(
                fontSize: 16.0,
                color: AppColors.textSecondary,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w400,
              ),
              prefixIcon: widget.prefixIcon != null
                  ? Icon(
                      widget.prefixIcon,
                      color: _isFocused ? AppColors.primary : AppColors.neutral700,
                      size: 20.0,
                    )
                  : null,
              suffixIcon: widget.suffixIcon != null
                  ? IconButton(
                      icon: Icon(
                        widget.suffixIcon,
                        color: _isFocused ? AppColors.primary : AppColors.neutral700,
                        size: 20.0,
                      ),
                      onPressed: widget.onSuffixIconPressed,
                      splashRadius: 20.0,
                    )
                  : null,
              filled: true,
              fillColor: Colors.transparent,
              contentPadding: EdgeInsets.symmetric(
                vertical: widget.isDense ? 12.0 : 16.0, 
                horizontal: widget.isDense ? 16.0 : 20.0,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide.none,
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: widget.hasBorder 
                    ? const BorderSide(color: AppColors.error, width: 1.0) 
                    : BorderSide.none,
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: widget.hasBorder 
                    ? const BorderSide(color: AppColors.error, width: 1.0) 
                    : BorderSide.none,
              ),
              errorStyle: const TextStyle(
                color: AppColors.error,
                fontSize: 12.0,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }
} 