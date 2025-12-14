// lib/app/services/api_routes.dart
abstract class ApiUrl {
  // Base URL
  static const String baseUrl = 'https://gym.sulthon.blue/api/v1';

  // Authentication (Public routes)
  static const String register = '$baseUrl/register';
  static const String login = '$baseUrl/login';
  static const String logout = '$baseUrl/logout';
  static const String profile = '$baseUrl/profile';
  static const String updateProfile = '$baseUrl/profile';
  static const String changePassword = '$baseUrl/change-password';
  static const String verifyEmail = '$baseUrl/verify-email';
  static const String resendVerification = '$baseUrl/resend-verification';

  // User Management
  static const String users = '$baseUrl/users';
  static String userDetail(int id) => '$baseUrl/users/$id';
  static const String usersStatistics = '$baseUrl/users-statistics';
  static const String trainersList = '$baseUrl/trainers-list';

  // Membership (Public routes)
  static const String membershipPackages = '$baseUrl/membership/packages';
  static String membershipPackageDetail(int id) =>
      '$baseUrl/membership/packages/$id';

  // Membership (Protected routes)
  static const String myMemberships = '$baseUrl/membership/my-memberships';
  static const String currentMembership = '$baseUrl/membership/current';
  static const String purchaseMembership = '$baseUrl/membership/purchase';
  static const String allMemberships = '$baseUrl/membership/all';
  static String updateMembershipStatus(int id) =>
      '$baseUrl/membership/status/$id';
  static const String membershipStatistics = '$baseUrl/membership/statistics';
  static const String createMembershipPackage = '$baseUrl/membership/packages';
  static String updateMembershipPackage(int id) =>
      '$baseUrl/membership/packages/$id';
  static String deleteMembershipPackage(int id) =>
      '$baseUrl/membership/packages/$id';

  // Gym Classes (Public routes)
  static const String gymClasses = '$baseUrl/gym-classes';
  static String gymClassDetail(int id) => '$baseUrl/gym-classes/$id';
  static String gymClassSchedules(int classId) =>
      '$baseUrl/gym-classes/$classId/schedules';

  // Gym Classes (Protected routes)
  static const String createGymClass = '$baseUrl/gym-classes';
  static String updateGymClass(int id) => '$baseUrl/gym-classes/$id';
  static String deleteGymClass(int id) => '$baseUrl/gym-classes/$id';
  static String createGymClassSchedule(int classId) =>
      '$baseUrl/gym-classes/$classId/schedules';
  static String updateGymClassSchedule(int classId, int scheduleId) =>
      '$baseUrl/gym-classes/$classId/schedules/$scheduleId';
  static String deleteGymClassSchedule(int classId, int scheduleId) =>
      '$baseUrl/gym-classes/$classId/schedules/$scheduleId';
  static const String bookClass = '$baseUrl/gym-classes/book';
  static String cancelBooking(int attendanceId) =>
      '$baseUrl/gym-classes/bookings/$attendanceId';
  static const String myBookings = '$baseUrl/gym-classes/my-bookings';
  static String markAttendance(int attendanceId) =>
      '$baseUrl/gym-classes/attendance/$attendanceId';
  static const String gymClassesStatistics = '$baseUrl/gym-classes/statistics';

  // Personal Trainers (Public routes)
  static const String trainers = '$baseUrl/trainers';
  static String trainerDetail(int id) => '$baseUrl/trainers/$id';
  static const String trainerPackages = '$baseUrl/trainer-packages';
  static String trainerPackageDetail(int id) => '$baseUrl/trainer-packages/$id';

  // Personal Trainers (Protected routes)
  static const String createTrainer = '$baseUrl/trainers';
  static String updateTrainer(int id) => '$baseUrl/trainers/$id';
  static String deleteTrainer(int id) => '$baseUrl/trainers/$id';
  static String trainerPackagesByTrainer(int trainerId) =>
      '$baseUrl/trainers/$trainerId/packages';
  static const String createTrainerPackage = '$baseUrl/trainers/packages';
  static String updateTrainerPackage(int packageId) =>
      '$baseUrl/trainers/packages/$packageId';
  static String deleteTrainerPackage(int packageId) =>
      '$baseUrl/trainers/packages/$packageId';
  static const String purchaseTrainerPackage =
      '$baseUrl/trainers/packages/purchase';
  static const String trainerAssignments = '$baseUrl/trainers/assignments';
  static String trainerAssignmentsByTrainer(int trainerId) =>
      '$baseUrl/trainers/$trainerId/assignments';
  static String trainerAssignmentDetail(int assignmentId) =>
      '$baseUrl/trainers/assignments/$assignmentId';
  static const String trainerSchedules = '$baseUrl/trainers/schedules';
  static String trainerSchedulesByTrainer(int trainerId) =>
      '$baseUrl/trainers/$trainerId/schedules';
  static const String createTrainerSchedule = '$baseUrl/trainers/schedules';
  static String updateTrainerSchedule(int scheduleId) =>
      '$baseUrl/trainers/schedules/$scheduleId';
  static const String trainersStatistics = '$baseUrl/trainers/statistics';
  static String trainerStatistics(int trainerId) =>
      '$baseUrl/trainers/$trainerId/statistics';

  // Gym Visits
  static const String gymVisits = '$baseUrl/gym-visits';
  static const String myVisits = '$baseUrl/gym-visits/my-visits';
  static String gymVisitDetail(int id) => '$baseUrl/gym-visits/$id';
  static const String checkIn = '$baseUrl/gym-visits/check-in';
  static const String checkOut = '$baseUrl/gym-visits/check-out';
  static const String currentStatus = '$baseUrl/gym-visits/status/current';
  static const String manualEntry = '$baseUrl/gym-visits/manual-entry';
  static String updateGymVisit(int id) => '$baseUrl/gym-visits/$id';
  static String deleteGymVisit(int id) => '$baseUrl/gym-visits/$id';
  static const String gymVisitsStatisticsAdmin =
      '$baseUrl/gym-visits/statistics/admin';
  static const String myGymVisitsStatistics =
      '$baseUrl/gym-visits/statistics/my-stats';

  // Payments & Transactions
  static const String transactions = '$baseUrl/payments/transactions';
  static const String myTransactions = '$baseUrl/payments/my-transactions';
  static String transactionDetail(int id) =>
      '$baseUrl/payments/transactions/$id';
  static const String paymentMembership = '$baseUrl/payments/membership';
  static const String paymentGymClass = '$baseUrl/payments/gym-class';
  static const String paymentTrainerPackage =
      '$baseUrl/payments/trainer-package';
  static String checkPaymentStatus(int transactionId) =>
      '$baseUrl/payments/status/$transactionId';
  static String cancelPayment(int transactionId) =>
      '$baseUrl/payments/cancel/$transactionId';
  static String manualApproval(int transactionId) =>
      '$baseUrl/payments/manual-approval/$transactionId';
  static const String paymentStatistics = '$baseUrl/payments/statistics';

  // Payment Notification (Webhook - Public route)
  static const String paymentNotification = '$baseUrl/payment/notification';
}
