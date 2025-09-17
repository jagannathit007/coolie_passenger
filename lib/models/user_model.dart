class UserModel {
  final User user;
  final String token;

  UserModel({required this.user, required this.token});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      user: User.fromJson(json['user']),
      token: json['token'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': user.toJson(),
      'token': token,
    };
  }
}

class User {
  final String id;
  final String name;
  final String mobileNo;
  final String emailId;
  final String? address;
  final String? deviceType;
  final int? age;
  final ImageData? image;
  final RateCard? rateCard;
  final bool isActive;
  final bool isLoggedIn;
  final String fcm;
  final bool isDeleted;
  final String createdAt;
  final String updatedAt;
  final int v;
  final String buckleNumber;
  final String gender;
  final double? latitude;
  final double? longitude;
  final String? currentBookingId;
  final String? faceId;
  final int? rating;
  final int? totalRatings;
  final int? completedBookings;
  final int? rejectedBookings;

  User({
    required this.id,
    required this.name,
    required this.mobileNo,
    required this.emailId,
    this.address,
    this.deviceType,
    this.age,
    this.image,
    this.rateCard,
    required this.isActive,
    required this.isLoggedIn,
    required this.fcm,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
    required this.buckleNumber,
    required this.gender,
    this.latitude,
    this.longitude,
    this.currentBookingId,
    this.faceId,
    this.rating,
    this.totalRatings,
    this.completedBookings,
    this.rejectedBookings,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    int parseInt(dynamic value) {
      if (value == null) return 0;
      if (value is int) return value;
      if (value is String) return int.tryParse(value) ?? 0;
      return 0;
    }

    return User(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      mobileNo: json['mobileNo'] ?? '',
      emailId: json['emailId'] ?? '',
      address: json['address'],
      deviceType: json['deviceType'],
      age: json['age'] != null ? parseInt(json['age']) : null,
      image: json['image'] != null ? ImageData.fromJson(json['image']) : null,
      rateCard: json['rateCard'] != null ? RateCard.fromJson(json['rateCard']) : null,
      isActive: json['isActive'] ?? false,
      isLoggedIn: json['isLoggedIn'] ?? false,
      fcm: json['fcm'] ?? '',
      isDeleted: json['isDeleted'] ?? false,
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      v: parseInt(json['__v']),
      buckleNumber: json['buckleNumber'] ?? '',
      gender: json['gender'] ?? '',
      latitude: json['latitude'] != null
          ? double.tryParse(json['latitude'].toString())
          : null,
      longitude: json['longitude'] != null
          ? double.tryParse(json['longitude'].toString())
          : null,
      currentBookingId: json['currentBookingId'],
      faceId: json['faceId'],
      rating: json['rating'] != null ? parseInt(json['rating']) : null,
      totalRatings: json['totalRatings'] != null ? parseInt(json['totalRatings']) : null,
      completedBookings: json['completedBookings'] != null ? parseInt(json['completedBookings']) : null,
      rejectedBookings: json['rejectedBookings'] != null ? parseInt(json['rejectedBookings']) : null,
    );
  }



  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'mobileNo': mobileNo,
      'emailId': emailId,
      'address': address,
      'deviceType': deviceType,
      'age': age,
      'image': image?.toJson(),
      'rateCard': rateCard?.toJson(),
      'isActive': isActive,
      'isLoggedIn': isLoggedIn,
      'fcm': fcm,
      'isDeleted': isDeleted,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      '__v': v,
      'buckleNumber': buckleNumber,
      'gender': gender,
      'latitude': latitude,
      'longitude': longitude,
      'currentBookingId': currentBookingId,
      'faceId': faceId,
      'rating': rating,
      'totalRatings': totalRatings,
      'completedBookings': completedBookings,
      'rejectedBookings': rejectedBookings,
    };
  }
}

class ImageData {
  final String url;
  final String s3Key;

  ImageData({required this.url, required this.s3Key});

  factory ImageData.fromJson(Map<String, dynamic> json) {
    return ImageData(
      url: json['url'] ?? '',
      s3Key: json['s3Key'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      's3Key': s3Key,
    };
  }
}

class RateCard {
  final double baseRate;
  final int baseTime;
  final double waitingRate;

  RateCard({required this.baseRate, required this.baseTime, required this.waitingRate});

  factory RateCard.fromJson(Map<String, dynamic> json) {
    return RateCard(
      baseRate: (json['baseRate'] ?? 0).toDouble(),
      baseTime: json['baseTime'] ?? 0,
      waitingRate: (json['waitingRate'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'baseRate': baseRate,
      'baseTime': baseTime,
      'waitingRate': waitingRate,
    };
  }
}
