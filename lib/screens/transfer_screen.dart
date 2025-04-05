import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/app_colors.dart';
import '../components/custom_app_bar.dart';
import '../components/custom_button.dart';
import '../components/custom_text_field.dart';

class TransferScreen extends StatefulWidget {
  const TransferScreen({Key? key}) : super(key: key);

  @override
  _TransferScreenState createState() => _TransferScreenState();
}

class _TransferScreenState extends State<TransferScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _recipientController = TextEditingController();
  final _accountNumberController = TextEditingController();
  final _descriptionController = TextEditingController();

  String _selectedSourceAccount = 'Primary Checking (****4242)';
  final List<String> _accounts = [
    'Primary Checking (****4242)',
    'Savings Account (****5353)',
    'Investment Account (****7890)',
  ];

  bool _isTransferring = false;

  @override
  void dispose() {
    _amountController.dispose();
    _recipientController.dispose();
    _accountNumberController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submitTransfer() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isTransferring = true;
      });

      // Simulate network delay
      await Future.delayed(const Duration(seconds: 2));

      setState(() {
        _isTransferring = false;
      });

      _showTransferConfirmation();
    }
  }

  void _showTransferConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Transfer Successful'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.check_circle,
              color: AppColors.success,
              size: 64,
            ),
            const SizedBox(height: 16),
            Text(
              'Successfully transferred \$${_amountController.text} to ${_recipientController.text}',
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          CustomButton(
            text: 'CONFIRM',
            onPressed: () {
              Navigator.pop(context, true);
            },
            width: 150,
          ),
          const SizedBox(width: 16),
          CustomButton(
            text: 'Cancel',
            onPressed: () {
              Navigator.pop(context);
            },
            backgroundColor: Colors.transparent,
            textColor: AppColors.primary,
            width: 150,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Transfer Money',
        hasBackButton: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'From Account',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                _buildSourceAccountDropdown(),
                const SizedBox(height: 24),
                const Text(
                  'Transfer Amount',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                  ],
                  decoration: InputDecoration(
                    hintText: 'Enter amount',
                    prefixIcon: const Icon(Icons.attach_money),
                    filled: true,
                    fillColor: AppColors.backgroundDark,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an amount';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Please enter a valid amount';
                    }
                    if (double.parse(value) <= 0) {
                      return 'Amount must be greater than zero';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                const Text(
                  'To',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                CustomTextField(
                  hintText: 'Recipient Name',
                  prefixIcon: Icons.person,
                  controller: _recipientController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter recipient name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  hintText: 'Account Number',
                  prefixIcon: Icons.account_balance,
                  controller: _accountNumberController,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter account number';
                    }
                    if (value.length < 8) {
                      return 'Account number is too short';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                const Text(
                  'Description (Optional)',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                CustomTextField(
                  hintText: 'Add a description',
                  prefixIcon: Icons.description,
                  controller: _descriptionController,
                ),
                const SizedBox(height: 40),
                CustomButton(
                  text: 'TRANSFER NOW',
                  onPressed: _isTransferring ? null : () => _submitTransfer(),
                  isLoading: _isTransferring,
                  backgroundColor: Colors.transparent,
                  textColor: AppColors.primary,
                ),
                const SizedBox(height: 16),
                CustomButton(
                  text: 'SCHEDULE FOR LATER',
                  onPressed: () {
                    // Schedule transfer logic
                  },
                  backgroundColor: Colors.transparent,
                  textColor: AppColors.primary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSourceAccountDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.backgroundDark,
        borderRadius: BorderRadius.circular(15),
      ),
      child: DropdownButton<String>(
        value: _selectedSourceAccount,
        isExpanded: true,
        underline: Container(),
        icon: const Icon(Icons.arrow_drop_down, color: AppColors.primary),
        items: _accounts.map((String account) {
          return DropdownMenuItem<String>(
            value: account,
            child: Text(account),
          );
        }).toList(),
        onChanged: (String? newValue) {
          setState(() {
            _selectedSourceAccount = newValue!;
          });
        },
      ),
    );
  }
} 