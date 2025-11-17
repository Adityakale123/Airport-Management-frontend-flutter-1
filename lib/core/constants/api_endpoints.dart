class ApiEndpoints {
  // Base
  static const String base = '/api';

  // ------------------ AUTH ------------------
  static const String login = '/user/auth/login';
  static const String register = '/user/auth/register';
  static const String logout = '/user/auth/logout';
  static const String refreshToken = '/user/auth/refresh';
  static const String forgotPassword = '/user/auth/forgot-password';
  static const String resetPassword = '/user/auth/reset-password';

  // ------------------ USER PROFILE ------------------
  static const String userProfile = '/user/profile';
  static const String updateProfile = '/user/profile/update';
  static const String changePassword = '/user/profile/change-password';

  // NEW: Document Upload / Download
  static const String uploadDocument = '/user/profile/upload-document';
  static const String getDocument = '/user/profile/document';

  // ------------------ USER BOOKINGS ------------------
  static const String userBookings = '/user/bookings';
  static String userBookingById(int id) => '/user/bookings/$id';
  static const String createBooking = '/user/bookings';
  static String updateBooking(int id) => '/user/bookings/$id';
  static String deleteBooking(int id) => '/user/bookings/$id';

  // ------------------ USER PASSENGERS ------------------
  static const String userPassengers = '/user/passengers';
  static String userPassengerById(int id) => '/user/passengers/$id';

  // ------------------ ADMIN FLIGHTS ------------------
  static const String adminFlights = '/admin/flights';
  static String adminFlightById(int id) => '/admin/flights/$id';
  static const String createFlight = '/admin/flights';
  static String updateFlight(int id) => '/admin/flights/$id';
  static String deleteFlight(int id) => '/admin/flights/$id';
  // Add this in the ADMIN section after adminFlights
  static const String adminBookings = '/admin/bookings';
  static String adminBookingsByFlight(int flightId) =>
      '/admin/bookings/flight/$flightId';

  // ------------------ ADMIN STAFF ------------------
  static const String adminStaff = '/admin/staff';
  static String adminStaffById(int id) => '/admin/staff/$id';
  static const String createStaff = '/admin/staff';
  static String updateStaff(int id) => '/admin/staff/$id';
  static String deleteStaff(int id) => '/admin/staff/$id';

  // ------------------ ADMIN TERMINALS ------------------
  static const String adminTerminals = '/admin/terminals';
  static String adminTerminalById(int id) => '/admin/terminals/$id';
  static const String createTerminal = '/admin/terminals';
  static String updateTerminal(int id) => '/admin/terminals/$id';
  static String deleteTerminal(int id) => '/admin/terminals/$id';

  // ------------------ ANALYTICS ------------------
  static const String analytics = '/admin/analytics';
  static const String flightAnalytics = '/admin/analytics/flights';
  static const String bookingAnalytics = '/admin/analytics/bookings';
  static const String revenueAnalytics = '/admin/analytics/revenue';
  static const String paymentAnalytics = '/admin/analytics/payments'; // NEW

  // ------------------ USER FLIGHTS ------------------
  static String userFlightById(int id) => '/flights/$id';

  // ------------------ SEARCH ------------------
  static const String searchFlights = '/flights/search';
  static const String availableSeats = '/flights/seats/available';

  // ------------------ PAYMENTS ------------------
  static const String processPayment = '/payments/process';
  static const String paymentHistory = '/payments/history';
  static String paymentDetails(int id) => '/payments/$id';

  // ------------------ BILLING ------------------
  static const String billingData = '/admin/billing';
  static const String billingInvoices = '/admin/billing/invoices';
  static const String billingPayments = '/admin/billing/payments';
}

// class ApiEndpoints {
//   // Base
//   static const String base = '/api';

//   // Auth Endpoints
//   static const String login = '/user/auth/login';
//   static const String register = '/user/auth/register';
//   static const String logout = '/user/auth/logout';
//   static const String refreshToken = '/user/auth/refresh';
//   static const String forgotPassword = '/user/auth/forgot-password';
//   static const String resetPassword = '/user/auth/reset-password';

//   // User Endpoints
//   static const String userProfile = '/user/profile';
//   static const String updateProfile = '/user/profile/update';
//   static const String changePassword = '/user/profile/change-password';

//   // User Booking Endpoints
//   static const String userBookings = '/user/bookings';
//   static String userBookingById(int id) => '/user/bookings/$id';
//   static const String createBooking = '/user/bookings';
//   static String updateBooking(int id) => '/user/bookings/$id';
//   static String deleteBooking(int id) => '/user/bookings/$id';

//   // User Passenger Endpoints
//   static const String userPassengers = '/user/passengers';
//   static String userPassengerById(int id) => '/user/passengers/$id';

//   // Admin Flight Endpoints
//   static const String adminFlights = '/admin/flights';
//   static String adminFlightById(int id) => '/admin/flights/$id';
//   static const String createFlight = '/admin/flights';
//   static String updateFlight(int id) => '/admin/flights/$id';
//   static String deleteFlight(int id) => '/admin/flights/$id';

//   // Admin Staff Endpoints
//   static const String adminStaff = '/admin/staff';
//   static String adminStaffById(int id) => '/admin/staff/$id';
//   static const String createStaff = '/admin/staff';
//   static String updateStaff(int id) => '/admin/staff/$id';
//   static String deleteStaff(int id) => '/admin/staff/$id';

//   // Admin Terminal Endpoints
//   static const String adminTerminals = '/admin/terminals';
//   static String adminTerminalById(int id) => '/admin/terminals/$id';
//   static const String createTerminal = '/admin/terminals';
//   static String updateTerminal(int id) => '/admin/terminals/$id';
//   static String deleteTerminal(int id) => '/admin/terminals/$id';

//   // Analytics Endpoints
//   static const String analytics = '/admin/analytics';
//   static const String flightAnalytics = '/admin/analytics/flights';
//   static const String bookingAnalytics = '/admin/analytics/bookings';
//   static const String revenueAnalytics = '/admin/analytics/revenue';

//   // User Flight Endpoints
//   static String userFlightById(int id) => '/flights/$id';

//   // Search Endpoints
//   static const String searchFlights = '/flights/search';
//   static const String availableSeats = '/flights/seats/available';

//   // Payment Endpoints
//   static const String processPayment = '/payments/process';
//   static const String paymentHistory = '/payments/history';
//   static String paymentDetails(int id) => '/payments/$id';
// }
