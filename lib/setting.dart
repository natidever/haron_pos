import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haron_pos/constants/colors.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haron_pos/bloc/theme/theme_bloc.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool notificationsEnabled = true;
  String selectedLanguage = 'English';
  String selectedCurrency = 'USD';

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        final theme = Theme.of(context);

        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Text(
              'Settings',
              style: GoogleFonts.poppins(
                color: theme.colorScheme.onBackground,
                fontWeight: FontWeight.w600,
              ),
            ),
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios,
                  color: theme.colorScheme.onBackground),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionHeader('Appearance'),
                _buildSettingCard(
                  title: 'Dark Mode',
                  subtitle: 'Toggle dark/light theme',
                  icon: state.isDarkMode
                      ? Icons.dark_mode
                      : Icons.dark_mode_outlined,
                  trailing: Switch(
                    value: state.isDarkMode,
                    onChanged: (value) {
                      context.read<ThemeBloc>().add(ToggleTheme());
                    },
                    activeColor: theme.primaryColor,
                  ),
                ),
                _buildSectionHeader('General'),
                _buildSettingCard(
                  title: 'Language',
                  subtitle: selectedLanguage,
                  icon: Icons.language_outlined,
                  onTap: () => _showLanguageDialog(),
                ),
                _buildSettingCard(
                  title: 'Currency',
                  subtitle: selectedCurrency,
                  icon: Icons.attach_money_outlined,
                  onTap: () => _showCurrencyDialog(),
                ),
                _buildSectionHeader('Notifications'),
                _buildSettingCard(
                  title: 'Push Notifications',
                  subtitle: 'Receive notifications about sales and updates',
                  icon: Icons.notifications_outlined,
                  trailing: Switch(
                    value: notificationsEnabled,
                    onChanged: (value) {
                      setState(() => notificationsEnabled = value);
                    },
                    activeColor: theme.primaryColor,
                  ),
                ),
                _buildSectionHeader('Data Management'),
                _buildSettingCard(
                  title: 'Export Data',
                  subtitle: 'Export your transactions and products',
                  icon: Icons.upload_outlined,
                  onTap: () {
                    // Implement export functionality
                  },
                ),
                _buildSettingCard(
                  title: 'Backup',
                  subtitle: 'Backup your data to cloud',
                  icon: Icons.backup_outlined,
                  onTap: () {
                    // Implement backup functionality
                  },
                ),
                _buildSectionHeader('About'),
                _buildSettingCard(
                  title: 'Version',
                  subtitle: '1.0.0',
                  icon: Icons.info_outline,
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
      child: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.grey[600],
        ),
      ),
    );
  }

  Widget _buildSettingCard({
    required String title,
    required String subtitle,
    required IconData icon,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor,
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: theme.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: theme.primaryColor, size: 24),
        ),
        title: Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
        trailing: trailing ?? const Icon(Icons.arrow_forward_ios, size: 16),
      ),
    );
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Select Language',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: ['English', 'Spanish', 'French', 'Arabic']
              .map(
                (lang) => ListTile(
                  title: Text(lang),
                  leading: Radio<String>(
                    value: lang,
                    groupValue: selectedLanguage,
                    onChanged: (value) {
                      setState(() => selectedLanguage = value!);
                      Navigator.pop(context);
                    },
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  void _showCurrencyDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Select Currency',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: ['USD', 'EUR', 'GBP', 'ETB']
              .map(
                (currency) => ListTile(
                  title: Text(currency),
                  leading: Radio<String>(
                    value: currency,
                    groupValue: selectedCurrency,
                    onChanged: (value) {
                      setState(() => selectedCurrency = value!);
                      Navigator.pop(context);
                    },
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
