class Analytics {
  final int totalFlights;
  final int totalBookings;
  final int totalPassengers;
  final int totalStaff;
  final double totalRevenue;
  final double monthlyRevenue;
  final double yearlyRevenue;
  final List<RevenueData>? revenueData;
  final List<FlightStats>? flightStats;
  final List<BookingTrend>? bookingTrends;

  Analytics({
    required this.totalFlights,
    required this.totalBookings,
    required this.totalPassengers,
    required this.totalStaff,
    required this.totalRevenue,
    required this.monthlyRevenue,
    required this.yearlyRevenue,
    this.revenueData,
    this.flightStats,
    this.bookingTrends,
  });

  factory Analytics.fromJson(Map<String, dynamic> json) {
    return Analytics(
      totalFlights: json['totalFlights'] ?? 0,
      totalBookings: json['totalBookings'] ?? 0,
      totalPassengers: json['totalPassengers'] ?? 0,
      totalStaff: json['totalStaff'] ?? 0,
      totalRevenue: (json['totalRevenue'] ?? 0).toDouble(),
      monthlyRevenue: (json['monthlyRevenue'] ?? 0).toDouble(),
      yearlyRevenue: (json['yearlyRevenue'] ?? 0).toDouble(),
      revenueData: json['revenueData'] != null
          ? (json['revenueData'] as List)
                .map((e) => RevenueData.fromJson(e))
                .toList()
          : null,
      flightStats: json['flightStats'] != null
          ? (json['flightStats'] as List)
                .map((e) => FlightStats.fromJson(e))
                .toList()
          : null,
      bookingTrends: json['bookingTrends'] != null
          ? (json['bookingTrends'] as List)
                .map((e) => BookingTrend.fromJson(e))
                .toList()
          : null,
    );
  }
}

class RevenueData {
  final String month;
  final double revenue;

  RevenueData({required this.month, required this.revenue});

  factory RevenueData.fromJson(Map<String, dynamic> json) {
    return RevenueData(
      month: json['month'] ?? '',
      revenue: (json['revenue'] ?? 0).toDouble(),
    );
  }
}

class FlightStats {
  final String route;
  final int count;

  FlightStats({required this.route, required this.count});

  factory FlightStats.fromJson(Map<String, dynamic> json) {
    return FlightStats(route: json['route'] ?? '', count: json['count'] ?? 0);
  }
}

class BookingTrend {
  final String date;
  final int bookings;

  BookingTrend({required this.date, required this.bookings});

  factory BookingTrend.fromJson(Map<String, dynamic> json) {
    return BookingTrend(
      date: json['date'] ?? '',
      bookings: json['bookings'] ?? 0,
    );
  }
}
