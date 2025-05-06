import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _language = 'English'; // Default language

  @override
  void initState() {
    super.initState();
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _language = prefs.getString('language') ?? 'English';
    });
  }

  Future<void> _updateLanguage(String language) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', language);
    setState(() {
      _language = language;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Container(
        
        child: SettingsList(
          sections: [
            SettingsSection(
              title: const Text('General'),
              tiles: <SettingsTile>[
                SettingsTile.navigation(
                  leading: const Icon(Icons.language),
                  title: const Text('Language'),
                  value: Text(_language),
                  onPressed: (context) async {
                    final selectedLanguage = await _showLanguageSelectionDialog(context);
                    if (selectedLanguage != null) {
                      _updateLanguage(selectedLanguage);
                    }
                  },
                ),
                SettingsTile.switchTile(
                  onToggle: (value) {
                    // Handle dark mode toggle
                  },
                  initialValue: false,
                  leading: const Icon(Icons.dark_mode),
                  title: const Text('Dark Mode'),
                ),
              ],
            ),
            SettingsSection(
              title: const Text('Notifications'),
              tiles: <SettingsTile>[
                SettingsTile.switchTile(
                  onToggle: (value) {
                    // Handle notification toggle
                  },
                  initialValue: true,
                  leading: const Icon(Icons.notifications),
                  title: const Text('Enable Notifications'),
                ),
                SettingsTile.switchTile(
                  onToggle: (value) {
                    // Handle sound toggle
                  },
                  initialValue: true,
                  leading: const Icon(Icons.volume_up),
                  title: const Text('Notification Sounds'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<String?> _showLanguageSelectionDialog(BuildContext context) async {
    return showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Select Language'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('English'),
                onTap: () => Navigator.pop(context, 'English'),
              ),
              ListTile(
                title: const Text('Filipino'),
                onTap: () => Navigator.pop(context, 'Filipino'),
              ),
            ],
          ),
        );
      },
    );
  }
}