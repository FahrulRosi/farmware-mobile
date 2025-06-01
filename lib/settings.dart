import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _supabase = Supabase.instance.client;
  Map<String, dynamic>? _userData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user != null) {
      if (!mounted) return;
      setState(() {
        _userData = {
          'display_name': '${user.userMetadata?['first_name'] ?? ''} ${user.userMetadata?['last_name'] ?? ''}'.trim(),
          'email': user.email ?? 'No email',
        };
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // Profile Header
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF00A86B).withOpacity(0.9),
                    const Color(0xFF00C853).withOpacity(0.85),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 30),
                  // Profile Image
                  Stack(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              spreadRadius: 2,
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: const CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.white70,
                          child: Icon(
                            Icons.person,
                            size: 50,
                            color: Color(0xFF00A86B),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                spreadRadius: 1,
                                blurRadius: 4,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.edit,
                            size: 20,
                            color: Color(0xFF00A86B),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Name
                  Text(
                    isLoading ? 'Loading...' : (_userData?['display_name'] ?? 'No name'),
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),

            // Settings Content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Account Settings Section
                  Row(
                    children: const [
                      Icon(Icons.settings, color: Color(0xFF00A86B), size: 24),
                      SizedBox(width: 8),
                      Text(
                        'Account Settings',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2F2F2F),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.withOpacity(0.2)),
                    ),
                    child: Column(
                      children: [
                        _buildSettingItem(
                          icon: Icons.person_outline,
                          title: 'Name',
                          value: _userData?['display_name'] ?? 'No name',
                          onTap: () async {
                            final result = await Navigator.pushNamed(context, '/edit-name');
                            if (result != null && result is Map<String, String>) {
                              setState(() {
                                _userData = {
                                  ..._userData ?? {},
                                  'display_name': '${result['first_name']} ${result['last_name']}'.trim(),
                                };
                              });
                            }
                          },
                        ),
                        _buildSettingItem(
                          icon: Icons.email_outlined,
                          title: 'Email',
                          value: _userData?['email'] ?? 'No email',
                          enabled: false,
                        ),
                        _buildSettingItem(
                          icon: Icons.lock_outline,
                          title: 'Password',
                          value: '••••••••',
                          onTap: () => Navigator.pushNamed(context, '/edit-password'),
                          showDivider: false,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),
                  // Help & Support Section
                  Row(
                    children: const [
                      Icon(Icons.help_outline, color: Color(0xFF00A86B), size: 24),
                      SizedBox(width: 8),
                      Text(
                        'Help & Support',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2F2F2F),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.withOpacity(0.2)),
                    ),
                    child: _buildSettingItem(
                      icon: Icons.logout,
                      title: 'Logout',
                      onTap: _showLogoutDialog,
                      isDestructive: true,
                      showDivider: false,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    String? value,
    VoidCallback? onTap,
    bool enabled = true,
    bool isDestructive = false,
    bool showDivider = true,
  }) {
    return Column(
      children: [
        InkWell(
          onTap: enabled ? onTap : null,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 24,
                  color: isDestructive ? Colors.red : const Color(0xFF00A86B),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: isDestructive ? Colors.red : const Color(0xFF2F2F2F),
                        ),
                      ),
                      if (value != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          value,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF666666),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  size: 20,
                  color: isDestructive 
                      ? Colors.red.withOpacity(0.7) 
                      : const Color(0xFFBBBBBB),
                ),
              ],
            ),
          ),
        ),
        if (showDivider)
          const Divider(
            height: 1,
            thickness: 1,
            indent: 52,
            endIndent: 0,
            color: Color(0xFFEEEEEE),
          ),
      ],
    );
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Account'),
          content: const Text(
            'Are you sure you want to delete your account? This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: _handleDeleteAccount,
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _handleDeleteAccount() async {
    try {
      await _supabase.auth.admin.deleteUser(
        _supabase.auth.currentUser!.id,
      );
      if (!mounted) return;
      Navigator.of(context).pushNamedAndRemoveUntil('/login', (_) => false);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error deleting account: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: _handleLogout,
              child: const Text(
                'Logout',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _handleLogout() async {
    try {
      await _supabase.auth.signOut();
      if (!mounted) return;
      Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error logging out: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}