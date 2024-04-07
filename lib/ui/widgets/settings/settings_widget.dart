import 'package:flutter/material.dart';

class SettingsWidget extends StatelessWidget {
  const SettingsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFFF5EEE5),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: _BodyWidget(),
        ),
      ),
    );
  }
}

class _BodyWidget extends StatelessWidget {
  const _BodyWidget();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        _TitleWidget(),
        SizedBox(height: 24),
        _AccountInfoWidget(),
        SizedBox(height: 16),
        _SettingMenuWidget(),
      ],
    );
  }
}

class _TitleWidget extends StatelessWidget {
  const _TitleWidget();

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Settings',
      style: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w600,
        color: Color(0xFF7E675E),
      ),
    );
  }
}

class _AccountInfoWidget extends StatelessWidget {
  const _AccountInfoWidget();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFF7E675E),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Account',
              style: TextStyle(
                color: Color(0xFFF5EEE5),
                fontWeight: FontWeight.w700,
                fontSize: 24,
              ),
            ),
            SizedBox(height: 8),
            _AccountInfoTileWidget(
              icon: Icons.account_circle,
              title: 'John Kennedy',
              subtitle: 'Account Information',
            ),
            SizedBox(height: 16),
            _AccountInfoTileWidget(
              icon: Icons.security,
              title: 'Password and Security',
              subtitle: 'Personal Password',
            ),
            SizedBox(height: 16),
            _AccountInfoTileWidget(
              icon: Icons.paypal,
              title: 'Payment and Refunds',
              subtitle: 'Refund Status and Payment Modes',
            ),
          ],
        ),
      ),
    );
  }
}

class _AccountInfoTileWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _AccountInfoTileWidget({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  void onPressed() {
    debugPrint('Account: $title');
  }

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: onPressed,
      style: const ButtonStyle(
        minimumSize: MaterialStatePropertyAll(Size(0, 0)),
      ),
      child: Row(
        children: [
          Icon(icon),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
          const Spacer(),
          const Icon(Icons.chevron_right),
        ],
      ),
    );
  }
}

class _SettingMenuWidget extends StatelessWidget {
  const _SettingMenuWidget();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFF7E675E),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Settings',
              style: TextStyle(
                color: Color(0xFFF5EEE5),
                fontWeight: FontWeight.w700,
                fontSize: 24,
              ),
            ),
            SizedBox(height: 16),
            _SettingItemWidget(
              icon: Icons.language,
              title: 'Language',
            ),
            SizedBox(height: 24),
            _SettingItemWidget(
              icon: Icons.group,
              title: 'All Teams',
            ),
            SizedBox(height: 24),
            _SettingItemWidget(
              icon: Icons.dark_mode,
              title: 'Dark Mode',
            ),
            SizedBox(height: 24),
            _SettingItemWidget(
              icon: Icons.warning,
              title: 'Send Feedback',
            ),
            SizedBox(height: 24),
            _SettingItemWidget(
              icon: Icons.help,
              title: 'Help',
            ),
            SizedBox(height: 24),
            _SettingItemWidget(
              icon: Icons.rate_review,
              title: 'Rate this App',
            ),
            SizedBox(height: 24),
            _SettingItemWidget(
              icon: Icons.logout,
              title: 'Log out',
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingItemWidget extends StatelessWidget {
  final IconData icon;
  final String title;

  const _SettingItemWidget({
    required this.icon,
    required this.title,
  });

  void onPressed() {
    debugPrint('Settings: $title');
  }

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: onPressed,
      style: const ButtonStyle(
        minimumSize: MaterialStatePropertyAll(Size(0, 0)),
      ),
      child: Row(
        children: [
          Icon(icon),
          const SizedBox(width: 16),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          const Icon(Icons.chevron_right),
        ],
      ),
    );
  }
}
