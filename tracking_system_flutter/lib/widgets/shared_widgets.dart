import 'package:flutter/material.dart';
import 'package:tracking_system/theme/app_theme.dart';
import 'package:tracking_system/models/models.dart';

// ─── Status Badge ──────────────────────────────────────────────────────────────
class StatusBadge extends StatelessWidget {
  final String label;
  final Color bgColor;
  final Color textColor;
  final bool showDot;

  const StatusBadge({
    super.key,
    required this.label,
    required this.bgColor,
    required this.textColor,
    this.showDot = false,
  });

  factory StatusBadge.fromTripStatus(TripStatus status) {
    switch (status) {
      case TripStatus.draft:
        return StatusBadge(label: 'Draft', bgColor: AppColors.divider, textColor: AppColors.textSecondary);
      case TripStatus.pendingAcceptance:
        return StatusBadge(label: 'Pending Acceptance', bgColor: AppColors.badgePending, textColor: AppColors.badgePendingText);
      case TripStatus.pendingVerification:
        return StatusBadge(label: 'Pending Review', bgColor: AppColors.badgePending, textColor: AppColors.badgePendingText);
      case TripStatus.active:
        return StatusBadge(label: 'Active', bgColor: AppColors.badgeActive, textColor: AppColors.badgeActiveText, showDot: true);
      case TripStatus.completed:
        return StatusBadge(label: 'Completed', bgColor: AppColors.badgeCompleted, textColor: AppColors.badgeCompletedText);
      case TripStatus.declined:
        return StatusBadge(label: 'Declined', bgColor: AppColors.badgeDanger, textColor: AppColors.badgeDangerText);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(20)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showDot) ...[
            Container(width: 6, height: 6, decoration: BoxDecoration(shape: BoxShape.circle, color: textColor)),
            const SizedBox(width: 5),
          ],
          Text(label, style: AppTextStyles.label.copyWith(color: textColor)),
        ],
      ),
    );
  }
}

// ─── Section Card ──────────────────────────────────────────────────────────────
class SectionCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final VoidCallback? onTap;

  const SectionCard({super.key, required this.child, this.padding, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: padding ?? const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: child,
      ),
    );
  }
}

// ─── App Top Bar ───────────────────────────────────────────────────────────────
class AppTopBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool showBack;

  const AppTopBar({
    super.key,
    required this.title,
    this.actions,
    this.showBack = true,
  });

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.surface,
      elevation: 0,
      scrolledUnderElevation: 1,
      shadowColor: AppColors.border,
      automaticallyImplyLeading: showBack,
      leading: showBack
          ? IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
              onPressed: () => Navigator.pop(context),
            )
          : null,
      title: Text(title, style: AppTextStyles.h3),
      actions: actions,
    );
  }
}

// ─── Stat Card ─────────────────────────────────────────────────────────────────
class StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final String? subtitle;

  const StatCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 12),
          Text(value, style: AppTextStyles.h2.copyWith(fontSize: 24)),
          const SizedBox(height: 2),
          Text(label, style: AppTextStyles.bodySm),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(subtitle!, style: AppTextStyles.caption.copyWith(color: color)),
          ],
        ],
      ),
    );
  }
}

// ─── Detail Row ────────────────────────────────────────────────────────────────
class DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const DetailRow({super.key, required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Container(
        width: 40, height: 40,
        decoration: BoxDecoration(color: AppColors.bg, borderRadius: BorderRadius.circular(10)),
        child: Icon(icon, size: 18, color: AppColors.textSecondary),
      ),
      const SizedBox(width: 12),
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label.toUpperCase(), style: AppTextStyles.overline),
        const SizedBox(height: 2),
        Text(value, style: AppTextStyles.h4),
      ]),
    ]);
  }
}

// ─── Primary Button ────────────────────────────────────────────────────────────
class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;
  final bool fullWidth;

  const PrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.isLoading = false,
    this.fullWidth = true,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: fullWidth ? double.infinity : null,
      height: 52,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
            : Row(
                mainAxisSize: fullWidth ? MainAxisSize.max : MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[Icon(icon, size: 18), const SizedBox(width: 8)],
                  Text(label),
                ],
              ),
      ),
    );
  }
}

// ─── Ghost Button ──────────────────────────────────────────────────────────────
class GhostButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool fullWidth;
  final Color? color;

  const GhostButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.fullWidth = true,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: fullWidth ? double.infinity : null,
      height: 52,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: color ?? AppColors.primary,
          side: BorderSide(color: color ?? AppColors.primary),
        ),
        child: Row(
          mainAxisSize: fullWidth ? MainAxisSize.max : MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[Icon(icon, size: 18), const SizedBox(width: 8)],
            Text(label),
          ],
        ),
      ),
    );
  }
}

// ─── Timeline Step ─────────────────────────────────────────────────────────────
class TimelineStep extends StatelessWidget {
  final String label;
  final String time;
  final String location;
  final bool isCompleted;
  final bool isLast;

  const TimelineStep({
    super.key,
    required this.label,
    required this.time,
    required this.location,
    required this.isCompleted,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = isCompleted ? AppColors.success : AppColors.primary;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(children: [
          Container(
            width: 20, height: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isCompleted ? color : Colors.white,
              border: Border.all(color: color, width: 2),
            ),
            child: isCompleted ? const Icon(Icons.check, size: 12, color: Colors.white) : null,
          ),
          if (!isLast) Container(width: 2, height: 48, color: AppColors.border),
        ]),
        const SizedBox(width: 14),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 2, bottom: 12),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(label.toUpperCase(), style: AppTextStyles.overline.copyWith(color: color)),
              const SizedBox(height: 2),
              Text(time, style: AppTextStyles.h4),
              const SizedBox(height: 2),
              Text(location, style: AppTextStyles.bodySm),
            ]),
          ),
        ),
      ],
    );
  }
}

// ─── Empty State ───────────────────────────────────────────────────────────────
class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80, height: 80,
              decoration: const BoxDecoration(color: AppColors.primaryLight, shape: BoxShape.circle),
              child: Icon(icon, size: 36, color: AppColors.primary),
            ),
            const SizedBox(height: 20),
            Text(title, style: AppTextStyles.h3, textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text(message, style: AppTextStyles.bodySm, textAlign: TextAlign.center),
            if (actionLabel != null) ...[
              const SizedBox(height: 24),
              PrimaryButton(label: actionLabel!, onPressed: onAction, fullWidth: false),
            ],
          ],
        ),
      ),
    );
  }
}

// ─── Info Row ──────────────────────────────────────────────────────────────────
class InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const InfoRow({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(children: [
        Expanded(child: Text(label, style: AppTextStyles.bodySm)),
        Text(value, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600)),
      ]),
    );
  }
}