import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gym_guide/pages/login.dart';
import 'package:gym_guide/services/auth_provider.dart';
import 'package:gym_guide/services/premium_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isProcessingPayment = false;
  bool _isPremiumUnlocked = false;

  @override
  void initState() {
    super.initState();
    _loadPremiumStatus();
  }

  Future<void> _loadPremiumStatus() async {
    final status = await PremiumService.isPremiumUnlocked();
    if (mounted) {
      setState(() {
        _isPremiumUnlocked = status;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.currentUser;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Profile',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 24,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: ElevatedButton(
              onPressed: () {
                _showLogoutDialog(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade50,
                foregroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              child: Text(
                "Log out",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Profile Picture Section
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.blue.shade100,
                    width: 3,
                  ),
                ),
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 55,
                      backgroundImage: user?.photoURL != null ? NetworkImage(user!.photoURL!) : const AssetImage('assets/images/profile.png') as ImageProvider,
                      backgroundColor: Colors.grey.shade200,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),

              // User Name
              Text(
                user?.displayName ?? 'John Doe',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4),

              // User Email
              Text(
                user?.email ?? 'john.doe@example.com',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade600,
                ),
              ),
              SizedBox(height: 32),

              // Premium Feature Container
              _isProcessingPayment
                  ? Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Column(
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 10),
                          Text(
                            'Processing payment...',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    )
                  : GestureDetector(
                      onTap: _isPremiumUnlocked
                          ? null
                          : () {
                              _showPremiumDialog(context);
                            },
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: _isPremiumUnlocked ? Colors.green.shade100 : Colors.lightGreenAccent,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: _isPremiumUnlocked ? Colors.green : Colors.grey.shade200,
                            width: _isPremiumUnlocked ? 2 : 1,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              _isPremiumUnlocked ? "Premium Unlocked! 🎉" : "Unlock all features",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: 10),
                            Icon(
                              _isPremiumUnlocked ? Icons.verified : Icons.lock_open,
                              size: 40,
                              color: _isPremiumUnlocked ? Colors.green : Colors.black,
                            ),
                            if (!_isPremiumUnlocked)
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Text(
                                  "Tap to unlock premium features",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
              SizedBox(height: 32),

              // Settings Section
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Settings',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade800,
                    ),
                  ),
                  SizedBox(height: 16),
                  _buildSettingTile(
                    icon: Icons.person,
                    title: 'Edit Profile',
                    onTap: () {},
                  ),
                  _buildSettingTile(
                    icon: Icons.notifications,
                    title: 'Notifications',
                    onTap: () {},
                  ),
                  _buildSettingTile(
                    icon: Icons.security,
                    title: 'Privacy & Security',
                    onTap: () {},
                  ),
                  _buildSettingTile(
                    icon: Icons.help,
                    title: 'Help & Support',
                    onTap: () {},
                  ),
                  _buildSettingTile(
                    icon: Icons.info,
                    title: 'About App',
                    onTap: () {},
                  ),
                ],
              ),

              // App Version
              SizedBox(height: 40),
              Text(
                'Gym Guide v1.0.0',
                style: TextStyle(
                  color: Colors.grey.shade500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: Colors.blue,
            size: 22,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: Icon(
          Icons.chevron_right,
          color: Colors.grey.shade400,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        tileColor: Colors.grey.shade50,
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Log Out',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Text('Are you sure you want to log out?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final authProvider = Provider.of<AuthProvider>(context, listen: false);
                await authProvider.signOut();
                if (context.mounted) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                    (route) => false,
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: Text('Log Out'),
            ),
          ],
        );
      },
    );
  }

  void _showPremiumDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.star, color: Colors.amber),
              SizedBox(width: 10),
              Text(
                'Unlock Premium',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Get access to all premium features:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              _buildFeatureItem('✓ Abs Workout Program'),
              _buildFeatureItem('✓ Advanced Analytics'),
              _buildFeatureItem('✓ Personalized Diet Plans'),
              _buildFeatureItem('✓ No Ads'),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Premium Plan',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text('One-time payment'),
                      ],
                    ),
                    Text(
                      '\$9.99',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
                _processPayment(); // Start payment process
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              child: Text('Purchase Now'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildFeatureItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(Icons.check_circle, color: Colors.green, size: 18),
          SizedBox(width: 8),
          Text(text),
        ],
      ),
    );
  }

  Future<void> _processPayment() async {
    if (!mounted) return;

    setState(() {
      _isProcessingPayment = true;
    });

    // Simulate payment processing
    await Future.delayed(Duration(seconds: 2));

    if (!mounted) return;

    // Unlock premium
    await PremiumService.unlockPremium();

    // Update state
    setState(() {
      _isProcessingPayment = false;
      _isPremiumUnlocked = true;
    });

    // Show success snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Premium features unlocked successfully!'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }
}
