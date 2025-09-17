class GetUserProfile {
  final User? user;

  GetUserProfile({
     this.user,
  });

  factory GetUserProfile.fromJson(Map<String, dynamic> json) => GetUserProfile(
    user: User.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {
    "user": user?.toJson(),
  };
}

class User {
  final AddressComponent addressComponent;
  final String id;
  final String name;
  final String mobileNo;
  final String emailId;
  final String userImage;
  final bool isActive;
  final String deviceId;
  final bool isVerified;
  final String gender;
  final String fcm;
  final bool isDeleted;
  final String latitude;
  final String longitude;
  final String otp;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String v;

  User({
    required this.addressComponent,
    required this.id,
    required this.name,
    required this.mobileNo,
    required this.emailId,
    required this.userImage,
    required this.isActive,
    required this.deviceId,
    required this.isVerified,
    required this.gender,
    required this.fcm,
    required this.isDeleted,
    required this.latitude,
    required this.longitude,
    required this.otp,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    addressComponent: AddressComponent.fromJson(json["addressComponent"]),
    id: json["_id"],
    name: json["name"],
    mobileNo: json["mobileNo"],
    emailId: json["emailId"],
    userImage: json["userImage"],
    isActive: json["isActive"],
    deviceId: json["deviceId"],
    isVerified: json["isVerified"],
    gender: json["gender"],
    fcm: json["fcm"],
    isDeleted: json["isDeleted"],
    latitude: json["latitude"],
    longitude: json["longitude"],
    otp: json["otp"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "addressComponent": addressComponent.toJson(),
    "_id": id,
    "name": name,
    "mobileNo": mobileNo,
    "emailId": emailId,
    "userImage": userImage,
    "isActive": isActive,
    "deviceId": deviceId,
    "isVerified": isVerified,
    "gender": gender,
    "fcm": fcm,
    "isDeleted": isDeleted,
    "latitude": latitude,
    "longitude": longitude,
    "otp": otp,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "__v": v,
  };
}

class AddressComponent {
  final String pincode;
  final String city;
  final String state;

  AddressComponent({
    required this.pincode,
    required this.city,
    required this.state,
  });

  factory AddressComponent.fromJson(Map<String, dynamic> json) => AddressComponent(
    pincode: json["pincode"],
    city: json["city"],
    state: json["state"],
  );

  Map<String, dynamic> toJson() => {
    "pincode": pincode,
    "city": city,
    "state": state,
  };
}
