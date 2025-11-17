class AppRoutes {
  // Splash & Auth
  static const String splash = '/splash';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';

  // Admin Routes
  static const String adminFlightBookings = '/admin/flights/bookings';
  static const String adminDashboard = '/admin/dashboard';
  static const String adminFlights = '/admin/flights';
  static const String adminFlightDetails = '/admin/flights/details';
  static const String adminAddFlight = '/admin/flights/add';
  static const String adminStaff = '/admin/staff';
  static const String adminAddStaff = '/admin/staff/add';
  static const String adminStaffHierarchy = '/admin/staff/hierarchy';
  static const String adminTerminals = '/admin/terminals';
  static const String adminBilling = '/admin/billing';
  static const String adminInvoices = '/admin/invoices';
  static const String adminRevenue = '/admin/revenue';
  static const String adminPaymentReports = '/admin/payment-reports';
  static const String adminAnalytics = '/admin/analytics';
  static const String adminFlightAnalytics = '/admin/analytics/flights';
  static const String adminBookingAnalytics = '/admin/analytics/bookings';
  static const String adminSettings = '/admin/settings';
  static const String adminUserManagement = '/admin/user-management';

  // User Routes
  static const String userDashboard = '/user/dashboard';
  static const String flightSearch = '/user/flights/search';
  static const String flightList = '/user/flights/list';
  static const String flightDetails = '/user/flights/details';
  static const String seatSelection = '/user/flights/seat-selection';
  static const String userBookings = '/user/bookings';
  static const String bookingDetails = '/user/bookings/details';
  static const String bookingConfirmation = '/user/bookings/confirmation';
  static const String ticket = '/user/bookings/ticket';
  static const String payment = '/user/payment';
  static const String paymentHistory = '/user/payment/history';
  static const String profile = '/user/profile';
  static const String settings = '/user/settings';
}
