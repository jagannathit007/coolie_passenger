class RegisterUserModel {
  final String id;
  final String name;
  final String mobileNo;
  final String emailId;
  final String userImage;
  final String latitude;
  final String longitude;
  final bool isActive;
  final String token;
  final AddressComponent addressComponent;

  RegisterUserModel({
    required this.id,
    required this.name,
    required this.mobileNo,
    required this.emailId,
    required this.userImage,
    required this.latitude,
    required this.longitude,
    required this.isActive,
    required this.token,
    required this.addressComponent,
  });

  factory RegisterUserModel.fromJson(Map<String, dynamic> json) {
    return RegisterUserModel(
      id: json["_id"] ?? "",
      name: json["name"] ?? "",
      mobileNo: json["mobileNo"] ?? "",
      emailId: json["emailId"] ?? "",
      userImage: json["userImage"] ?? "",
      latitude: json["latitude"] ?? "",
      longitude: json["longitude"] ?? "",
      isActive: json["isActive"] ?? false,
      token: json["token"] ?? "",
      addressComponent: AddressComponent.fromJson(json["addressComponent"] ?? {}),
    );
  }
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

  factory AddressComponent.fromJson(Map<String, dynamic> json) {
    return AddressComponent(
      pincode: json["pincode"] ?? "",
      city: json["city"] ?? "",
      state: json["state"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "pincode": pincode,
    "city": city,
    "state": state,
  };
}
