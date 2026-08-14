import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/models.dart';
import '../widgets/shared_widgets.dart';
import 'trip_detail_screen.dart';

class TripListScreen extends StatefulWidget {
  const TripListScreen({super.key});

  @override
  State<TripListScreen> createState() => _TripListScreenState();
}

class _TripListScreenState extends State<TripListScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _searchQuery = '';

  final List<String> _tabs = ['All', 'Ongoing', 'Approval', 'Completed', 'Draft'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<TripTicket> _filterTrips(List<TripTicket> trips, int tabIndex) {
    List<TripTicket> filtered = trips;
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((t) =>
        t.id.toLowerCase().contains(_searchQuery.toLowerCase()) ||
        t.origin.toLowerCase().contains(_searchQuery.toLowerCase()) ||
        t.destination.toLowerCase().contains(_searchQuery.toLowerCase())
      ).toList();
    }
    switch (tabIndex) {
      case 1: return filtered.where((t) => t.status == TripStatus.active || t.status == TripStatus.pendingAcceptance).toList();
      case 2: return filtered.where((t) => t.status == TripStatus.pendingVerification).toList();
      case 3: return filtered.where((t) => t.status == TripStatus.completed).toList();
      case 4: return filtered.where((t) => t.status == TripStatus.draft).toList();
      default: return filtered;
    }
  }

  @override
  Widget build(BuildContext context) {
    final allTrips = SampleData.trips;

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(120),
        child: Container(
          color: AppColors.surface,
          child: SafeArea(
            bottom: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                  child: Row(
                    children: [
                      Text('Trip Management', style: AppTextStyles.h2),
                      const Spacer(),
                      TextButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.history, size: 16),
                        label: const Text('History'),
                      ),
                      const SizedBox(width: 4),
                      ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.add, size: 16),
                        label: const Text('New Ticket'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          textStyle: const TextStyle(fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                  child: SizedBox(
                    height: 44,
                    child: TextField(
                      onChanged: (v) => setState(() => _searchQuery = v),
                      decoration: InputDecoration(
                        hintText: 'Search trip ID or location...',
                        prefixIcon: const Icon(Icons.search, size: 18, color: AppColors.textSecondary),
                        contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.border)),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.border)),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.primary, width: 1.5)),
                        filled: true,
                        fillColor: AppColors.bg,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            color: AppColors.surface,
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              labelColor: AppColors.primary,
              unselectedLabelColor: AppColors.textSecondary,
              indicatorColor: AppColors.primary,
              indicatorSize: TabBarIndicatorSize.label,
              labelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
              unselectedLabelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
              tabs: _tabs.map((t) => Tab(text: t)).toList(),
              onTap: (_) => setState(() {}),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: List.generate(_tabs.length, (i) {
                final filtered = _filterTrips(allTrips, i);
                if (filtered.isEmpty) {
                  return EmptyState(
                    icon: Icons.receipt_long_outlined,
                    title: 'No trips found',
                    message: 'There are no trips matching your current filter.',
                    actionLabel: 'Create New Trip',
                    onAction: () {},
                  );
                }
                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: filtered.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, j) => _TripListCard(
                    trip: filtered[j],
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => TripDetailScreen(trip: filtered[j]))),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

class _TripListCard extends StatelessWidget {
  final TripTicket trip;
  final VoidCallback onTap;
  const _TripListCard({required this.trip, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('TRIP ID', style: AppTextStyles.overline),
                  Text(trip.id, style: AppTextStyles.h3.copyWith(color: AppColors.primary)),
                ],
              ),
              const Spacer(),
              StatusBadge.fromTripStatus(trip.status),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.bg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    const Icon(Icons.radio_button_off, size: 14, color: AppColors.success),
                    const SizedBox(width: 8),
                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('ORIGIN', style: AppTextStyles.overline),
                      Text(trip.origin, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w500)),
                    ]),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 6),
                  child: SizedBox(height: 8, child: VerticalDivider(width: 1, thickness: 1, color: AppColors.border)),
                ),
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 14, color: AppColors.danger),
                    const SizedBox(width: 8),
                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('DESTINATION', style: AppTextStyles.overline),
                      Text(trip.destination, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w500)),
                    ]),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _chipInfo(Icons.local_shipping_outlined, trip.vehicleName),
              const SizedBox(width: 12),
              _chipInfo(Icons.person_outline, trip.driverName),
              const Spacer(),
              Text('₱${trip.estimatedRevenue.toStringAsFixed(2)}', style: AppTextStyles.h4.copyWith(color: AppColors.success)),
            ],
          ),
          if (trip.status == TripStatus.pendingAcceptance) ...[
            const SizedBox(height: 12),
            const Divider(),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: GhostButton(
                    label: 'Decline',
                    icon: Icons.close,
                    color: AppColors.danger,
                    onPressed: () {},
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: PrimaryButton(label: 'Accept Trip', icon: Icons.check, onPressed: () {}),
                ),
              ],
            ),
          ],
          if (trip.status == TripStatus.pendingVerification) ...[
            const SizedBox(height: 12),
            const Divider(),
            const SizedBox(height: 8),
            PrimaryButton(label: 'Review Documents', icon: Icons.description_outlined, onPressed: () {}),
          ],
        ],
      ),
    );
  }

  Widget _chipInfo(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: AppColors.textSecondary),
        const SizedBox(width: 4),
        Text(text, style: AppTextStyles.caption),
      ],
    );
  }
}
