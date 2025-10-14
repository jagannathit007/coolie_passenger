import 'dart:developer';

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
  final String id;
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
  final Collie? collie;

  Booking({
    required this.pickupDetails,
    required this.timestamp,
    required this.fare,
    required this.id,
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

  factory Booking.fromJson(Map<String, dynamic> json) {
    log("Parsing Booking JSON: $json");

    return Booking(
      pickupDetails: PickupDetails.fromJson(json['pickupDetails'] ?? {}),
      timestamp: Timestamp.fromJson(json['timestamp'] ?? {}),
      fare: Fare.fromJson(json['fare'] ?? {}),
      id: json['_id'] ?? json["id"] ?? '',
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
      collie: json['collie'] != null
          ? Collie.fromJson(json['collie'])
          : Collie(name: 'Unknown Coolie', mobileNo: '', rateCard: RateCard(baseRate: 0, baseTime: 0, waitingRate: 0)),
    );
  }

  Map<String, dynamic> toJson() => {
    'pickupDetails': pickupDetails.toJson(),
    'timestamp': timestamp.toJson(),
    'fare': fare.toJson(),
    '_id': id,
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

class Collie {
  final String name;
  final String mobileNo;
  final RateCard rateCard;

  Collie({required this.name, required this.mobileNo, required this.rateCard});

  factory Collie.fromJson(Map<String, dynamic> json) {
    return Collie(
      name: json['name']?.toString() ?? 'Unknown Coolie',
      mobileNo: json['mobileNo']?.toString() ?? '',
      rateCard: RateCard.fromJson(json['rateCard'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() => {'name': name, 'mobileNo': mobileNo, 'rateCard': rateCard.toJson()};
}

class RateCard {
  final int baseRate;
  final int baseTime;
  final int waitingRate;

  RateCard({required this.baseRate, required this.baseTime, required this.waitingRate});

  factory RateCard.fromJson(Map<String, dynamic> json) => RateCard(
    baseRate: int.tryParse(json['baseRate']?.toString() ?? '0') ?? 0,
    baseTime: int.tryParse(json['baseTime']?.toString() ?? '0') ?? 0,
    waitingRate: int.tryParse(json['waitingRate']?.toString() ?? '0') ?? 0,
  );

  Map<String, dynamic> toJson() => {'baseRate': baseRate, 'baseTime': baseTime, 'waitingRate': waitingRate};
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

  factory PaginationData.fromJson(Map<String, dynamic> json) {
    // Handle the nested data structure from your API response
    final data = json['data'] ?? json;

    return PaginationData(
      docs: (data['docs'] as List<dynamic>?)?.map((e) => Booking.fromJson(e as Map<String, dynamic>)).toList() ?? [],
      totalDocs: int.tryParse(data['totalDocs']?.toString() ?? '0') ?? 0,
      limit: int.tryParse(data['limit']?.toString() ?? '0') ?? 0,
      totalPages: int.tryParse(data['totalPages']?.toString() ?? '0') ?? 0,
      page: int.tryParse(data['page']?.toString() ?? '1') ?? 1,
      hasPrevPage: data['hasPrevPage'] ?? false,
      hasNextPage: data['hasNextPage'] ?? false,
      prevPage: data['prevPage'] != null ? int.tryParse(data['prevPage'].toString()) : null,
      nextPage: data['nextPage'] != null ? int.tryParse(data['nextPage'].toString()) : null,
    );
  }

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
