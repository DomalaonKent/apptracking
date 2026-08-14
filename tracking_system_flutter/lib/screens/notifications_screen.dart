import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/models.dart';
import '../widgets/shared_widgets.dart';
import 'package:intl/intl.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  int _filterIndex = 0;
  final List<String> _filters = ['All', 'Unread', 'Trips'];

  @override
  Widget build(BuildContext context) {
    final notifications = SampleData.notifications;
    final unread = notifications.where((n) => !n.isRead).toList();
    final today = notifications;
    final yesterday = <AppNotification>[];

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppTopBar(
        title: 'Notifications',
        showBack: false,
        actions: [
          TextButton(onPressed: () {}, child: const Text('Mark all read')),
        ],
      ),
      body: Column(
        children: [
          // Filter tabs
          Container(
            color: AppColors.surface,
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
            child: Row(
              children: List.generate(_filters.length, (i) {
                final isActive = _filterIndex == i;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: GestureDetector(
                    onTap: () => setState(() => _filterIndex = i),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: isActive ? AppColors.primary : AppColors.bg,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        _filters[i],
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: isActive ? Colors.white : AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text('TODAY', style: AppTextStyles.overline),
                ),
                ...today.map((n) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _NotificationCard(notification: n),
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  final AppNotification notification;
  const _NotificationCard({required this.notification});

  @override
  Widget build(BuildContext context) {
    final isUnread = !notification.isRead;
    final timeStr = _formatTime(notification.timestamp);

    final (iconData, iconColor, bgColor) = switch (notification.type) {
      NotificationType.newTrip => (Icons.local_shipping_outlined, AppColors.primary, AppColors.primaryLight),
      NotificationType.maintenance => (Icons.build_outlined, AppColors.warning, const Color(0xFFFFF7E6)),
      NotificationType.completed => (Icons.check_circle_outline, AppColors.success, AppColors.badgeActive),
      NotificationType.alert => (Icons.warning_amber_outlined, AppColors.danger, AppColors.badgeDanger),
    };

    return SectionCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(12)),
            child: Icon(iconData, color: iconColor, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(timeStr, style: AppTextStyles.caption),
                    const Spacer(),
                    if (isUnread)
                      Container(width: 8, height: 8, decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.primary)),
                  ],
                ),
                const SizedBox(height: 4),
                Text(notification.title, style: AppTextStyles.h4.copyWith(fontSize: 14)),
                const SizedBox(height: 4),
                Text(notification.body, style: AppTextStyles.bodySm),
                if (notification.type == NotificationType.newTrip) ...[
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(child: GhostButton(label: 'View Details', onPressed: () {})),
                      const SizedBox(width: 8),
                      Expanded(child: PrimaryButton(label: 'Accept', onPressed: () {})),
                    ],
                  ),
                ],
                if (notification.type == NotificationType.maintenance) ...[
                  const SizedBox(height: 10),
                  GhostButton(label: 'Schedule Maintenance', onPressed: () {}),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return DateFormat('MMM d').format(time);
  }
}
