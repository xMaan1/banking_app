import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../utils/app_colors.dart';
import '../utils/app_theme.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final bool hasBackButton;
  final List<Widget>? actions;
  final bool isTransparent;
  final double height;
  final Widget? leading;
  final Widget? titleWidget;
  final bool useLuxuryGradient;
  final bool showBorder;

  const CustomAppBar({
    Key? key,
    this.title,
    this.hasBackButton = true,
    this.actions,
    this.isTransparent = false,
    this.height = 56.0,
    this.leading,
    this.titleWidget,
    this.useLuxuryGradient = false,
    this.showBorder = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      automaticallyImplyLeading: false,
      leading: hasBackButton && leading == null
          ? IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
              splashRadius: 24,
              onPressed: () => Navigator.pop(context),
            )
          : leading,
      title: _buildTitle(),
      centerTitle: true,
      actions: actions != null 
          ? [...actions!].animate(interval: 50.ms).fade(duration: 300.ms).slideX(begin: 20, end: 0)
          : null,
      backgroundColor: isTransparent ? Colors.transparent : null,
      flexibleSpace: _buildBackground(),
      bottom: showBorder 
          ? PreferredSize(
              preferredSize: const Size.fromHeight(1),
              child: Container(
                height: 1,
                color: Colors.white.withOpacity(0.1),
              ),
            )
          : null,
    );
  }

  Widget? _buildTitle() {
    if (titleWidget != null) {
      return titleWidget!.animate().fade(duration: 300.ms).slideY(begin: -10, end: 0);
    }
    
    if (title != null) {
      return Text(
        title!,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
          fontFamily: 'Montserrat',
        ),
      ).animate().fade(duration: 300.ms).slideY(begin: -10, end: 0);
    }
    
    return Container();
  }

  Widget _buildBackground() {
    final gradientColors = useLuxuryGradient 
        ? AppColors.gradientLuxury
        : AppColors.gradientPrimary;
    
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: Stack(
        children: [
          // Subtle pattern overlay
          if (!isTransparent) 
            Opacity(
              opacity: 0.05,
              child: CustomPaint(
                size: Size.infinite,
                painter: AppBarPatternPainter(),
              ),
            ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}

// Custom painter for subtle pattern overlay
class AppBarPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;
    
    // Draw diagonal lines
    final spacing = 30.0;
    
    for (double i = 0; i < size.width + size.height; i += spacing) {
      canvas.drawLine(
        Offset(i < size.width ? i : 0, i < size.width ? 0 : i - size.width),
        Offset(
          i - size.height < 0 ? 0 : i - size.height,
          i < size.height ? i : size.height,
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(AppBarPatternPainter oldDelegate) => false;
} 