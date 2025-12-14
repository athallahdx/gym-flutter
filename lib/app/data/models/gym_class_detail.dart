import 'package:gym_app/app/data/models/gym_class.dart';
import 'package:gym_app/app/data/models/gym_class_schedule.dart';

/// Composite model for GymClass with its schedules
/// Used when fetching a single class with detailed information
class GymClassDetail {
  final GymClass gymClass;
  final List<GymClassSchedule> schedules;

  GymClassDetail({
    required this.gymClass,
    required this.schedules,
  });

  factory GymClassDetail.fromJson(Map<String, dynamic> json) {
    // Parse the base gym class
    final gymClass = GymClass.fromJson(json);

    // Parse schedules if present
    List<GymClassSchedule> schedules = [];
    if (json['gym_class_schedules'] != null) {
      schedules = (json['gym_class_schedules'] as List)
          .map((schedule) => GymClassSchedule.fromJson(schedule))
          .toList();
    }

    return GymClassDetail(
      gymClass: gymClass,
      schedules: schedules,
    );
  }

  // Helper getters
  bool get hasSchedules => schedules.isNotEmpty;
  int get upcomingSchedulesCount => schedules.length;
  bool get hasAvailableSlots => schedules.any((s) => s.hasAvailableSlots);
  
  // Quick access to gym class properties
  int get id => gymClass.id;
  String get code => gymClass.code;
  String get name => gymClass.name;
  String get slug => gymClass.slug;
  String get description => gymClass.description;
  int get price => gymClass.price;
  String get images => gymClass.images;
  String get status => gymClass.status;
  DateTime get createdAt => gymClass.createdAt;
  DateTime get updatedAt => gymClass.updatedAt;
}
