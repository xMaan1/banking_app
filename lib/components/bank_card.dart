import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../utils/app_colors.dart';
import '../utils/app_theme.dart';
import 'dart:math' as math;

class BankCard extends StatelessWidget {
  final String cardNumber;
  final String cardHolderName;
  final String expiryDate;
  final double balance;
  final String cardType;
  final bool isPremiumCard;
  final VoidCallback? onTap;

  const BankCard({
    Key? key,
    required this.cardNumber,
    required this.cardHolderName,
    required this.expiryDate,
    required this.balance,
    required this.cardType,
    this.isPremiumCard = false,
    this.onTap,
  }) : super(key: key);

  String get formattedCardNumber {
    if (cardNumber.length != 16) return cardNumber;
    return '${cardNumber.substring(0, 4)} ${cardNumber.substring(4, 8)} ${cardNumber.substring(8, 12)} ${cardNumber.substring(12, 16)}';
  }

  String get maskedCardNumber {
    if (cardNumber.length != 16) return cardNumber;
    return '**** **** **** ${cardNumber.substring(12, 16)}';
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double cardWidth = screenSize.width * 0.85 > 400 ? 400 : screenSize.width * 0.85;
    final double cardHeight = cardWidth * 0.6;
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: cardWidth,
        height: cardHeight,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: isPremiumCard 
                ? AppColors.primary.withOpacity(0.3)
                : Colors.black.withOpacity(0.2),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: Stack(
            children: [
              // Card Background
              Positioned.fill(
                child: _buildCardBackground(),
              ),
              
              // Card Pattern
              Positioned.fill(
                child: _buildCardPattern(),
              ),
              
              // Card Logo & Chip
              Positioned(
                top: 20,
                left: 20,
                right: 20,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Bank Logo
                    Container(
                      height: 40,
                      width: 60,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Center(
                        child: Text(
                          'BANK',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            letterSpacing: 1,
                            fontFamily: 'Montserrat',
                          ),
                        ),
                      ),
                    ),
                    
                    // Card Type Logo
                    _buildCardTypeLogo(),
                  ],
                ),
              ),
              
              // Card Chip
              Positioned(
                top: 70,
                left: 20,
                child: _buildCardChip(),
              ),
              
              // Card Number
              Positioned(
                top: 120,
                left: 20,
                right: 20,
                child: Text(
                  maskedCardNumber,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 2,
                    fontFamily: 'Montserrat',
                  ),
                ),
              ),
              
              // Card Details (Expiry & Holder Name)
              Positioned(
                bottom: 20,
                left: 20,
                right: 20,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Holder Info
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'CARD HOLDER',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 1,
                            fontFamily: 'Montserrat',
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          cardHolderName.toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1,
                            fontFamily: 'Montserrat',
                          ),
                        ),
                      ],
                    ),
                    
                    // Expiry Date
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'EXPIRES',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 1,
                            fontFamily: 'Montserrat',
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          expiryDate,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1,
                            fontFamily: 'Montserrat',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Balance Indicator
              Positioned(
                top: 16,
                right: isPremiumCard ? 90 : 16,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    '\$${balance.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Montserrat',
                    ),
                  ),
                ),
              ),
              
              // Premium Indicator
              if (isPremiumCard)
                Positioned(
                  top: 70,
                  right: 20,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.amber.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: Colors.amber,
                        width: 1.0,
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.star,
                          color: Colors.amber,
                          size: 12,
                        ),
                        const SizedBox(width: 4),
                        const Text(
                          'PREMIUM',
                          style: TextStyle(
                            color: Colors.amber,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                            fontFamily: 'Montserrat',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ).animate()
        .fadeIn(duration: 600.ms)
        .slide(begin: const Offset(0.1, 0), end: const Offset(0, 0), duration: 600.ms, curve: Curves.easeOutQuad),
    );
  }

  Widget _buildCardBackground() {
    if (isPremiumCard) {
      return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF1E1E1E),
              const Color(0xFF383838),
              const Color(0xFF1E1E1E),
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
      );
    }
    
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: cardType.toLowerCase().contains('visa')
              ? AppColors.gradientBlue
              : cardType.toLowerCase().contains('master')
                  ? AppColors.gradientOrange
                  : AppColors.gradientPrimary,
        ),
      ),
    );
  }

  Widget _buildCardPattern() {
    return CustomPaint(
      painter: CardPatternPainter(
        isPremium: isPremiumCard,
      ),
    );
  }
  
  Widget _buildCardTypeLogo() {
    if (cardType.toLowerCase().contains('visa')) {
      return Text(
        'VISA',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 22,
          letterSpacing: 1,
          fontFamily: isPremiumCard ? 'Montserrat' : null,
        ),
      );
    } else if (cardType.toLowerCase().contains('master')) {
      return Stack(
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.red,
            ),
          ),
          Transform.translate(
            offset: const Offset(12, 0),
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.amber.shade700,
              ),
            ),
          ),
        ],
      );
    } else {
      return Text(
        cardType.split(' ')[0].toUpperCase(),
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 18,
          letterSpacing: 1,
          fontFamily: 'Montserrat',
        ),
      );
    }
  }
  
  Widget _buildCardChip() {
    return Container(
      width: 40,
      height: 30,
      decoration: BoxDecoration(
        color: isPremiumCard ? Colors.amber.shade700 : Colors.amber,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            height: 2,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            color: Colors.grey.shade800,
          ),
          Container(
            height: 2,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            color: Colors.grey.shade800,
          ),
          Container(
            height: 2,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            color: Colors.grey.shade800,
          ),
        ],
      ),
    );
  }
}

class CardPatternPainter extends CustomPainter {
  final bool isPremium;
  
  CardPatternPainter({required this.isPremium});

  @override
  void paint(Canvas canvas, Size size) {
    final patternPaint = Paint()
      ..color = isPremium 
          ? Colors.grey.withOpacity(0.05) 
          : Colors.white.withOpacity(0.08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
      
    final double spacing = 30.0;
    
    if (isPremium) {
      // Draw premium geometric patterns
      for (int i = 0; i < size.width + size.height; i += 60) {
        canvas.drawLine(Offset(0, i.toDouble()), Offset(i.toDouble(), 0), patternPaint);
      }
      
      // Draw small circles
      final circlePaint = Paint()
        ..color = Colors.white.withOpacity(0.05)
        ..style = PaintingStyle.fill;
        
      for (int x = 0; x < size.width.toInt(); x += 30) {
        for (int y = 0; y < size.height.toInt(); y += 30) {
          if ((x + y) % 60 == 0) {
            canvas.drawCircle(Offset(x.toDouble(), y.toDouble()), 1.5, circlePaint);
          }
        }
      }
    } else {
      // Regular card pattern - curved lines
      Path path = Path();
      
      for (int i = -50; i < size.width + 50; i += 50) {
        path.moveTo(i.toDouble(), 0);
        path.quadraticBezierTo(
          (i + 100).toDouble(), size.height / 2, 
          i.toDouble(), size.height
        );
      }
      
      canvas.drawPath(path, patternPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
} 