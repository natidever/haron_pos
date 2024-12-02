import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haron_pos/bloc/theme/theme_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        final theme = Theme.of(context);
        final userBox = Hive.box('userBox');
        final userEmail =
            userBox.get('userEmail', defaultValue: 'No email set');

        return Drawer(
          backgroundColor: theme.scaffoldBackgroundColor,
          child: Column(
            children: [
              // Drawer Header
              Container(
                padding: const EdgeInsets.fromLTRB(16, 50, 16, 16),
                decoration: BoxDecoration(
                  color: theme.primaryColor,
                  boxShadow: [
                    BoxShadow(
                      color: theme.shadowColor,
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: theme.cardColor,
                      child: Icon(
                        Icons.person,
                        size: 40,
                        color: theme.primaryColor,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      userEmail,
                      style: GoogleFonts.poppins(
                        color: theme.colorScheme.onPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              // Drawer Items
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    _buildDrawerItem(
                      context,
                      icon: Icons.dashboard_outlined,
                      title: 'Dashboard',
                      onTap: () => Navigator.pushReplacementNamed(context, '/'),
                      theme: theme,
                    ),
                    _buildDrawerItem(
                      context,
                      icon: Icons.inventory_2_outlined,
                      title: 'Products',
                      onTap: () =>
                          Navigator.pushReplacementNamed(context, '/products'),
                      theme: theme,
                    ),
                    _buildDrawerItem(
                      context,
                      icon: Icons.point_of_sale_outlined,
                      title: 'Sales',
                      onTap: () =>
                          Navigator.pushReplacementNamed(context, '/sales'),
                      theme: theme,
                    ),
                    _buildDrawerItem(
                      context,
                      icon: Icons.receipt_long_outlined,
                      title: 'Transactions',
                      onTap: () => Navigator.pushReplacementNamed(
                          context, '/transactions'),
                      theme: theme,
                    ),
                    const Divider(),
                    _buildDrawerItem(
                      context,
                      icon: Icons.dark_mode_outlined,
                      title: 'Dark Mode',
                      trailing: Switch(
                        value: state.isDarkMode,
                        onChanged: (value) {
                          context.read<ThemeBloc>().add(ToggleTheme());
                        },
                        activeColor: theme.primaryColor,
                      ),
                      theme: theme,
                    ),
                    _buildDrawerItem(
                      context,
                      icon: Icons.settings_outlined,
                      title: 'Settings',
                      onTap: () => Navigator.pushNamed(context, '/settings'),
                      theme: theme,
                    ),
                    const Divider(),
                    _buildDrawerItem(
                      context,
                      icon: Icons.logout,
                      title: 'Logout',
                      onTap: () {
                        // Clear user session
                        Hive.box('userBox').clear();
                        Navigator.pushReplacementNamed(context, '/login');
                      },
                      textColor: Colors.red,
                      iconColor: Colors.red,
                      theme: theme,
                    ),
                  ],
                ),
              ),

              // App Version
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Version 1.0.0',
                  style: GoogleFonts.poppins(
                    color: theme.colorScheme.onBackground.withOpacity(0.5),
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    VoidCallback? onTap,
    Widget? trailing,
    Color? textColor,
    Color? iconColor,
    required ThemeData theme,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: iconColor ?? theme.colorScheme.onBackground.withOpacity(0.7),
      ),
      title: Text(
        title,
        style: GoogleFonts.poppins(
          color: textColor ?? theme.colorScheme.onBackground,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: trailing,
      onTap: onTap,
      dense: true,
      horizontalTitleGap: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      selectedTileColor: theme.primaryColor.withOpacity(0.1),
    );
  }
}
