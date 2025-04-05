import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class BankCard extends StatelessWidget {
  final String cardNumber;
  final String cardHolderName;
  final String expiryDate;
  final String cardType;
  final double balance;
  
  const BankCard({
    Key? key,
    required this.cardNumber,
    required this.cardHolderName,
    required this.expiryDate,
    required this.cardType,
    required this.balance,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Card width is fixed to maximize readability
        final cardWidth = constraints.maxWidth > 350 ? 350.0 : constraints.maxWidth;
        
        return Container(
          width: cardWidth,
          height: 200,
          margin: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.primary, AppColors.primaryDark],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCardHeader(cardType),
              const Spacer(),
              _buildCardNumber(cardNumber),
              const Spacer(),
              _buildCardDetails(cardHolderName, expiryDate),
              const SizedBox(height: 12),
              _buildCardBalance(balance),
            ],
          ),
        );
      },
    );
  }
  
  Widget _buildCardHeader(String cardType) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Flexible(
          child: Text(
            'Owner Bank',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            cardType,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
  
  Widget _buildCardNumber(String number) {
    return Text(
      _formatCardNumber(number),
      style: const TextStyle(
        color: Colors.white,
        fontSize: 16,
        letterSpacing: 2,
      ),
      overflow: TextOverflow.ellipsis,
    );
  }
  
  Widget _buildCardDetails(String holderName, String expiry) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'CARD HOLDER',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 10,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                holderName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Flexible(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'EXPIRES',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 10,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                expiry,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
  
  Widget _buildCardBalance(double amount) {
    return Text(
      '\$${amount.toStringAsFixed(2)}',
      style: const TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      overflow: TextOverflow.ellipsis,
    );
  }

  String _formatCardNumber(String number) {
    final formatted = <String>[];
    for (int i = 0; i < number.length; i += 4) {
      final end = i + 4 < number.length ? i + 4 : number.length;
      formatted.add(number.substring(i, end));
    }
    return formatted.join(' ');
  }
} 