import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final bool hasBackButton;
  final List<Widget>? actions;
  final bool isTransparent;
  final double height;
  final Widget? leading;
  final Widget? titleWidget;

  const CustomAppBar({
    Key? key,
    this.title,
    this.hasBackButton = true,
    this.actions,
    this.isTransparent = false,
    this.height = 56.0,
    this.leading,
    this.titleWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: isTransparent ? 0 : 2,
      automaticallyImplyLeading: false,
      leading: hasBackButton && leading == null
          ? IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            )
          : leading,
      title: titleWidget ??
          (title != null
              ? Text(
                  title!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                )
              : null),
      actions: actions,
      backgroundColor: isTransparent ? Colors.transparent : null,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: AppColors.gradientPrimary,
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
} 