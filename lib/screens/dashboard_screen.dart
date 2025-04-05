import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../components/bank_card.dart';
import '../components/transaction_card.dart';
import 'accounts_screen.dart';
import 'transfer_screen.dart';
import 'profile_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;
  final List<Widget> _screens = [
    const HomeTab(),
    const AccountsScreen(),
    const TransferScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.textSecondary,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_balance_wallet),
              label: 'Accounts',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.swap_horiz),
              label: 'Transfer',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}

class HomeTab extends StatelessWidget {
  const HomeTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              _buildCardSection(context),
              _buildQuickActions(context),
              _buildRecentTransactions(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    const headerTextStyleSmall = TextStyle(
      color: Colors.white70,
      fontSize: 16,
    );
    
    const nameTextStyle = TextStyle(
      color: Colors.white,
      fontSize: 24,
      fontWeight: FontWeight.bold,
    );
    
    const balanceTextStyle = TextStyle(
      color: Colors.white,
      fontSize: 32,
      fontWeight: FontWeight.bold,
    );
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: AppColors.gradientPrimary,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('Welcome back,', style: headerTextStyleSmall),
                  SizedBox(height: 4),
                  Text('Sir Ammar', style: nameTextStyle),
                ],
              ),
              const CircleAvatar(
                radius: 24,
                backgroundColor: Colors.white24,
                child: Icon(
                  Icons.person,
                  color: Colors.white,
                  size: 28,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text('Total Balance', style: headerTextStyleSmall),
          const SizedBox(height: 8),
          const Text('\$267,345.00', style: balanceTextStyle),
        ],
      ),
    );
  }

  Widget _buildCardSection(BuildContext context) {
    const sectionTitleStyle = TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: AppColors.textPrimary,
    );
    
    final cardsList = [
      const BankCard(
        cardNumber: '4242424242424242',
        cardHolderName: 'Sir Ammar',
        expiryDate: '12/25',
        balance: 153229.00,
        cardType: 'VISA Platinum',
      ),
      const SizedBox(width: 16),
      const BankCard(
        cardNumber: '5353535353535353',
        cardHolderName: 'Sir Ammar',
        expiryDate: '08/27',
        balance: 114116.00,
        cardType: 'Mastercard Gold',
      ),
    ];
    
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('My Cards', style: sectionTitleStyle),
              TextButton(
                onPressed: () {
                  // Navigate to all cards
                },
                child: const Text('See All'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: ListView(
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              children: cardsList,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Quick Actions',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          LayoutBuilder(
            builder: (context, constraints) {
              // For small screens, use a Wrap widget instead of Row
              if (constraints.maxWidth < 400) {
                return Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  alignment: WrapAlignment.spaceBetween,
                  children: [
                    _buildActionButton(
                      context,
                      Icons.swap_horiz,
                      'Transfer',
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const TransferScreen()),
                        );
                      },
                    ),
                    _buildActionButton(
                      context,
                      Icons.receipt_long,
                      'Pay Bills',
                      () {
                        // Navigate to pay bills
                      },
                    ),
                    _buildActionButton(
                      context,
                      Icons.account_balance,
                      'Deposit',
                      () {
                        // Navigate to deposit
                      },
                    ),
                    _buildActionButton(
                      context,
                      Icons.more_horiz,
                      'More',
                      () {
                        // Show more options
                      },
                    ),
                  ],
                );
              }
              
              // For larger screens, use the traditional Row layout
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildActionButton(
                    context,
                    Icons.swap_horiz,
                    'Transfer',
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const TransferScreen()),
                      );
                    },
                  ),
                  _buildActionButton(
                    context,
                    Icons.receipt_long,
                    'Pay Bills',
                    () {
                      // Navigate to pay bills
                    },
                  ),
                  _buildActionButton(
                    context,
                    Icons.account_balance,
                    'Deposit',
                    () {
                      // Navigate to deposit
                    },
                  ),
                  _buildActionButton(
                    context,
                    Icons.more_horiz,
                    'More',
                    () {
                      // Show more options
                    },
                  ),
                ],
              );
            }
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    IconData icon,
    String label,
    VoidCallback onTap,
  ) {
    final screenWidth = MediaQuery.of(context).size.width;
    final buttonWidth = screenWidth < 400 ? (screenWidth - 80) / 2 : 70.0;
    
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: buttonWidth,
        padding: const EdgeInsets.only(bottom: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.backgroundDark,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                icon,
                color: AppColors.primary,
                size: 28,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentTransactions(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Recent Transactions',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              TextButton(
                onPressed: () {
                  // Navigate to all transactions
                },
                child: const Text('See All'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const TransactionCard(
            title: 'Salary Deposit',
            date: 'Today, 10:45 AM',
            amount: '5,000.00',
            type: TransactionType.deposit,
            description: 'Monthly salary payment',
          ),
          const SizedBox(height: 12),
          const TransactionCard(
            title: 'Amazon Purchase',
            date: 'Yesterday, 2:30 PM',
            amount: '123.45',
            type: TransactionType.withdrawal,
            description: 'Online shopping',
          ),
          const SizedBox(height: 12),
          const TransactionCard(
            title: 'Transfer to John',
            date: 'Mar 15, 9:20 AM',
            amount: '500.00',
            type: TransactionType.transfer,
            description: 'Rent payment',
          ),
          const SizedBox(height: 12),
          const TransactionCard(
            title: 'Starbucks',
            date: 'Mar 14, 8:10 AM',
            amount: '4.50',
            type: TransactionType.withdrawal,
          ),
        ],
      ),
    );
  }
} 