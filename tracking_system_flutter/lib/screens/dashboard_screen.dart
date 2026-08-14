import 'package:flutter/material.dart';
import 'package:tracking_system/theme/app_theme.dart';
import 'package:tracking_system/models/models.dart';
import 'package:tracking_system/widgets/shared_widgets.dart';
import 'package:tracking_system/screens/trip_list_screen.dart';
import 'package:tracking_system/screens/notifications_screen.dart';
import 'package:tracking_system/screens/profile_screen.dart';

// ─── Avatar widget (shared across screens) ─────────────────────────────────────
class AvatarButton extends StatelessWidget {
  const AvatarButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36, height: 36,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white30, width: 2),
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.primaryDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: const Center(
        child: Text('RV', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700)),
      ),
    );
  }
}

// ─── Main Shell (Bottom Nav) ────────────────────────────────────────────────────
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    DashboardScreen(),
    TripListScreen(),
    _VehiclesTab(),
    NotificationsScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(icon: Icons.dashboard_outlined, activeIcon: Icons.dashboard, label: 'Dashboard', index: 0, currentIndex: _currentIndex, onTap: (i) => setState(() => _currentIndex = i)),
              _NavItem(icon: Icons.receipt_long_outlined, activeIcon: Icons.receipt_long, label: 'Trips', index: 1, currentIndex: _currentIndex, onTap: (i) => setState(() => _currentIndex = i)),
              _NavItem(icon: Icons.local_shipping_outlined, activeIcon: Icons.local_shipping, label: 'Vehicles', index: 2, currentIndex: _currentIndex, onTap: (i) => setState(() => _currentIndex = i)),
              _NavItem(icon: Icons.notifications_outlined, activeIcon: Icons.notifications, label: 'Alerts', index: 3, currentIndex: _currentIndex, onTap: (i) => setState(() => _currentIndex = i), badge: 2),
              _NavItem(icon: Icons.person_outline, activeIcon: Icons.person, label: 'Profile', index: 4, currentIndex: _currentIndex, onTap: (i) => setState(() => _currentIndex = i)),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final int index;
  final int currentIndex;
  final ValueChanged<int> onTap;
  final int? badge;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.index,
    required this.currentIndex,
    required this.onTap,
    this.badge,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = index == currentIndex;
    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 60,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(isActive ? activeIcon : icon,
                    color: isActive ? AppColors.primary : AppColors.textSecondary, size: 24),
                if (badge != null && badge! > 0)
                  Positioned(
                    top: -4, right: -8,
                    child: Container(
                      width: 16, height: 16,
                      decoration: const BoxDecoration(color: AppColors.danger, shape: BoxShape.circle),
                      child: Center(child: Text('$badge', style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w700))),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 4),
            Text(label, style: TextStyle(
              fontSize: 10,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
              color: isActive ? AppColors.primary : AppColors.textSecondary,
            )),
          ],
        ),
      ),
    );
  }
}

// ─── Vehicles Tab ──────────────────────────────────────────────────────────────
class _VehiclesTab extends StatelessWidget {
  const _VehiclesTab();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text('Vehicles', style: AppTextStyles.h3),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: SampleData.vehicles.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, i) {
          final v = SampleData.vehicles[i];
          final odo = v.odometer.toString().replaceAllMapped(
            RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},');
          return SectionCard(
            onTap: () {},
            child: Row(
              children: [
                Container(
                  width: 56, height: 56,
                  decoration: BoxDecoration(color: AppColors.primaryLight, borderRadius: BorderRadius.circular(12)),
                  child: const Icon(Icons.local_shipping_outlined, color: AppColors.primary, size: 28),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(v.name, style: AppTextStyles.h4),
                      Text(v.plateNumber, style: AppTextStyles.bodySm),
                      const SizedBox(height: 6),
                      Row(children: [
                        const Icon(Icons.speed, size: 14, color: AppColors.textSecondary),
                        const SizedBox(width: 4),
                        Text('$odo km', style: AppTextStyles.caption),
                        const SizedBox(width: 12),
                        Container(
                          width: 6, height: 6,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: v.maintenanceStatus == MaintenanceStatus.inProgress
                                ? AppColors.warning : AppColors.success,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          v.maintenanceStatus == MaintenanceStatus.inProgress ? 'Maintenance Due' : 'OK',
                          style: AppTextStyles.caption,
                        ),
                      ]),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: AppColors.textLight),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ─── Dashboard Screen ──────────────────────────────────────────────────────────
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final stats = SampleData.dashboardStats;
    final trips = SampleData.trips;
    final activeTrips = trips.where((t) => t.status == TripStatus.active || t.status == TripStatus.pendingAcceptance).toList();
    final pendingTrips = trips.where((t) => t.status == TripStatus.pendingVerification).toList();

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 180,
            floating: false,
            pinned: true,
            backgroundColor: AppColors.bgDark,
            automaticallyImplyLeading: false,
            flexibleSpace: FlexibleSpaceBar(
              background: _DashboardHero(stats: stats),
            ),
            actions: [
              IconButton(
                icon: Stack(clipBehavior: Clip.none, children: [
                  const Icon(Icons.notifications_outlined, color: Colors.white),
                  Positioned(
                    top: -2, right: -2,
                    child: Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppColors.danger, shape: BoxShape.circle)),
                  ),
                ]),
                onPressed: () {},
              ),
              const Padding(
                padding: EdgeInsets.only(right: 12),
                child: AvatarButton(),
              ),
            ],
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _StatsGrid(stats: stats),
                const SizedBox(height: 20),
                Row(children: [
                  Text('Active Trips', style: AppTextStyles.h3),
                  const Spacer(),
                  TextButton(onPressed: () {}, child: const Text('See all')),
                ]),
                const SizedBox(height: 8),
                ...activeTrips.map((t) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _TripCard(trip: t),
                )),
                if (pendingTrips.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Row(children: [
                    Text('Pending Approval', style: AppTextStyles.h3),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(color: AppColors.danger, borderRadius: BorderRadius.circular(20)),
                      child: Text('${pendingTrips.length}', style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700)),
                    ),
                    const Spacer(),
                    TextButton(onPressed: () {}, child: const Text('Review all')),
                  ]),
                  const SizedBox(height: 8),
                  ...pendingTrips.map((t) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _TripCard(trip: t),
                  )),
                ],
                const SizedBox(height: 80),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _DashboardHero extends StatelessWidget {
  final DashboardStats stats;
  const _DashboardHero({required this.stats});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0E1629), Color(0xFF1A3A7A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Good morning,', style: TextStyle(color: Colors.white60, fontSize: 13)),
          const Text('Rey Valir', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700, letterSpacing: -0.3)),
          const SizedBox(height: 12),
          Row(children: [
            _HeroStat(label: 'Active Trips', value: '${stats.activeTrips}', icon: Icons.local_shipping),
            const SizedBox(width: 12),
            _HeroStat(label: 'Vehicles', value: '${stats.vehiclesOnRoad}', icon: Icons.directions_car),
            const SizedBox(width: 12),
            _HeroStat(label: 'Revenue', value: '₱${(stats.totalRevenue / 1000).toStringAsFixed(0)}k', icon: Icons.trending_up),
          ]),
        ],
      ),
    );
  }
}

class _HeroStat extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  const _HeroStat({required this.label, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(children: [
          Icon(icon, color: Colors.white70, size: 16),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
          Text(label, style: const TextStyle(color: Colors.white54, fontSize: 9), textAlign: TextAlign.center),
        ]),
      ),
    );
  }
}

class _StatsGrid extends StatelessWidget {
  final DashboardStats stats;
  const _StatsGrid({required this.stats});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.4,
      children: [
        StatCard(label: 'Completed Trips', value: '${stats.completedTrips}', icon: Icons.check_circle_outline, color: AppColors.success),
        StatCard(label: 'Pending Approval', value: '${stats.pendingApprovals}', icon: Icons.pending_actions, color: AppColors.warning, subtitle: 'Needs review'),
        StatCard(label: 'Maintenance Due', value: '${stats.maintenanceDue}', icon: Icons.build_outlined, color: AppColors.danger, subtitle: 'Urgent'),
        StatCard(label: 'Total Revenue', value: '₱${(stats.totalRevenue / 1000).toStringAsFixed(1)}k', icon: Icons.trending_up, color: AppColors.primary, subtitle: 'This month'),
      ],
    );
  }
}

class _TripCard extends StatelessWidget {
  final TripTicket trip;
  const _TripCard({required this.trip});

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      onTap: () {},
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Text(trip.id, style: AppTextStyles.h4),
            const Spacer(),
            StatusBadge.fromTripStatus(trip.status),
          ]),
          const SizedBox(height: 12),
          Row(children: [
            Expanded(child: Column(children: [
              _RoutePoint(icon: Icons.radio_button_off, label: 'FROM', value: trip.origin),
              Container(width: 1, height: 12, color: AppColors.border, margin: const EdgeInsets.only(left: 7)),
              _RoutePoint(icon: Icons.location_on_outlined, label: 'TO', value: trip.destination),
            ])),
            Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
              Text('₱${trip.estimatedRevenue.toStringAsFixed(0)}',
                  style: AppTextStyles.h3.copyWith(color: AppColors.success)),
              const Text('Est. Revenue', style: AppTextStyles.caption),
            ]),
          ]),
          const SizedBox(height: 10),
          const Divider(),
          const SizedBox(height: 8),
          Row(children: [
            const Icon(Icons.local_shipping_outlined, size: 14, color: AppColors.textSecondary),
            const SizedBox(width: 4),
            Text(trip.vehicleName, style: AppTextStyles.caption),
            const SizedBox(width: 16),
            const Icon(Icons.person_outline, size: 14, color: AppColors.textSecondary),
            const SizedBox(width: 4),
            Text(trip.driverName, style: AppTextStyles.caption),
          ]),
        ],
      ),
    );
  }
}

class _RoutePoint extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _RoutePoint({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Icon(icon, size: 14, color: AppColors.textSecondary),
      const SizedBox(width: 8),
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: AppTextStyles.overline),
        Text(value, style: AppTextStyles.bodySm.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.w500)),
      ]),
    ]);
  }
}