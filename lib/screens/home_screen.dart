import 'package:flutter/material.dart';
import '../models/donation.dart';
import '../screens/profile_screen.dart';
import '../screens/donation_details_screen.dart';
import '../screens/donation_form_screen.dart';
import '../screens/my_donations_screen.dart';
import '../screens/history_screen.dart';
import '../providers/user_provider.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  int _selectedIndex = 0;
  final List<Widget> _screens = [
    const HomeContent(),
    const MyDonationsScreen(),
    const HistoryScreen(),
  ];

  void _onItemSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          _getTitle(),
          style: const TextStyle(
            color: Colors.green,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person, color: Colors.green),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            },
          ),
        ],
      ),
      drawer: CustomDrawer(
        selectedIndex: _selectedIndex,
        onItemSelected: _onItemSelected,
      ),
      body: _screens[_selectedIndex],
      floatingActionButton: _selectedIndex == 0
          ? ScaleTransition(
              scale: CurvedAnimation(
                parent: _controller,
                curve: Curves.elasticOut,
              ),
              child: FloatingActionButton.extended(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DonationFormScreen(),
                    ),
                  );
                },
                backgroundColor: Colors.green,
                icon: const Icon(Icons.add),
                label: const Text('Donate Food'),
              ),
            )
          : null,
    );
  }

  String _getTitle() {
    switch (_selectedIndex) {
      case 0:
        return 'FoodShare';
      case 1:
        return 'My Donations';
      case 2:
        return 'History';
      default:
        return 'FoodShare';
    }
  }
}

class CustomDrawer extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;

  const CustomDrawer({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;

    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.green,
              image: DecorationImage(
                image: AssetImage('assets/drawer_header_bg.jpg'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black26,
                  BlendMode.darken,
                ),
              ),
            ),
            currentAccountPicture: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, size: 40, color: Colors.green),
            ),
            accountName: Text(
              user?.name ?? 'User Name',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            accountEmail: Text(
              user?.email ?? 'user@example.com',
              style: const TextStyle(fontSize: 14),
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildDrawerItem(
                  icon: Icons.home,
                  title: 'Home',
                  index: 0,
                ),
                _buildDrawerItem(
                  icon: Icons.favorite,
                  title: 'My Donations',
                  index: 1,
                ),
                _buildDrawerItem(
                  icon: Icons.history,
                  title: 'History',
                  index: 2,
                ),
                const Divider(),
                _buildDrawerItem(
                  icon: Icons.notifications,
                  title: 'Notifications',
                  badge: '3',
                ),
                _buildDrawerItem(
                  icon: Icons.settings,
                  title: 'Settings',
                ),
                _buildDrawerItem(
                  icon: Icons.help,
                  title: 'Help & Feedback',
                ),
              ],
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text(
              'Logout',
              style: TextStyle(color: Colors.red),
            ),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    int? index,
    String? badge,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: index != null && index == selectedIndex
            ? Colors.green
            : Colors.grey[700],
      ),
      title: Text(
        title,
        style: TextStyle(
          color: index != null && index == selectedIndex
              ? Colors.green
              : Colors.grey[900],
        ),
      ),
      trailing: badge != null
          ? Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              child: Text(
                badge,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
            )
          : null,
      selected: index != null && index == selectedIndex,
      selectedTileColor: Colors.green.withOpacity(0.1),
      onTap: () {
        if (index != null) {
          onItemSelected(index);
        } else {
          Navigator.pop(context);
        }
      },
    );
  }
} 