import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../providers/favorites_provider.dart';
import '../widgets/profile/profile_header.dart';
import '../widgets/profile/profile_stats.dart';
import '../widgets/profile/profile_menu_section.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(context),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const ProfileHeader(),
                  const SizedBox(height: 24),
                  Consumer<FavoritesProvider>(
                    builder: (context, favoritesProvider, child) {
                      return ProfileStats(
                        favoritesCount: favoritesProvider.favoritesCount,
                        applicationsCount: 3,
                        reviewsCount: 12,
                      );
                    },
                  ),
                  const SizedBox(height: 32),
                  _buildMenuSections(context),
                  const SizedBox(height: 100), // Bottom padding for navigation
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 120.0,
      floating: false,
      pinned: true,
      elevation: 0,
      backgroundColor: Theme.of(context).colorScheme.surface,
      foregroundColor: Theme.of(context).colorScheme.onSurface,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          'Profile',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        centerTitle: true,
      ),
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              _showSettingsBottomSheet(context);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMenuSections(BuildContext context) {
    return Column(
      children: [
        ProfileMenuSection(
          title: 'Pet Care',
          items: [
            ProfileMenuItem(
              icon: Icons.pets_outlined,
              title: 'My Applications',
              subtitle: 'View your adoption applications',
              onTap: () => _navigateToApplications(context),
            ),
            ProfileMenuItem(
              icon: Icons.history_outlined,
              title: 'Adoption History',
              subtitle: 'See your completed adoptions',
              onTap: () => _navigateToHistory(context),
            ),
            ProfileMenuItem(
              icon: Icons.star_border_outlined,
              title: 'Reviews & Ratings',
              subtitle: 'Manage your reviews',
              onTap: () => _navigateToReviews(context),
            ),
          ],
        ),
        const SizedBox(height: 24),
        ProfileMenuSection(
          title: 'Account',
          items: [
            ProfileMenuItem(
              icon: Icons.notifications_outlined,
              title: 'Notifications',
              subtitle: 'Manage notification preferences',
              onTap: () => _navigateToNotifications(context),
            ),
            ProfileMenuItem(
              icon: Icons.security_outlined,
              title: 'Privacy & Security',
              subtitle: 'Account security settings',
              onTap: () => _navigateToSecurity(context),
            ),
            ProfileMenuItem(
              icon: Icons.help_outline,
              title: 'Help & Support',
              subtitle: 'Get help or contact support',
              onTap: () => _navigateToSupport(context),
            ),
          ],
        ),
        const SizedBox(height: 24),
        ProfileMenuSection(
          title: 'About',
          items: [
            ProfileMenuItem(
              icon: Icons.info_outline,
              title: 'About PetAdopt',
              subtitle: 'Learn more about our mission',
              onTap: () => _navigateToAbout(context),
            ),
            ProfileMenuItem(
              icon: Icons.description_outlined,
              title: 'Terms of Service',
              subtitle: 'Read our terms and conditions',
              onTap: () => _navigateToTerms(context),
            ),
            ProfileMenuItem(
              icon: Icons.logout_outlined,
              title: 'Sign Out',
              subtitle: 'Sign out of your account',
              onTap: () => _showSignOutDialog(context),
              isDestructive: true,
            ),
          ],
        ),
      ],
    );
  }

  void _showSettingsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.6,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.4),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Settings',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Add settings options here
                  const Text('Settings options will be implemented here'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSignOutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        icon: Icon(
          Icons.logout_outlined,
          color: Theme.of(context).colorScheme.error,
          size: 32,
        ),
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out of your account?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton.tonal(
            onPressed: () {
              Navigator.pop(context);
              // Handle sign out logic here
              _handleSignOut(context);
            },
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.errorContainer,
              foregroundColor: Theme.of(context).colorScheme.onErrorContainer,
            ),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }

  // Navigation methods
  void _navigateToApplications(BuildContext context) {
    // TODO: Implement navigation
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('My Applications - Coming Soon')),
    );
  }

  void _navigateToHistory(BuildContext context) {
                    context.push('/history');
  }

  void _navigateToReviews(BuildContext context) {
    // TODO: Implement navigation
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Reviews & Ratings - Coming Soon')),
    );
  }

  void _navigateToNotifications(BuildContext context) {
    // TODO: Implement navigation
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Notifications - Coming Soon')),
    );
  }

  void _navigateToSecurity(BuildContext context) {
    // TODO: Implement navigation
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Privacy & Security - Coming Soon')),
    );
  }

  void _navigateToSupport(BuildContext context) {
    // TODO: Implement navigation
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Help & Support - Coming Soon')),
    );
  }

  void _navigateToAbout(BuildContext context) {
    // TODO: Implement navigation
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('About PetAdopt - Coming Soon')),
    );
  }

  void _navigateToTerms(BuildContext context) {
    // TODO: Implement navigation
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Terms of Service - Coming Soon')),
    );
  }

  void _handleSignOut(BuildContext context) {
    // TODO: Implement sign out logic
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Signed out successfully')),
    );
  }
} 