import 'package:get/get.dart';

class Platform {
  final String id;
  final String stationId;
  final String platformNumber;
  final bool isActive;
  final bool isDeleted;
  final DateTime createdAt;
  final DateTime updatedAt;

  Platform({
    required this.id,
    required this.stationId,
    required this.platformNumber,
    required this.isActive,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Platform.fromJson(Map<String, dynamic> json) {
    return Platform(
      id: json['_id'] as String,
      stationId: json['stationId'] as String,
      platformNumber: json['platformNumber'] as String,
      isActive: json['isActive'] as bool,
      isDeleted: json['isDeleted'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'stationId': stationId,
      'platformNumber': platformNumber,
      'isActive': isActive,
      'isDeleted': isDeleted,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}