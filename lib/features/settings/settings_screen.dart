import 'package:flutter/material.dart';
import 'package:tikitaki/data/settings_repository.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({required this.settingsRepository, super.key});

  final SettingsRepository settingsRepository;

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _controller = TextEditingController();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCurrentUrl();
  }

  Future<void> _loadCurrentUrl() async {
    try {
      final url = await widget.settingsRepository.getBaseUrl();
      _controller.text = url;
    } on Exception catch (_) {
      // Keep the field empty on error
    }
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _save() async {
    final text = _controller.text;
    final uri = Uri.tryParse(text);
    if (uri == null || !uri.hasScheme) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter a valid URL with scheme')),
        );
      }
      return;
    }
    await widget.settingsRepository.setBaseUrl(text);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Settings saved. Restart app to apply new URL.'),
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: _controller,
                    decoration: const InputDecoration(labelText: 'Base URL'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(onPressed: _save, child: const Text('Save')),
                ],
              ),
            ),
    );
  }
}
