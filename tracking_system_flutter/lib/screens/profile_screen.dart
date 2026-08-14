import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/shared_widgets.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: AppColors.bgDark,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF0E1629), Color(0xFF1A3A7A)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),
                    Container(
                      width: 80, height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white30, width: 3),
                        gradient: const LinearGradient(
                          colors: [AppColors.primary, AppColors.primaryDark],
                        ),
                      ),
                      child: const Center(
                        child: Text('RV', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w700)),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text('Rey Valir', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text('Fleet Driver', style: TextStyle(color: Colors.white70, fontSize: 12)),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Stats row
                SectionCard(
                  child: Row(
                    children: [
                      _StatItem(label: 'Total Trips', value: '47'),
                      _divider(),
                      _StatItem(label: 'Completed', value: '42'),
                      _divider(),
                      _StatItem(label: 'Rating', value: '4.9 ⭐'),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                Text('Account', style: AppTextStyles.overline),
                const SizedBox(height: 8),
                SectionCard(
                  child: Column(
                    children: [
                      _MenuItem(icon: Icons.person_outline, label: 'Edit Profile', onTap: () {}),
                      const Divider(),
                      _MenuItem(icon: Icons.security, label: 'Account Security', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AccountSecurityScreen()))),
                      const Divider(),
                      _MenuItem(icon: Icons.notifications_outlined, label: 'Notification Settings', onTap: () {}),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                Text('Support', style: AppTextStyles.overline),
                const SizedBox(height: 8),
                SectionCard(
                  child: Column(
                    children: [
                      _MenuItem(icon: Icons.help_outline, label: 'Help Center & FAQ', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const HelpScreen()))),
                      const Divider(),
                      _MenuItem(icon: Icons.report_problem_outlined, label: 'Report Issue', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ReportIssueScreen()))),
                      const Divider(),
                      _MenuItem(icon: Icons.qr_code_scanner, label: 'Scan QR Code', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const QRScanScreen()))),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                SectionCard(
                  child: _MenuItem(
                    icon: Icons.logout,
                    label: 'Sign Out',
                    textColor: AppColors.danger,
                    iconColor: AppColors.danger,
                    onTap: () {},
                  ),
                ),
                const SizedBox(height: 80),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() => Container(width: 1, height: 40, color: AppColors.border);
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  const _StatItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(value, style: AppTextStyles.h3),
          const SizedBox(height: 2),
          Text(label, style: AppTextStyles.caption, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? textColor;
  final Color? iconColor;

  const _MenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.textColor,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Container(
              width: 36, height: 36,
              decoration: BoxDecoration(
                color: (iconColor ?? AppColors.primary).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, size: 18, color: iconColor ?? AppColors.primary),
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(label, style: AppTextStyles.body.copyWith(color: textColor))),
            const Icon(Icons.chevron_right, color: AppColors.textLight),
          ],
        ),
      ),
    );
  }
}

// ─── Account Security Screen ───────────────────────────────────────────────────
class AccountSecurityScreen extends StatefulWidget {
  const AccountSecurityScreen({super.key});

  @override
  State<AccountSecurityScreen> createState() => _AccountSecurityScreenState();
}

class _AccountSecurityScreenState extends State<AccountSecurityScreen> {
  bool _twoFAEnabled = true;
  bool _biometricEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppTopBar(title: 'Account Security'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Security status hero
            SectionCard(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.shield, color: AppColors.success, size: 16),
                            const SizedBox(width: 6),
                            Text('Security Status', style: AppTextStyles.overline.copyWith(color: AppColors.success)),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text('Your account is safe', style: AppTextStyles.h3),
                        const SizedBox(height: 4),
                        Text('Last audit: 2 days ago. No suspicious activity detected.', style: AppTextStyles.bodySm),
                      ],
                    ),
                  ),
                  const Icon(Icons.lock, size: 64, color: Color(0xFFD0E8FF)),
                ],
              ),
            ),
            const SizedBox(height: 20),

            Text('ACCESS CONTROL', style: AppTextStyles.overline),
            const SizedBox(height: 8),
            SectionCard(
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Row(
                        children: [
                          Container(width: 40, height: 40, decoration: BoxDecoration(color: AppColors.primaryLight, borderRadius: BorderRadius.circular(10)), child: const Icon(Icons.lock_outline, color: AppColors.primary)),
                          const SizedBox(width: 12),
                          const Expanded(child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Change Password', style: AppTextStyles.h4),
                              Text('Update your login credentials', style: AppTextStyles.bodySm),
                            ],
                          )),
                          const Icon(Icons.chevron_right, color: AppColors.textLight),
                        ],
                      ),
                    ),
                  ),
                  const Divider(),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Row(
                      children: [
                        Container(width: 40, height: 40, decoration: BoxDecoration(color: AppColors.primaryLight, borderRadius: BorderRadius.circular(10)), child: const Icon(Icons.phonelink_lock_outlined, color: AppColors.primary)),
                        const SizedBox(width: 12),
                        const Expanded(child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Two-Factor Authentication', style: AppTextStyles.h4),
                            Text('Secure your login with SMS or app', style: AppTextStyles.bodySm),
                          ],
                        )),
                        Switch(value: _twoFAEnabled, onChanged: (v) => setState(() => _twoFAEnabled = v), activeColor: AppColors.primary),
                      ],
                    ),
                  ),
                  const Divider(),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Row(
                      children: [
                        Container(width: 40, height: 40, decoration: BoxDecoration(color: AppColors.primaryLight, borderRadius: BorderRadius.circular(10)), child: const Icon(Icons.fingerprint, color: AppColors.primary)),
                        const SizedBox(width: 12),
                        const Expanded(child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Biometric Login', style: AppTextStyles.h4),
                            Text('Use fingerprint or face ID', style: AppTextStyles.bodySm),
                          ],
                        )),
                        Switch(value: _biometricEnabled, onChanged: (v) => setState(() => _biometricEnabled = v), activeColor: AppColors.primary),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            Text('RECENT ACTIVITY', style: AppTextStyles.overline),
            const SizedBox(height: 8),
            SectionCard(
              child: Column(
                children: [
                  _ActivityItem(icon: Icons.smartphone, title: 'Mobile Login', subtitle: 'Philippines • Active now', isCurrent: true),
                  const Divider(),
                  _ActivityItem(icon: Icons.computer, title: 'Web Login', subtitle: 'Manila, PH • Oct 24, 14:20', isCurrent: false),
                ],
              ),
            ),
            const SizedBox(height: 20),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF7E6),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFFFD07A)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.info_outline, color: AppColors.warning, size: 18),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Safety Tip', style: AppTextStyles.h4.copyWith(color: AppColors.warning)),
                        const SizedBox(height: 4),
                        const Text('Fleet drivers are common targets for phishing. We will never ask for your password over text or phone. Always use the app for authentication.', style: AppTextStyles.bodySm),
                      ],
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
}

class _ActivityItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isCurrent;
  const _ActivityItem({required this.icon, required this.title, required this.subtitle, required this.isCurrent});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(color: AppColors.bg, borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: AppColors.textSecondary, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(title, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600)),
                    if (isCurrent) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(color: AppColors.badgeActive, borderRadius: BorderRadius.circular(10)),
                        child: Text('CURRENT', style: AppTextStyles.label.copyWith(color: AppColors.badgeActiveText)),
                      ),
                    ],
                  ],
                ),
                Text(subtitle, style: AppTextStyles.bodySm),
              ],
            ),
          ),
          if (!isCurrent)
            TextButton(onPressed: () {}, child: const Text('Sign out', style: TextStyle(color: AppColors.danger, fontSize: 12))),
        ],
      ),
    );
  }
}

// ─── Help Screen ───────────────────────────────────────────────────────────────
class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final faqs = [
      ('How do I report a vehicle maintenance issue?', 'Go to Profile > Report Issue, select your vehicle, describe the problem and attach photos.'),
      ('What should I do if the app crashes during a trip?', 'Force-close and reopen the app. Your trip data is saved automatically. Contact support if the issue persists.'),
      ('How are my earnings calculated?', 'Earnings are based on the estimated revenue per trip plus bonuses for on-time delivery.'),
      ('Can I change my assigned route mid-trip?', 'Route changes must be approved by dispatch. Contact your dispatcher via the in-app chat.'),
    ];

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppTopBar(title: 'Help Center'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search
            TextField(
              decoration: InputDecoration(
                hintText: 'How can we help?',
                prefixIcon: const Icon(Icons.search, size: 18),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.border)),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.border)),
              ),
            ),
            const SizedBox(height: 20),

            Text('Categories', style: AppTextStyles.h3),
            const SizedBox(height: 12),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.8,
              children: const [
                _HelpCategory(icon: Icons.receipt_long, label: 'Trips'),
                _HelpCategory(icon: Icons.local_shipping, label: 'Report Issues'),
                _HelpCategory(icon: Icons.build, label: 'Maintenance'),
                _HelpCategory(icon: Icons.person, label: 'Account'),
              ],
            ),
            const SizedBox(height: 20),

            Text('Common Questions', style: AppTextStyles.h3),
            const SizedBox(height: 12),
            ...faqs.map((faq) => _FAQItem(question: faq.$1, answer: faq.$2)),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class _HelpCategory extends StatelessWidget {
  final IconData icon;
  final String label;
  const _HelpCategory({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      onTap: () {},
      child: Row(
        children: [
          Container(width: 40, height: 40, decoration: BoxDecoration(color: AppColors.primaryLight, borderRadius: BorderRadius.circular(10)), child: Icon(icon, color: AppColors.primary, size: 20)),
          const SizedBox(width: 10),
          Text(label, style: AppTextStyles.h4),
        ],
      ),
    );
  }
}

class _FAQItem extends StatefulWidget {
  final String question;
  final String answer;
  const _FAQItem({required this.question, required this.answer});

  @override
  State<_FAQItem> createState() => _FAQItemState();
}

class _FAQItemState extends State<_FAQItem> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: SectionCard(
        onTap: () => setState(() => _expanded = !_expanded),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(child: Text(widget.question, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w500))),
                Icon(_expanded ? Icons.expand_less : Icons.expand_more, color: AppColors.textSecondary),
              ],
            ),
            if (_expanded) ...[
              const SizedBox(height: 10),
              const Divider(),
              const SizedBox(height: 8),
              Text(widget.answer, style: AppTextStyles.bodySm),
            ],
          ],
        ),
      ),
    );
  }
}

// ─── Report Issue Screen ───────────────────────────────────────────────────────
class ReportIssueScreen extends StatefulWidget {
  const ReportIssueScreen({super.key});

  @override
  State<ReportIssueScreen> createState() => _ReportIssueScreenState();
}

class _ReportIssueScreenState extends State<ReportIssueScreen> {
  int _priorityIndex = 1;
  String? _category;
  final _priorities = ['LOW', 'MEDIUM', 'HIGH'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppTopBar(title: 'Report Issue'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Vehicle card
            SectionCard(
              child: Row(
                children: [
                  Container(
                    width: 80, height: 80,
                    decoration: BoxDecoration(color: AppColors.bg, borderRadius: BorderRadius.circular(12)),
                    child: const Icon(Icons.local_shipping, size: 40, color: AppColors.textSecondary),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Freightliner Cascadia', style: AppTextStyles.h4),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(color: AppColors.bg, borderRadius: BorderRadius.circular(6), border: Border.all(color: AppColors.border)),
                            child: const Text('ABC-1234', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                          ),
                          const SizedBox(width: 8),
                          Text('Active', style: AppTextStyles.caption.copyWith(color: AppColors.success)),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            Text('Issue Category', style: AppTextStyles.h4),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _category,
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.border)),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.border)),
              ),
              hint: const Text('Select category...'),
              items: ['Engine & Transmission', 'Brakes', 'Tires & Wheels', 'Electrical', 'Body & Frame', 'Other']
                  .map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
              onChanged: (v) => setState(() => _category = v),
            ),
            const SizedBox(height: 16),

            Text('Priority Level', style: AppTextStyles.h4),
            const SizedBox(height: 8),
            Row(
              children: List.generate(3, (i) {
                final isActive = _priorityIndex == i;
                final color = [AppColors.success, AppColors.warning, AppColors.danger][i];
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(right: i < 2 ? 8 : 0),
                    child: GestureDetector(
                      onTap: () => setState(() => _priorityIndex = i),
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                          color: isActive ? color.withOpacity(0.12) : AppColors.bg,
                          border: Border.all(color: isActive ? color : AppColors.border, width: isActive ? 2 : 1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(child: Text(_priorities[i], style: TextStyle(fontWeight: FontWeight.w700, color: isActive ? color : AppColors.textSecondary, fontSize: 13))),
                      ),
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 16),

            Text('Description', style: AppTextStyles.h4),
            const SizedBox(height: 8),
            TextField(
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'Describe the issue in detail...',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.border)),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.border)),
              ),
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Text('Evidence / Photos', style: AppTextStyles.h4),
                const Spacer(),
                Text('0/5', style: AppTextStyles.caption),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    width: 100, height: 100,
                    decoration: BoxDecoration(
                      color: AppColors.bg,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.border, style: BorderStyle.solid),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.add_a_photo_outlined, color: AppColors.textSecondary, size: 28),
                        const SizedBox(height: 6),
                        Text('Add Photo', style: AppTextStyles.caption),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            PrimaryButton(label: 'Submit Report', icon: Icons.send_outlined, onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Report submitted successfully!'),
                  backgroundColor: AppColors.success,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }),
            const SizedBox(height: 8),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.lock, size: 12, color: AppColors.textSecondary),
                  const SizedBox(width: 4),
                  Text('Your report is secure and will be reviewed', style: AppTextStyles.caption),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

// ─── QR Scan Screen ────────────────────────────────────────────────────────────
class QRScanScreen extends StatelessWidget {
  const QRScanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('Scan QR Code', style: TextStyle(color: Colors.white)),
      ),
      body: Stack(
        children: [
          Center(
            child: Container(
              width: 280, height: 280,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white24, width: 1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Stack(
                children: [
                  // Corner indicators
                  ..._corners(),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.qr_code_scanner, color: Colors.white30, size: 80),
                        const SizedBox(height: 12),
                        Text('Point camera at QR code', style: AppTextStyles.body.copyWith(color: Colors.white54), textAlign: TextAlign.center),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 60,
            left: 32, right: 32,
            child: Column(
              children: [
                Text('Align QR code within the frame', style: AppTextStyles.bodySm.copyWith(color: Colors.white70), textAlign: TextAlign.center),
                const SizedBox(height: 8),
                Text('Or enter code manually', style: AppTextStyles.body.copyWith(color: AppColors.primary, decoration: TextDecoration.underline), textAlign: TextAlign.center),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _corners() {
    const c = AppColors.primary;
    const size = 30.0;
    const w = 3.0;
    return [
      Positioned(top: 0, left: 0, child: Container(width: size, height: w, color: c)),
      Positioned(top: 0, left: 0, child: Container(width: w, height: size, color: c)),
      Positioned(top: 0, right: 0, child: Container(width: size, height: w, color: c)),
      Positioned(top: 0, right: 0, child: Container(width: w, height: size, color: c)),
      Positioned(bottom: 0, left: 0, child: Container(width: size, height: w, color: c)),
      Positioned(bottom: 0, left: 0, child: Container(width: w, height: size, color: c)),
      Positioned(bottom: 0, right: 0, child: Container(width: size, height: w, color: c)),
      Positioned(bottom: 0, right: 0, child: Container(width: w, height: size, color: c)),
    ];
  }
}
