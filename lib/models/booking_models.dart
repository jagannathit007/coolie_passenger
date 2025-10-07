class CreateBookingData {
  final String bookingId;
  final int otp;
  final String status;
  final String? assignedCollie;

  CreateBookingData({required this.bookingId, required this.otp, required this.status, this.assignedCollie});

  factory CreateBookingData.fromJson(Map<String, dynamic> json) => CreateBookingData(
    bookingId: json['bookingId'] ?? '',
    otp: int.tryParse(json['otp'].toString()) ?? 0,
    status: json['status'] ?? '',
    assignedCollie: json['assignedCollie'],
  );

  Map<String, dynamic> toJson() => {'bookingId': bookingId, 'otp': otp, 'status': status, if (assignedCollie != null) 'assignedCollie': assignedCollie};
}

class Booking {
  final PickupDetails pickupDetails;
  final Timestamp timestamp;
  final Fare fare;
  final String? id;
  final String? passengerId;
  final String? collieId;
  final int otp;
  final String status;
  final String destination;
  final dynamic rating;
  final String? feedback;
  final String? complaint;
  final bool? isDeleted;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String bookingId;
  final String? assignedCollie;
  final dynamic collie;

  Booking({
    required this.pickupDetails,
    required this.timestamp,
    required this.fare,
    this.id,
    this.passengerId,
    this.collieId,
    required this.otp,
    required this.status,
    required this.destination,
    this.rating,
    this.feedback,
    this.complaint,
    this.isDeleted,
    this.createdAt,
    this.updatedAt,
    required this.bookingId,
    this.assignedCollie,
    this.collie,
  });

  factory Booking.fromJson(Map<String, dynamic> json) => Booking(
    pickupDetails: PickupDetails.fromJson(json['pickupDetails'] ?? {}),
    timestamp: Timestamp.fromJson(json['timestamp'] ?? {}),
    fare: Fare.fromJson(json['fare'] ?? {}),
    id: json['_id'],
    passengerId: json['passengerId'],
    collieId: json['collieId'],
    otp: int.tryParse(json['otp'].toString()) ?? 0,
    status: json['status'] ?? '',
    destination: json['destination'] ?? '',
    rating: json['rating'],
    feedback: json['feedback'],
    complaint: json['complaint'],
    isDeleted: json['isDeleted'],
    createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt']) : null,
    updatedAt: json['updatedAt'] != null ? DateTime.tryParse(json['updatedAt']) : null,
    bookingId: json['bookingId'] ?? '',
    assignedCollie: json['assignedCollie'],
    collie: json['collie'],
  );

  Map<String, dynamic> toJson() => {
    'pickupDetails': pickupDetails.toJson(),
    'timestamp': timestamp.toJson(),
    'fare': fare.toJson(),
    if (id != null) '_id': id,
    if (passengerId != null) 'passengerId': passengerId,
    if (collieId != null) 'collieId': collieId,
    'otp': otp,
    'status': status,
    'destination': destination,
    if (rating != null) 'rating': rating,
    if (feedback != null) 'feedback': feedback,
    if (complaint != null) 'complaint': complaint,
    if (isDeleted != null) 'isDeleted': isDeleted,
    if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
    if (updatedAt != null) 'updatedAt': updatedAt!.toIso8601String(),
    'bookingId': bookingId,
    if (assignedCollie != null) 'assignedCollie': assignedCollie,
    if (collie != null) 'collie': collie,
  };
}

class PickupDetails {
  final String? station;
  final String? coachNumber;
  final String? description;

  PickupDetails({this.station, this.coachNumber, this.description});

  factory PickupDetails.fromJson(Map<String, dynamic> json) =>
      PickupDetails(station: json['station']?.toString(), coachNumber: json['coachNumber'], description: json['description']);

  Map<String, dynamic> toJson() => {
    if (station != null) 'station': station,
    if (coachNumber != null) 'coachNumber': coachNumber,
    if (description != null) 'description': description,
  };
}

class Timestamp {
  final String bookedAt;
  final String? acceptedAt;
  final String? pickupTime;
  final String? completedAt;

  Timestamp({required this.bookedAt, this.acceptedAt, this.pickupTime, this.completedAt});

  factory Timestamp.fromJson(Map<String, dynamic> json) =>
      Timestamp(bookedAt: json['bookedAt'] ?? '', acceptedAt: json['acceptedAt'], pickupTime: json['pickupTime'], completedAt: json['completedAt']);

  Map<String, dynamic> toJson() => {
    'bookedAt': bookedAt,
    if (acceptedAt != null) 'acceptedAt': acceptedAt,
    if (pickupTime != null) 'pickupTime': pickupTime,
    if (completedAt != null) 'completedAt': completedAt,
  };
}

class Fare {
  final int baseFare;
  final int waitingTime;
  final int waitingCharges;
  final int totalFare;

  Fare({required this.baseFare, required this.waitingTime, required this.waitingCharges, required this.totalFare});

  factory Fare.fromJson(Map<String, dynamic> json) => Fare(
    baseFare: int.tryParse(json['baseFare']?.toString() ?? '0') ?? 0,
    waitingTime: int.tryParse(json['waitingTime']?.toString() ?? '0') ?? 0,
    waitingCharges: int.tryParse(json['waitingCharges']?.toString() ?? '0') ?? 0,
    totalFare: int.tryParse(json['totalFare']?.toString() ?? '0') ?? 0,
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
    totalDocs: int.tryParse(json['totalDocs']?.toString() ?? '0') ?? 0,
    limit: int.tryParse(json['totalDocs']?.toString() ?? '0') ?? 0,
    totalPages: int.tryParse(json['totalPages']?.toString() ?? '0') ?? 0,
    page: int.tryParse(json['page']?.toString() ?? '0') ?? 0,
    hasPrevPage: json['hasPrevPage'] ?? false,
    hasNextPage: json['hasNextPage'] ?? false,
    prevPage: int.tryParse(json['prevPage']?.toString() ?? ''),
    nextPage: int.tryParse(json['nextPage']?.toString() ?? ''),
  );

  Map<String, dynamic> toJson() => {
    'docs': docs.map((e) => e.toJson()).toList(),
    'totalDocs': totalDocs,
    'limit': limit,
    'totalPages': totalPages,
    'page': page,
    'hasPrevPage': hasPrevPage,
    'hasNextPage': hasNextPage,
    if (prevPage != null) 'prevPage': prevPage,
    if (nextPage != null) 'nextPage': nextPage,
  };
}
