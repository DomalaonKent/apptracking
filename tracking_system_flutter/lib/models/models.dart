enum TripStatus { draft, pendingAcceptance, pendingVerification, active, completed, declined }
enum MaintenanceStatus { pending, inProgress, completed }
enum NotificationType { newTrip, maintenance, completed, alert }
enum Priority { low, medium, high }

class TripTicket {
  final String id;
  final String origin;
  final String destination;
  final TripStatus status;
  final String vehicleId;
  final String vehicleName;
  final String driverName;
  final double estimatedRevenue;
  final DateTime pickupDate;
  final DateTime deliveryDate;
  final String cargoType;
  final double cargoWeight;
  final String cargoUnit;
  final int startOdometer;
  final int? endOdometer;
  final String? notes;
  final List<String> documents;
  final List<TripEvent> timeline;

  TripTicket({
    required this.id,
    required this.origin,
    required this.destination,
    required this.status,
    required this.vehicleId,
    required this.vehicleName,
    required this.driverName,
    required this.estimatedRevenue,
    required this.pickupDate,
    required this.deliveryDate,
    required this.cargoType,
    required this.cargoWeight,
    required this.cargoUnit,
    required this.startOdometer,
    this.endOdometer,
    this.notes,
    this.documents = const [],
    this.timeline = const [],
  });

  String get statusLabel {
    switch (status) {
      case TripStatus.draft: return 'Draft';
      case TripStatus.pendingAcceptance: return 'Pending Acceptance';
      case TripStatus.pendingVerification: return 'Pending Verification';
      case TripStatus.active: return 'Active';
      case TripStatus.completed: return 'Completed';
      case TripStatus.declined: return 'Declined';
    }
  }
}

class TripEvent {
  final String label;
  final String description;
  final DateTime timestamp;
  final bool isCompleted;

  TripEvent({
    required this.label,
    required this.description,
    required this.timestamp,
    required this.isCompleted,
  });
}

class Vehicle {
  final String id;
  final String name;
  final String plateNumber;
  final String model;
  final int odometer;
  final MaintenanceStatus maintenanceStatus;
  final DateTime? nextMaintenanceDate;
  final int maintenanceOdometer;
  final String imageUrl;

  Vehicle({
    required this.id,
    required this.name,
    required this.plateNumber,
    required this.model,
    required this.odometer,
    required this.maintenanceStatus,
    this.nextMaintenanceDate,
    required this.maintenanceOdometer,
    this.imageUrl = '',
  });
}

class MaintenanceTask {
  final String id;
  final String title;
  final String description;
  final bool isCompleted;
  final String priority; // 'essential', 'critical', 'maintenance'

  MaintenanceTask({
    required this.id,
    required this.title,
    required this.description,
    required this.isCompleted,
    required this.priority,
  });
}

class AppNotification {
  final String id;
  final NotificationType type;
  final String title;
  final String body;
  final DateTime timestamp;
  final bool isRead;
  final String? actionId;

  AppNotification({
    required this.id,
    required this.type,
    required this.title,
    required this.body,
    required this.timestamp,
    this.isRead = false,
    this.actionId,
  });
}

class DashboardStats {
  final int activeTrips;
  final int completedTrips;
  final int pendingApprovals;
  final double totalRevenue;
  final int vehiclesOnRoad;
  final int maintenanceDue;

  DashboardStats({
    required this.activeTrips,
    required this.completedTrips,
    required this.pendingApprovals,
    required this.totalRevenue,
    required this.vehiclesOnRoad,
    required this.maintenanceDue,
  });
}

// Sample Data
class SampleData {
  static DashboardStats get dashboardStats => DashboardStats(
    activeTrips: 5,
    completedTrips: 42,
    pendingApprovals: 3,
    totalRevenue: 128450.0,
    vehiclesOnRoad: 5,
    maintenanceDue: 2,
  );

  static List<TripTicket> get trips => [
    TripTicket(
      id: 'TT-2024-0005',
      origin: 'Legazpi, Albay',
      destination: 'Bulan, Sorsogon',
      status: TripStatus.pendingAcceptance,
      vehicleId: 'V001',
      vehicleName: 'Freightliner 772',
      driverName: 'Rey Valir',
      estimatedRevenue: 1240.50,
      pickupDate: DateTime.now().add(const Duration(hours: 2)),
      deliveryDate: DateTime.now().add(const Duration(days: 1, hours: 9)),
      cargoType: 'General Goods',
      cargoWeight: 2500,
      cargoUnit: 'kg',
      startOdometer: 44820,
      documents: ['Driver License', 'Vehicle Registration', 'Cargo Manifest', 'Insurance'],
      timeline: [
        TripEvent(label: 'PICKUP', description: 'Legazpi, Albay, Gate 42', timestamp: DateTime.now().add(const Duration(hours: 2)), isCompleted: false),
        TripEvent(label: 'DELIVERY', description: 'Bulan, Sorsogon Dock 12', timestamp: DateTime.now().add(const Duration(days: 1, hours: 9)), isCompleted: false),
      ],
    ),
    TripTicket(
      id: 'TT-2024-0004',
      origin: 'Logistics Hub Alpha - Seattle',
      destination: 'Evergreen Distribution Center',
      status: TripStatus.completed,
      vehicleId: 'V002',
      vehicleName: 'Freightliner Cascadia #882',
      driverName: 'Juan Dela Cruz',
      estimatedRevenue: 3200.00,
      pickupDate: DateTime.now().subtract(const Duration(days: 2)),
      deliveryDate: DateTime.now().subtract(const Duration(days: 1)),
      cargoType: 'Electronics',
      cargoWeight: 1800,
      cargoUnit: 'kg',
      startOdometer: 89000,
      endOdometer: 89142,
    ),
    TripTicket(
      id: 'TT-2024-0003',
      origin: 'Port of Tacoma',
      destination: 'Retail Plaza 4',
      status: TripStatus.pendingVerification,
      vehicleId: 'V001',
      vehicleName: 'Freightliner 772',
      driverName: 'Rey Valir',
      estimatedRevenue: 980.00,
      pickupDate: DateTime.now().add(const Duration(hours: 6)),
      deliveryDate: DateTime.now().add(const Duration(days: 2)),
      cargoType: 'Consumer Goods',
      cargoWeight: 3200,
      cargoUnit: 'kg',
      startOdometer: 44820,
      documents: ['Driver License', 'Vehicle Registration', 'Cargo Manifest', 'Insurance'],
    ),
  ];

  static List<Vehicle> get vehicles => [
    Vehicle(
      id: 'V001',
      name: 'TOYOTA HILUX',
      plateNumber: 'ABC-1234',
      model: 'Freightliner Cascadia',
      odometer: 44820,
      maintenanceStatus: MaintenanceStatus.inProgress,
      maintenanceOdometer: 45000,
      nextMaintenanceDate: DateTime.now().add(const Duration(days: 2)),
    ),
    Vehicle(
      id: 'V002',
      name: 'Freightliner 772',
      plateNumber: 'XYZ-5678',
      model: 'Freightliner Cascadia',
      odometer: 89142,
      maintenanceStatus: MaintenanceStatus.pending,
      maintenanceOdometer: 90000,
    ),
  ];

  static List<AppNotification> get notifications => [
    AppNotification(
      id: 'N001',
      type: NotificationType.newTrip,
      title: 'New trip assigned: TT-2024-0005',
      body: 'Route: Legazpi, Albay → Bulan, Sorsogon. Estimated departure: 14:30 PM today.',
      timestamp: DateTime.now().subtract(const Duration(minutes: 10)),
      actionId: 'TT-2024-0005',
    ),
    AppNotification(
      id: 'N002',
      type: NotificationType.maintenance,
      title: 'Vehicle ABC-1234 maintenance is due soon',
      body: 'Scheduled Odometer: 45,000 mi. Current: 44,820 mi. Please schedule inspection within 48 hours.',
      timestamp: DateTime.now().subtract(const Duration(hours: 1)),
      isRead: false,
    ),
    AppNotification(
      id: 'N003',
      type: NotificationType.completed,
      title: 'Trip TT-2024-0004 Completed',
      body: 'Delivery confirmed at Gateway Logistics Hub.',
      timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 3)),
      isRead: true,
    ),
  ];

  static List<MaintenanceTask> get maintenanceTasks => [
    MaintenanceTask(id: 'MT001', title: 'Brake Pad Inspection', description: 'Check front and rear brake pad thickness', isCompleted: true, priority: 'critical'),
    MaintenanceTask(id: 'MT002', title: 'Brake Fluid Level', description: 'Check and top up brake fluid if needed', isCompleted: true, priority: 'essential'),
    MaintenanceTask(id: 'MT003', title: 'Rotor Condition', description: 'Inspect rotor for wear, grooves, or warping', isCompleted: false, priority: 'critical'),
    MaintenanceTask(id: 'MT004', title: 'Caliper Function', description: 'Verify caliper slides freely and pistons retract', isCompleted: false, priority: 'essential'),
    MaintenanceTask(id: 'MT005', title: 'ABS System Test', description: 'Run diagnostic test on ABS system', isCompleted: false, priority: 'maintenance'),
  ];
}
