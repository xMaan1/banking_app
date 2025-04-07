import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../utils/app_colors.dart';

enum TransactionType {
  deposit,
  withdrawal,
  transfer
}

class TransactionCard extends StatelessWidget {
  final String title;
  final String date;
  final String amount;
  final TransactionType type;
  final String? description;
  final VoidCallback? onTap;

  const TransactionCard({
    Key? key,
    required this.title,
    required this.date,
    required this.amount,
    required this.type,
    this.description,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowLight,
              offset: const Offset(0, 2),
              blurRadius: 6,
            ),
          ],
        ),
        child: Row(
          children: [
            // Transaction Icon
            _buildTransactionIcon(),
            const SizedBox(width: 12),
            
            // Transaction Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: AppColors.textPrimary,
                      fontFamily: 'Montserrat',
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Text(
                        date,
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.textSecondary,
                          fontFamily: 'Montserrat',
                        ),
                      ),
                      if (description != null && description!.isNotEmpty) ...[
                        const SizedBox(width: 6),
                        Container(
                          width: 3,
                          height: 3,
                          decoration: const BoxDecoration(
                            color: AppColors.textSecondary,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            description!,
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.textSecondary,
                              fontFamily: 'Montserrat',
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            
            // Amount
            Container(
              margin: const EdgeInsets.only(left: 8),
              child: Text(
                _getAmountPrefix() + amount,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: _getAmountColor(),
                  fontFamily: 'Montserrat',
                ),
              ),
            ),
          ],
        ),
      ),
    ).animate()
      .fadeIn(duration: 300.ms)
      .slideX(begin: 0.05, end: 0, duration: 300.ms, curve: Curves.easeOutQuad);
  }

  Widget _buildTransactionIcon() {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: _getIconBackgroundColor(),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(
        _getTransactionIcon(),
        color: _getIconColor(),
        size: 18,
      ),
    );
  }

  Color _getIconBackgroundColor() {
    switch (type) {
      case TransactionType.deposit:
        return AppColors.success.withOpacity(0.1);
      case TransactionType.withdrawal:
        return AppColors.error.withOpacity(0.1);
      case TransactionType.transfer:
        return AppColors.info.withOpacity(0.1);
    }
  }

  Color _getIconColor() {
    switch (type) {
      case TransactionType.deposit:
        return AppColors.success;
      case TransactionType.withdrawal:
        return AppColors.error;
      case TransactionType.transfer:
        return AppColors.info;
    }
  }

  IconData _getTransactionIcon() {
    switch (type) {
      case TransactionType.deposit:
        return Icons.arrow_downward;
      case TransactionType.withdrawal:
        return Icons.arrow_upward;
      case TransactionType.transfer:
        return Icons.swap_horiz;
    }
  }

  Color _getAmountColor() {
    switch (type) {
      case TransactionType.deposit:
        return AppColors.success;
      case TransactionType.withdrawal:
        return AppColors.error;
      case TransactionType.transfer:
        return AppColors.info;
    }
  }

  String _getAmountPrefix() {
    switch (type) {
      case TransactionType.deposit:
        return '+\$';
      case TransactionType.withdrawal:
        return '-\$';
      case TransactionType.transfer:
        return '\$';
    }
  }
} 