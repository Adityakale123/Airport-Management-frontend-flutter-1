class AppConstants {
  // App Info
  static const String appName = 'Airport Management System';
  static const String appTagline = 'Manage flights, bookings, and more';

  // User Roles
  static const String roleAdmin = 'ADMIN';
  static const String roleUser = 'USER';

  // Flight Status
  static const String flightScheduled = 'SCHEDULED';
  static const String flightBoarding = 'BOARDING';
  static const String flightDeparted = 'DEPARTED';
  static const String flightArrived = 'ARRIVED';
  static const String flightDelayed = 'DELAYED';
  static const String flightCancelled = 'CANCELLED';

  // Booking Status
  static const String bookingConfirmed = 'CONFIRMED';
  static const String bookingCheckedIn = 'CHECKED_IN';
  static const String bookingBoarded = 'BOARDED';
  static const String bookingCancelled = 'CANCELLED';
  static const String bookingPending = 'PENDING';

  // Payment Status
  static const String paymentPending = 'PENDING';
  static const String paymentCompleted = 'COMPLETED';
  static const String paymentFailed = 'FAILED';
  static const String paymentRefunded = 'REFUNDED';

  // Staff Roles
  static const String staffPilot = 'PILOT';
  static const String staffCabinCrew = 'CABIN_CREW';
  static const String staffGroundStaff = 'GROUND_STAFF';
  static const String staffEngineer = 'ENGINEER';
  static const String staffSecurity = 'SECURITY';
  static const String staffManager = 'MANAGER';

  // Seat Classes
  static const String classEconomy = 'ECONOMY';
  static const String classBusiness = 'BUSINESS';
  static const String classFirstClass = 'FIRST_CLASS';

  // Error Messages
  static const String errorGeneric = 'Something went wrong. Please try again.';
  static const String errorNetwork =
      'Network error. Please check your connection.';
  static const String errorUnauthorized = 'Unauthorized. Please login again.';
  static const String errorNotFound = 'Resource not found.';
  static const String errorValidation = 'Please check your input.';

  // Success Messages
  static const String successLogin = 'Login successful!';
  static const String successRegister = 'Registration successful!';
  static const String successBooking = 'Booking confirmed!';
  static const String successPayment = 'Payment completed successfully!';

  // Validation
  static const int minPasswordLength = 6;
  static const int maxPasswordLength = 20;
  static const int minPhoneLength = 10;
  static const int maxPhoneLength = 15;
}
