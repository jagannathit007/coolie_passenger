class CreateBookingData {
  final String bookingId;
  final int otp;
  final String status;
  final String assignedCollie;

  CreateBookingData({required this.bookingId, required this.otp, required this.status, required this.assignedCollie});

  factory CreateBookingData.fromJson(Map<String, dynamic> json) => CreateBookingData(
    bookingId: json['bookingId'] ?? '',
    otp: int.tryParse(json['otp'].toString()) ?? 0, // Handle string or int
    status: json['status'] ?? '',
    assignedCollie: json['assignedCollie'] ?? '',
  );

  Map<String, dynamic> toJson() => {'bookingId': bookingId, 'otp': otp, 'status': status, 'assignedCollie': assignedCollie};
}

class Booking {
  final PickupDetails pickupDetails;
  final Timestamp timestamp;
  final Fare fare;
  final String id;
  final String passengerId;
  final String collieId;
  final int otp;
  final String status;
  final String destination;
  final dynamic rating;
  final String feedback;
  final String complaint;
  final bool isDeleted;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String bookingId;
  final String? assignedCollie;

  Booking({
    required this.pickupDetails,
    required this.timestamp,
    required this.fare,
    required this.id,
    required this.passengerId,
    required this.collieId,
    required this.otp,
    required this.status,
    required this.destination,
    this.rating,
    required this.feedback,
    required this.complaint,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
    required this.bookingId,
    this.assignedCollie,
  });

  factory Booking.fromJson(Map<String, dynamic> json) => Booking(
    pickupDetails: PickupDetails.fromJson(json['pickupDetails'] ?? {}),
    timestamp: Timestamp.fromJson(json['timestamp'] ?? {}),
    fare: Fare.fromJson(json['fare'] ?? {}),
    id: json['_id'] ?? '',
    passengerId: json['passengerId'] ?? '',
    collieId: json['collieId'] ?? '',
    otp: int.tryParse(json['otp'].toString()) ?? 0, // Handle string or int
    status: json['status'] ?? '',
    destination: json['destination'] ?? '',
    rating: json['rating'],
    feedback: json['feedback'] ?? '',
    complaint: json['complaint'] ?? '',
    isDeleted: json['isDeleted'] ?? false,
    createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
    updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
    bookingId: json['bookingId'] ?? '',
    assignedCollie: json['assignedCollie'],
  );

  Map<String, dynamic> toJson() => {
    'pickupDetails': pickupDetails.toJson(),
    'timestamp': timestamp.toJson(),
    'fare': fare.toJson(),
    '_id': id,
    'passengerId': passengerId,
    'collieId': collieId,
    'otp': otp,
    'status': status,
    'destination': destination,
    'rating': rating,
    'feedback': feedback,
    'complaint': complaint,
    'isDeleted': isDeleted,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
    'bookingId': bookingId,
    'assignedCollie': assignedCollie,
  };
}

class PickupDetails {
  final int station;
  final int coachNumber;
  final String description;

  PickupDetails({required this.station, required this.coachNumber, required this.description});

  factory PickupDetails.fromJson(Map<String, dynamic> json) => PickupDetails(
    station: int.tryParse(json['station'].toString()) ?? 0, // Handle string or int
    coachNumber: int.tryParse(json['coachNumber'].toString()) ?? 0, // Handle string or int
    description: json['description'] ?? '',
  );

  Map<String, dynamic> toJson() => {'station': station, 'coachNumber': coachNumber, 'description': description};
}

class Timestamp {
  final String bookedAt;
  final String? acceptedAt;
  final String? pickupTime;
  final String? completedAt;

  Timestamp({required this.bookedAt, this.acceptedAt, this.pickupTime, this.completedAt});

  factory Timestamp.fromJson(Map<String, dynamic> json) =>
      Timestamp(bookedAt: json['bookedAt'] ?? '', acceptedAt: json['acceptedAt'], pickupTime: json['pickupTime'], completedAt: json['completedAt']);

  Map<String, dynamic> toJson() => {'bookedAt': bookedAt, 'acceptedAt': acceptedAt, 'pickupTime': pickupTime, 'completedAt': completedAt};
}

class Fare {
  final int baseFare;
  final int waitingTime;
  final int waitingCharges;
  final int totalFare;

  Fare({required this.baseFare, required this.waitingTime, required this.waitingCharges, required this.totalFare});

  factory Fare.fromJson(Map<String, dynamic> json) => Fare(
    baseFare: int.tryParse(json['baseFare'].toString()) ?? 0, // Handle string or int
    waitingTime: int.tryParse(json['waitingTime'].toString()) ?? 0, // Handle string or int
    waitingCharges: int.tryParse(json['waitingCharges'].toString()) ?? 0, // Handle string or int
    totalFare: int.tryParse(json['totalFare'].toString()) ?? 0, // Handle string or int
  );

  Map<String, dynamic> toJson() => {'baseFare': baseFare, 'waitingTime': waitingTime, 'waitingCharges': waitingCharges, 'totalFare': totalFare};
}

class PaginationData {
  final List<Booking> docs;
  final int totalDocs;
  final int limit;
  final int totalPages;
  final int page;
  final bool hasPrevPage;
  final bool hasNextPage;
  final int? prevPage;
  final int? nextPage;

  PaginationData({
    required this.docs,
    required this.totalDocs,
    required this.limit,
    required this.totalPages,
    required this.page,
    required this.hasPrevPage,
    required this.hasNextPage,
    this.prevPage,
    this.nextPage,
  });

  factory PaginationData.fromJson(Map<String, dynamic> json) => PaginationData(
    docs: (json['docs'] as List<dynamic>?)?.map((e) => Booking.fromJson(e as Map<String, dynamic>)).toList() ?? [],
    totalDocs: int.tryParse(json['totalDocs'].toString()) ?? 0, // Handle string or int
    limit: int.tryParse(json['limit'].toString()) ?? 0, // Handle string or int
    totalPages: int.tryParse(json['totalPages'].toString()) ?? 0, // Handle string or int
    page: int.tryParse(json['page'].toString()) ?? 0, // Handle string or int
    hasPrevPage: json['hasPrevPage'] ?? false,
    hasNextPage: json['hasNextPage'] ?? false,
    prevPage: int.tryParse(json['prevPage'].toString()), // Handle string or null
    nextPage: int.tryParse(json['nextPage'].toString()), // Handle string or null
  );

  Map<String, dynamic> toJson() => {
    'docs': docs.map((e) => e.toJson()).toList(),
    'totalDocs': totalDocs,
    'limit': limit,
    'totalPages': totalPages,
    'page': page,
    'hasPrevPage': hasPrevPage,
    'hasNextPage': hasNextPage,
    'prevPage': prevPage,
    'nextPage': nextPage,
  };
}
