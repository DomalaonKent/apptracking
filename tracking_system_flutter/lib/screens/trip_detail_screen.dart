import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/models.dart';
import '../widgets/shared_widgets.dart';
import 'package:intl/intl.dart';

class TripDetailScreen extends StatelessWidget {
  final TripTicket trip;
  const TripDetailScreen({super.key, required this.trip});

  @override
  Widget build(BuildContext context) {
    final df = DateFormat('MMM d, yyyy • h:mm a');
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppTopBar(title: 'Assignment Details'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Identity card
            SectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('TRIP ID', style: AppTextStyles.overline),
                          Text(trip.id, style: AppTextStyles.h2.copyWith(color: AppColors.primary)),
                        ],
                      ),
                      const Spacer(),
                      StatusBadge.fromTripStatus(trip.status),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Map placeholder
                  Container(
                    height: 180,
                    decoration: BoxDecoration(
                      color: const Color(0xFFD6E4F0),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Stack(
                      children: [
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.map_outlined, size: 40, color: Color(0xFF8BAAB8)),
                              const SizedBox(height: 8),
                              Text('Route Map', style: AppTextStyles.bodySm.copyWith(color: const Color(0xFF8BAAB8))),
                            ],
                          ),
                        ),
                        Positioned(
                          bottom: 0, left: 0, right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter, end: Alignment.bottomCenter,
                                colors: [Colors.transparent, Color(0xCC000000)],
                              ),
                              borderRadius: BorderRadius.vertical(bottom: Radius.circular(12)),
                            ),
                            child: Row(
                              children: [
                                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                  const Text('ORIGIN', style: TextStyle(color: Colors.white54, fontSize: 10, letterSpacing: 0.8)),
                                  Text(trip.origin, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                                ]),
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 12),
                                  child: Icon(Icons.arrow_forward, color: Colors.white54, size: 16),
                                ),
                                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                  const Text('DESTINATION', style: TextStyle(color: Colors.white54, fontSize: 10, letterSpacing: 0.8)),
                                  Text(trip.destination, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                                ]),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Bento stats grid
            Row(
              children: [
                Expanded(
                  child: SectionCard(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 36, height: 36,
                          decoration: BoxDecoration(color: AppColors.primaryLight, borderRadius: BorderRadius.circular(8)),
                          child: const Icon(Icons.attach_money, color: AppColors.primary, size: 18),
                        ),
                        const SizedBox(height: 10),
                        Text('Est. Revenue', style: AppTextStyles.caption),
                        Text('₱${trip.estimatedRevenue.toStringAsFixed(2)}', style: AppTextStyles.h3.copyWith(color: AppColors.success)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SectionCard(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 36, height: 36,
                          decoration: BoxDecoration(color: AppColors.primaryLight, borderRadius: BorderRadius.circular(8)),
                          child: const Icon(Icons.local_shipping_outlined, color: AppColors.primary, size: 18),
                        ),
                        const SizedBox(height: 10),
                        Text('Assigned Unit', style: AppTextStyles.caption),
                        Text(trip.vehicleName, style: AppTextStyles.h4, overflow: TextOverflow.ellipsis),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Cargo details
            SectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text('Cargo Details', style: AppTextStyles.h4),
                      const Spacer(),
                      const Icon(Icons.info_outline, size: 18, color: AppColors.textSecondary),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Divider(),
                  const SizedBox(height: 8),
                  InfoRow(label: '📦 Cargo Type', value: trip.cargoType),
                  InfoRow(label: '⚖️ Weight', value: '${trip.cargoWeight.toStringAsFixed(0)} ${trip.cargoUnit}'),
                  InfoRow(label: '🔢 Start Odometer', value: '${trip.startOdometer.toString()} km'),
                  if (trip.endOdometer != null)
                    InfoRow(label: '🏁 End Odometer', value: '${trip.endOdometer} km'),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Schedule overview
            SectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Schedule Overview', style: AppTextStyles.h4),
                  const SizedBox(height: 16),
                  TimelineStep(
                    label: 'PICKUP',
                    time: df.format(trip.pickupDate),
                    location: trip.origin,
                    isCompleted: trip.status == TripStatus.completed,
                  ),
                  TimelineStep(
                    label: 'DELIVERY',
                    time: df.format(trip.deliveryDate),
                    location: trip.destination,
                    isCompleted: false,
                    isLast: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Action buttons
            if (trip.status == TripStatus.pendingAcceptance) ...[
              Row(
                children: [
                  Expanded(child: GhostButton(label: 'Decline', icon: Icons.close, color: AppColors.danger, onPressed: () => _showDeclineDialog(context))),
                  const SizedBox(width: 12),
                  Expanded(child: PrimaryButton(label: 'Accept Trip', icon: Icons.check, onPressed: () => _showAcceptSuccess(context))),
                ],
              ),
            ] else if (trip.status == TripStatus.pendingVerification) ...[
              PrimaryButton(label: 'Review Documents', icon: Icons.description_outlined, onPressed: () {}),
            ] else if (trip.status == TripStatus.active) ...[
              PrimaryButton(label: 'View Live Tracking', icon: Icons.gps_fixed, onPressed: () {}),
            ],
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  void _showDeclineDialog(BuildContext context) {
    String? selectedReason;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(2)))),
              const SizedBox(height: 20),
              Row(
                children: [
                  Container(
                    width: 40, height: 40,
                    decoration: BoxDecoration(color: AppColors.badgeDanger, borderRadius: BorderRadius.circular(10)),
                    child: const Icon(Icons.local_shipping, color: AppColors.danger),
                  ),
                  const SizedBox(width: 12),
                  Text('Decline Trip?', style: AppTextStyles.h3),
                ],
              ),
              const SizedBox(height: 12),
              Text('Are you sure you want to decline trip ${trip.id}? This action will be logged and dispatch will be notified.', style: AppTextStyles.body),
              const SizedBox(height: 20),
              Text('REASON FOR REJECTION', style: AppTextStyles.overline),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: selectedReason,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.border)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                hint: const Text('Select a reason...'),
                items: ['Vehicle unavailable', 'Health reasons', 'Route conflict', 'Prior commitment', 'Other']
                    .map((r) => DropdownMenuItem(value: r, child: Text(r)))
                    .toList(),
                onChanged: (v) => selectedReason = v,
              ),
              const SizedBox(height: 12),
              Text('ADDITIONAL COMMENTS (OPTIONAL)', style: AppTextStyles.overline),
              const SizedBox(height: 8),
              TextField(
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Provide more details for the dispatcher...',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.border)),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(child: PrimaryButton(label: 'Keep Trip', icon: Icons.check, onPressed: () => Navigator.pop(ctx))),
                  const SizedBox(width: 12),
                  Expanded(child: GhostButton(label: 'Confirm Decline', color: AppColors.danger, onPressed: () { Navigator.pop(ctx); Navigator.pop(context); })),
                ],
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  void _showAcceptSuccess(BuildContext context) {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(children: [
          const Icon(Icons.check_circle, color: Colors.white),
          const SizedBox(width: 8),
          Text('Trip ${trip.id} accepted successfully!'),
        ]),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
