import 'package:flutter/material.dart';
import 'app_routes.dart';
import '../../presentation/screens/splash/splash_screen.dart';
import '../../presentation/screens/auth/login_screen.dart';
import '../../presentation/screens/auth/register_screen.dart';
import '../../presentation/screens/auth/forgot_password_screen.dart';
import '../../presentation/screens/admin/admin_dashboard.dart';
import '../../presentation/screens/admin/flights/flights_management_screen.dart'
    as adminFlightsScreen;
import '../../presentation/screens/admin/flights/add_flight_screen.dart'
    as addFlightScreen;
import '../../presentation/screens/admin/flights/flight_details_screen.dart'
    as adminFlightDetails;
import '../../presentation/screens/admin/flights/bookings/flight_bookings_screen.dart'; // ✅ ADD THIS IMPORT
import '../../presentation/screens/admin/staff/staff_management_screen.dart';
import '../../presentation/screens/admin/staff/add_staff_screen.dart';
import '../../presentation/screens/admin/staff/staff_hierarchy_screen.dart';
import '../../presentation/screens/admin/terminals/terminals_management_screen.dart';
import '../../presentation/screens/admin/billing/billing_dashboard.dart';
import '../../presentation/screens/admin/billing/invoices_screen.dart';
import '../../presentation/screens/admin/billing/revenue_analytics_screen.dart';
import '../../presentation/screens/admin/billing/payment_reports_screen.dart';
import '../../presentation/screens/admin/analytics/analytics_dashboard.dart';
import '../../presentation/screens/admin/analytics/flight_analytics_screen.dart';
import '../../presentation/screens/admin/analytics/booking_analytics_screen.dart';
import '../../presentation/screens/admin/settings/system_settings_screen.dart';
import '../../presentation/screens/admin/settings/user_management_screen.dart';
import '../../presentation/screens/user/user_dashboard.dart';
import '../../presentation/screens/user/flights/flight_search_screen.dart';
import '../../presentation/screens/user/flights/flight_list_screen.dart';
import '../../presentation/screens/user/flights/flight_details_screen.dart'
    as userFlightDetails;
import '../../presentation/screens/user/flights/seat_selection_screen.dart';
import '../../presentation/screens/user/bookings/user_bookings_screen.dart';
import '../../presentation/screens/user/bookings/booking_details_screen.dart';
import '../../presentation/screens/user/bookings/booking_confirmation_screen.dart';
import '../../presentation/screens/user/bookings/ticket_screen.dart';
import '../../presentation/screens/user/payment/payment_screen.dart';
import '../../presentation/screens/user/payment/payment_history_screen.dart';
import '../../presentation/screens/user/profile/profile_screen.dart';
import '../../presentation/screens/user/profile/settings_screen.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      // Splash & Auth
      case AppRoutes.splash:
        return MaterialPageRoute(builder: (_) => SplashScreen());
      case AppRoutes.login:
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case AppRoutes.register:
        return MaterialPageRoute(builder: (_) => RegisterScreen());
      case AppRoutes.forgotPassword:
        return MaterialPageRoute(builder: (_) => ForgotPasswordScreen());

      // Admin Routes
      case AppRoutes.adminDashboard:
        return MaterialPageRoute(builder: (_) => AdminDashboard());
      case AppRoutes.adminFlights:
        return MaterialPageRoute(
            builder: (_) => adminFlightsScreen.FlightsManagementScreen());
      case AppRoutes.adminAddFlight:
        return MaterialPageRoute(
            builder: (_) => addFlightScreen.AddFlightScreen());
      case AppRoutes.adminFlightDetails:
        return MaterialPageRoute(
          builder: (_) => adminFlightDetails.AdminFlightDetailsScreen(
              flightId: args as int),
        );

      // ✅ ADD THIS CASE
      case AppRoutes.adminFlightBookings:
        final bookingArgs = args as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => FlightBookingsScreen(
            flightId: bookingArgs['flightId'],
            flightNumber: bookingArgs['flightNumber'],
          ),
        );

      case AppRoutes.adminStaff:
        return MaterialPageRoute(builder: (_) => StaffManagementScreen());
      case AppRoutes.adminAddStaff:
        return MaterialPageRoute(builder: (_) => AddStaffScreen());
      case AppRoutes.adminStaffHierarchy:
        return MaterialPageRoute(builder: (_) => StaffHierarchyScreen());
      case AppRoutes.adminTerminals:
        return MaterialPageRoute(builder: (_) => TerminalsManagementScreen());
      case AppRoutes.adminBilling:
        return MaterialPageRoute(builder: (_) => BillingDashboard());
      case AppRoutes.adminInvoices:
        return MaterialPageRoute(builder: (_) => InvoicesScreen());
      case AppRoutes.adminRevenue:
        return MaterialPageRoute(builder: (_) => RevenueAnalyticsScreen());
      case AppRoutes.adminPaymentReports:
        return MaterialPageRoute(builder: (_) => PaymentReportsScreen());
      case AppRoutes.adminAnalytics:
        return MaterialPageRoute(builder: (_) => AnalyticsDashboard());
      case AppRoutes.adminFlightAnalytics:
        return MaterialPageRoute(builder: (_) => FlightAnalyticsScreen());
      case AppRoutes.adminBookingAnalytics:
        return MaterialPageRoute(builder: (_) => BookingAnalyticsScreen());
      case AppRoutes.adminSettings:
        return MaterialPageRoute(builder: (_) => SystemSettingsScreen());
      case AppRoutes.adminUserManagement:
        return MaterialPageRoute(builder: (_) => UserManagementScreen());

      // User Routes
      case AppRoutes.userDashboard:
        return MaterialPageRoute(builder: (_) => UserDashboard());
      case AppRoutes.flightSearch:
        return MaterialPageRoute(builder: (_) => FlightSearchScreen());
      case AppRoutes.flightList:
        return MaterialPageRoute(builder: (_) => FlightListScreen());
      case AppRoutes.flightDetails:
        return MaterialPageRoute(
          builder: (_) =>
              userFlightDetails.UserFlightDetailsScreen(flightId: args as int),
        );
      case AppRoutes.seatSelection:
        return MaterialPageRoute(
          builder: (_) => SeatSelectionScreen(flightId: args as int),
        );
      case AppRoutes.userBookings:
        return MaterialPageRoute(builder: (_) => UserBookingsScreen());
      case AppRoutes.bookingDetails:
        return MaterialPageRoute(
          builder: (_) => BookingDetailsScreen(bookingId: args as int),
        );
      case AppRoutes.bookingConfirmation:
        return MaterialPageRoute(
          builder: (_) => BookingConfirmationScreen(bookingId: args as int),
        );
      case AppRoutes.ticket:
        return MaterialPageRoute(
          builder: (_) => TicketScreen(bookingId: args as int),
        );
      case AppRoutes.payment:
        return MaterialPageRoute(
          builder: (_) => PaymentScreen(bookingId: args as int),
        );
      case AppRoutes.paymentHistory:
        return MaterialPageRoute(builder: (_) => PaymentHistoryScreen());
      case AppRoutes.profile:
        return MaterialPageRoute(builder: (_) => ProfileScreen());
      case AppRoutes.settings:
        return MaterialPageRoute(builder: (_) => UserSettingsScreen());

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}

// import 'package:flutter/material.dart';
// import 'app_routes.dart';
// import '../../presentation/screens/splash/splash_screen.dart';
// import '../../presentation/screens/auth/login_screen.dart';
// import '../../presentation/screens/auth/register_screen.dart';
// import '../../presentation/screens/auth/forgot_password_screen.dart';
// import '../../presentation/screens/admin/admin_dashboard.dart';
// import '../../presentation/screens/admin/flights/flights_management_screen.dart'
//     as adminFlightsScreen;
// import '../../presentation/screens/admin/flights/add_flight_screen.dart'
//     as addFlightScreen;
// import '../../presentation/screens/admin/flights/flight_details_screen.dart'
//     as adminFlightDetails;
// import '../../presentation/screens/admin/staff/staff_management_screen.dart';
// import '../../presentation/screens/admin/staff/add_staff_screen.dart';
// import '../../presentation/screens/admin/staff/staff_hierarchy_screen.dart';
// import '../../presentation/screens/admin/terminals/terminals_management_screen.dart';
// import '../../presentation/screens/admin/billing/billing_dashboard.dart';
// import '../../presentation/screens/admin/billing/invoices_screen.dart';
// import '../../presentation/screens/admin/billing/revenue_analytics_screen.dart';
// import '../../presentation/screens/admin/billing/payment_reports_screen.dart';
// import '../../presentation/screens/admin/analytics/analytics_dashboard.dart';
// import '../../presentation/screens/admin/analytics/flight_analytics_screen.dart';
// import '../../presentation/screens/admin/analytics/booking_analytics_screen.dart';
// import '../../presentation/screens/admin/settings/system_settings_screen.dart';
// import '../../presentation/screens/admin/settings/user_management_screen.dart';
// import '../../presentation/screens/user/user_dashboard.dart';
// import '../../presentation/screens/user/flights/flight_search_screen.dart';
// import '../../presentation/screens/user/flights/flight_list_screen.dart';
// import '../../presentation/screens/user/flights/flight_details_screen.dart'
//     as userFlightDetails;
// import '../../presentation/screens/user/flights/seat_selection_screen.dart';
// import '../../presentation/screens/user/bookings/user_bookings_screen.dart';
// import '../../presentation/screens/user/bookings/booking_details_screen.dart';
// import '../../presentation/screens/user/bookings/booking_confirmation_screen.dart';
// import '../../presentation/screens/user/bookings/ticket_screen.dart';
// import '../../presentation/screens/user/payment/payment_screen.dart';
// import '../../presentation/screens/user/payment/payment_history_screen.dart';
// import '../../presentation/screens/user/profile/profile_screen.dart';
// import '../../presentation/screens/user/profile/settings_screen.dart';

// class RouteGenerator {
//   static Route<dynamic> generateRoute(RouteSettings settings) {
//     final args = settings.arguments;

//     switch (settings.name) {
//       // Splash & Auth
//       case AppRoutes.splash:
//         return MaterialPageRoute(builder: (_) => SplashScreen());
//       case AppRoutes.login:
//         return MaterialPageRoute(builder: (_) => LoginScreen());
//       case AppRoutes.register:
//         return MaterialPageRoute(builder: (_) => RegisterScreen());
//       case AppRoutes.forgotPassword:
//         return MaterialPageRoute(builder: (_) => ForgotPasswordScreen());

//       // Admin Routes
//       case AppRoutes.adminDashboard:
//         return MaterialPageRoute(builder: (_) => AdminDashboard());
//       case AppRoutes.adminFlights:
//         return MaterialPageRoute(
//             builder: (_) => adminFlightsScreen.FlightsManagementScreen());
//       case AppRoutes.adminAddFlight:
//         return MaterialPageRoute(
//             builder: (_) => addFlightScreen.AddFlightScreen());
//       case AppRoutes.adminFlightDetails:
//         return MaterialPageRoute(
//           builder: (_) => adminFlightDetails.AdminFlightDetailsScreen(
//               flightId: args as int),
//         );

//       case AppRoutes.adminFlightBookings:
//         final bookingArgs = args as Map<String, dynamic>;
//         return MaterialPageRoute(
//           builder: (_) => FlightBookingsScreen(
//             flightId: bookingArgs['flightId'],
//             flightNumber: bookingArgs['flightNumber'],
//           ),
//         );
//       case AppRoutes.adminStaff:
//         return MaterialPageRoute(builder: (_) => StaffManagementScreen());
//       case AppRoutes.adminAddStaff:
//         return MaterialPageRoute(builder: (_) => AddStaffScreen());
//       case AppRoutes.adminStaffHierarchy:
//         return MaterialPageRoute(builder: (_) => StaffHierarchyScreen());
//       case AppRoutes.adminTerminals:
//         return MaterialPageRoute(builder: (_) => TerminalsManagementScreen());
//       case AppRoutes.adminBilling:
//         return MaterialPageRoute(builder: (_) => BillingDashboard());
//       case AppRoutes.adminInvoices:
//         return MaterialPageRoute(builder: (_) => InvoicesScreen());
//       case AppRoutes.adminRevenue:
//         return MaterialPageRoute(builder: (_) => RevenueAnalyticsScreen());
//       case AppRoutes.adminPaymentReports:
//         return MaterialPageRoute(builder: (_) => PaymentReportsScreen());
//       case AppRoutes.adminAnalytics:
//         return MaterialPageRoute(builder: (_) => AnalyticsDashboard());
//       case AppRoutes.adminFlightAnalytics:
//         return MaterialPageRoute(builder: (_) => FlightAnalyticsScreen());
//       case AppRoutes.adminBookingAnalytics:
//         return MaterialPageRoute(builder: (_) => BookingAnalyticsScreen());
//       case AppRoutes.adminSettings:
//         return MaterialPageRoute(builder: (_) => SystemSettingsScreen());
//       case AppRoutes.adminUserManagement:
//         return MaterialPageRoute(builder: (_) => UserManagementScreen());

//       // User Routes
//       case AppRoutes.userDashboard:
//         return MaterialPageRoute(builder: (_) => UserDashboard());
//       case AppRoutes.flightSearch:
//         return MaterialPageRoute(builder: (_) => FlightSearchScreen());
//       case AppRoutes.flightList:
//         return MaterialPageRoute(builder: (_) => FlightListScreen());
//       case AppRoutes.flightDetails:
//         return MaterialPageRoute(
//           builder: (_) =>
//               userFlightDetails.UserFlightDetailsScreen(flightId: args as int),
//         );
//       case AppRoutes.seatSelection:
//         return MaterialPageRoute(
//           builder: (_) => SeatSelectionScreen(flightId: args as int),
//         );
//       case AppRoutes.userBookings:
//         return MaterialPageRoute(builder: (_) => UserBookingsScreen());
//       case AppRoutes.bookingDetails:
//         return MaterialPageRoute(
//           builder: (_) => BookingDetailsScreen(bookingId: args as int),
//         );
//       case AppRoutes.bookingConfirmation:
//         return MaterialPageRoute(
//           builder: (_) => BookingConfirmationScreen(bookingId: args as int),
//         );
//       case AppRoutes.ticket:
//         return MaterialPageRoute(
//           builder: (_) => TicketScreen(bookingId: args as int),
//         );
//       case AppRoutes.payment:
//         return MaterialPageRoute(
//           builder: (_) => PaymentScreen(bookingId: args as int),
//         );
//       case AppRoutes.paymentHistory:
//         return MaterialPageRoute(builder: (_) => PaymentHistoryScreen());
//       case AppRoutes.profile:
//         return MaterialPageRoute(builder: (_) => ProfileScreen());
//       case AppRoutes.settings:
//         return MaterialPageRoute(builder: (_) => UserSettingsScreen());

//       default:
//         return MaterialPageRoute(
//           builder: (_) => Scaffold(
//             body: Center(child: Text('No route defined for ${settings.name}')),
//           ),
//         );
//     }
//   }
// }
