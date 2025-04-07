import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../utils/app_colors.dart';
import '../utils/app_theme.dart';
import '../components/bank_card.dart';
import '../components/transaction_card.dart';
import '../components/custom_app_bar.dart';
import 'accounts_screen.dart';
import 'transfer_screen.dart';
import 'profile_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  late TabController _tabController;
  
  final List<Widget> _screens = [
    const HomeTab(),
    const AccountsScreen(),
    const TransferScreen(),
    const ProfileScreen(),
  ];
  
  final List<BottomNavigationBarItem> _navItems = const [
    BottomNavigationBarItem(
      icon: Icon(Icons.home_outlined),
      activeIcon: Icon(Icons.home),
      label: 'Home',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.account_balance_wallet_outlined),
      activeIcon: Icon(Icons.account_balance_wallet),
      label: 'Accounts',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.swap_horiz_outlined),
      activeIcon: Icon(Icons.swap_horiz),
      label: 'Transfer',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.person_outline),
      activeIcon: Icon(Icons.person),
      label: 'Profile',
    ),
  ];
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _screens.length, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedIndex = _tabController.index;
      });
    });
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _screens[_selectedIndex],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowLight,
              blurRadius: 8,
              offset: const Offset(0, -3),
            ),
          ],
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          child: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: (index) {
              setState(() {
                _selectedIndex = index;
                _tabController.animateTo(index);
              });
            },
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            selectedItemColor: AppColors.primary,
            unselectedItemColor: AppColors.neutral700,
            showSelectedLabels: true,
            showUnselectedLabels: true,
            selectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 12,
              fontFamily: 'Montserrat',
            ),
            unselectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 12,
              fontFamily: 'Montserrat',
            ),
            elevation: 0,
            items: _navItems,
          ),
        ),
      ),
    );
  }
}

class HomeTab extends StatefulWidget {
  const HomeTab({Key? key}) : super(key: key);

  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  bool _isRefreshing = false;
  
  Future<void> _refreshData() async {
    setState(() {
      _isRefreshing = true;
    });
    
    // Simulate a refresh
    await Future.delayed(const Duration(seconds: 1));
    
    setState(() {
      _isRefreshing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refreshData,
        color: AppColors.primary,
        backgroundColor: Colors.white,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          slivers: [
            // Custom App Bar
            SliverAppBar(
              expandedHeight: 160.0,
              floating: false,
              pinned: true,
              backgroundColor: AppColors.primary,
              elevation: 0,
              automaticallyImplyLeading: false,
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.pin,
                background: _buildHeader().animate().fade(),
              ),
            ),
            
            // Cards Section
            SliverToBoxAdapter(
              child: _buildCardSection(context).animate().fadeIn(delay: 200.ms).slideY(begin: 30, end: 0, delay: 200.ms, duration: 400.ms),
            ),
            
            // Quick Actions
            SliverToBoxAdapter(
              child: _buildQuickActions(context).animate().fadeIn(delay: 300.ms).slideY(begin: 30, end: 0, delay: 300.ms, duration: 400.ms),
            ),
            
            // Recent Transactions
            SliverToBoxAdapter(
              child: _buildRecentTransactions(context).animate().fadeIn(delay: 400.ms).slideY(begin: 30, end: 0, delay: 400.ms, duration: 400.ms),
            ),
            
            // Bottom Padding
            SliverToBoxAdapter(
              child: SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    const headerTextStyleSmall = TextStyle(
      color: Colors.white70,
      fontSize: 12,
      fontFamily: 'Montserrat',
      letterSpacing: 0.5,
    );
    
    const nameTextStyle = TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.bold,
      fontFamily: 'Montserrat',
      letterSpacing: 0.5,
    );
    
    const balanceTextStyle = TextStyle(
      color: Colors.white,
      fontSize: 28,
      fontWeight: FontWeight.bold,
      fontFamily: 'Montserrat',
      letterSpacing: 0.5,
    );
    
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: AppColors.gradientLuxury,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Text('Welcome back,', style: headerTextStyleSmall),
                      SizedBox(height: 2),
                      Text('Sir Ammar', style: nameTextStyle),
                    ],
                  ),
                  InkWell(
                    onTap: () {},
                    borderRadius: BorderRadius.circular(30),
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white30,
                          width: 1,
                        ),
                      ),
                      child: const CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.white24,
                        child: Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Total Balance', style: headerTextStyleSmall),
                  const SizedBox(height: 2),
                  Wrap(
                    spacing: 8,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      const Text('\$267,345.00', style: balanceTextStyle),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.success.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: AppColors.success.withOpacity(0.5),
                            width: 1.0,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(
                              Icons.arrow_upward,
                              color: Colors.white,
                              size: 12,
                            ),
                            SizedBox(width: 4),
                            Text(
                              '3.2%',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Montserrat',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCardSection(BuildContext context) {
    const sectionTitleStyle = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: AppColors.textPrimary,
      fontFamily: 'Montserrat',
      letterSpacing: 0.2,
    );
    
    final cardsList = [
      const BankCard(
        cardNumber: '4242424242424242',
        cardHolderName: 'Sir Ammar',
        expiryDate: '12/25',
        balance: 153229.00,
        cardType: 'VISA Platinum',
        isPremiumCard: true,
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
      margin: const EdgeInsets.only(left: 20, right: 20, top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('My Cards', style: sectionTitleStyle),
              ElevatedButton.icon(
                onPressed: () {
                  // Navigate to all cards
                },
                icon: const Icon(Icons.add, size: 16, color: Colors.white),
                label: const Text(
                  'Add New',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 12,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  elevation: 2,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 170,
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
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Quick Actions',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
              fontFamily: 'Montserrat',
              letterSpacing: 0.2,
            ),
          ),
          const SizedBox(height: 12),
          LayoutBuilder(
            builder: (context, constraints) {
              final buttonWidth = (constraints.maxWidth - 48) / 4;
              
              return Wrap(
                spacing: 12,
                runSpacing: 16,
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
                    AppColors.primary,
                    buttonWidth,
                  ),
                  _buildActionButton(
                    context,
                    Icons.receipt_long,
                    'Pay Bills',
                    () {
                      // Navigate to pay bills
                    },
                    AppColors.accent,
                    buttonWidth,
                  ),
                  _buildActionButton(
                    context,
                    Icons.account_balance,
                    'Deposit',
                    () {
                      // Navigate to deposit
                    },
                    AppColors.info,
                    buttonWidth,
                  ),
                  _buildActionButton(
                    context,
                    Icons.qr_code_scanner,
                    'Scan',
                    () {
                      // Show scanner
                    },
                    AppColors.neutral900,
                    buttonWidth,
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
    Color iconColor,
    double buttonWidth,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: buttonWidth,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: iconColor,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: iconColor.withOpacity(0.3),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 22,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: iconColor,
                fontFamily: 'Montserrat',
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
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Recent Transactions',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                  fontFamily: 'Montserrat',
                  letterSpacing: 0.2,
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  // Navigate to all transactions
                },
                child: const Text(
                  'See All',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 12,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  elevation: 2,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const TransactionCard(
            title: 'Salary Deposit',
            date: 'Today, 10:45 AM',
            amount: '5,000.00',
            type: TransactionType.deposit,
            description: 'Monthly salary payment',
          ),
          const SizedBox(height: 6),
          const TransactionCard(
            title: 'Amazon Purchase',
            date: 'Yesterday, 2:30 PM',
            amount: '123.45',
            type: TransactionType.withdrawal,
            description: 'Online shopping',
          ),
          const SizedBox(height: 6),
          const TransactionCard(
            title: 'Transfer to John',
            date: 'Mar 15, 9:20 AM',
            amount: '500.00',
            type: TransactionType.transfer,
            description: 'Rent payment',
          ),
        ],
      ),
    );
  }
} 