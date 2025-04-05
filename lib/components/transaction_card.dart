import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

enum TransactionType { deposit, withdrawal, transfer }

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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            _buildIcon(),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    date,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  if (description != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      description!,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            Text(
              _getAmountWithSign(),
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: _getAmountColor(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon() {
    IconData iconData;
    Color backgroundColor;

    switch (type) {
      case TransactionType.deposit:
        iconData = Icons.arrow_downward;
        backgroundColor = AppColors.success.withOpacity(0.1);
        break;
      case TransactionType.withdrawal:
        iconData = Icons.arrow_upward;
        backgroundColor = AppColors.error.withOpacity(0.1);
        break;
      case TransactionType.transfer:
        iconData = Icons.swap_horiz;
        backgroundColor = AppColors.info.withOpacity(0.1);
        break;
    }

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        iconData,
        color: _getAmountColor(),
        size: 24,
      ),
    );
  }

  String _getAmountWithSign() {
    switch (type) {
      case TransactionType.deposit:
        return '+\$$amount';
      case TransactionType.withdrawal:
        return '-\$$amount';
      case TransactionType.transfer:
        return '\$$amount';
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
} 