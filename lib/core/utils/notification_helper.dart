import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../../data/models/booking.dart';
import '../../data/models/flight.dart';

class NotificationHelper {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  // Initialize notifications
  static Future<void> initialize() async {
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );
  }

  static void _onNotificationTapped(NotificationResponse response) {
    // Handle notification tap
    print('Notification tapped: ${response.payload}');
  }

  // Request permissions (iOS)
  static Future<bool> requestPermissions() async {
    final result = await _notifications
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
    return result ?? false;
  }

  // Show booking confirmation notification
  static Future<void> showBookingConfirmation(Booking booking) async {
    const androidDetails = AndroidNotificationDetails(
      'booking_channel',
      'Booking Notifications',
      channelDescription: 'Notifications for booking confirmations',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    const iosDetails = DarwinNotificationDetails();

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.show(
      booking.id ?? 0,
      'Booking Confirmed! ✈️',
      'PNR: ${booking.pnr ?? booking.id} - Seat: ${booking.seatNumber}',
      details,
      payload: 'booking_${booking.id}',
    );
  }

  // Show flight reminder notification
  static Future<void> showFlightReminder(Flight flight, Booking booking) async {
    const androidDetails = AndroidNotificationDetails(
      'flight_channel',
      'Flight Reminders',
      channelDescription: 'Reminders for upcoming flights',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    const iosDetails = DarwinNotificationDetails();

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.show(
      flight.id ?? 0,
      'Flight Reminder 🛫',
      'Flight ${flight.number} to ${flight.destination} - Seat: ${booking.seatNumber}',
      details,
      payload: 'flight_${flight.id}',
    );
  }

  // Schedule flight reminder (24 hours before)
  static Future<void> scheduleFlightReminder(
    Flight flight,
    Booking booking,
  ) async {
    final scheduledTime = flight.departureTime.subtract(Duration(hours: 24));

    if (scheduledTime.isAfter(DateTime.now())) {
      // Note: Scheduled notifications require additional setup
      // This is a placeholder for the implementation
      print('Flight reminder scheduled for: $scheduledTime');
    }
  }

  // Show payment success notification
  static Future<void> showPaymentSuccess(double amount) async {
    const androidDetails = AndroidNotificationDetails(
      'payment_channel',
      'Payment Notifications',
      channelDescription: 'Notifications for payment status',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    const iosDetails = DarwinNotificationDetails();

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      'Payment Successful! 💳',
      'Amount: ₹${amount.toStringAsFixed(2)}',
      details,
      payload: 'payment_success',
    );
  }

  // Show flight status update notification
  static Future<void> showFlightStatusUpdate(
    String flightNumber,
    String status,
  ) async {
    const androidDetails = AndroidNotificationDetails(
      'status_channel',
      'Flight Status Updates',
      channelDescription: 'Updates about flight status changes',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    const iosDetails = DarwinNotificationDetails();

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      'Flight Status Update',
      'Flight $flightNumber is now $status',
      details,
      payload: 'status_update',
    );
  }

  // Cancel a notification
  static Future<void> cancelNotification(int id) async {
    await _notifications.cancel(id);
  }

  // Cancel all notifications
  static Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }
}
