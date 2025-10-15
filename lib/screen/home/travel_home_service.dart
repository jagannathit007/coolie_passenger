import 'dart:developer';
import 'package:get/get.dart';
import '../../api constants/api_manager.dart';
import '../../api constants/network_constants.dart';
import '../../models/booking_models.dart';
import '../../services/app_toasting.dart';

class TravelHomeService extends GetxService {
  Future<dynamic> bookCoolie(dynamic data) async {
    try {
      final response = await apiManager.post(NetworkConstants.bookCoolie, data: data);
      if (response.status != 200) {
        AppToasting.showWarning(response.data?.message ?? 'Failed to book coolie');
        return null;
      }
      return response.data;
    } catch (err) {
      AppToasting.showError('Error booking coolie: $err');
      return null;
    }
  }

  Future<dynamic> cancelBooking(String bookingId) async {
    try {
      final response = await apiManager.post(
        NetworkConstants.cancelBooking,
        data: {"bookingId": bookingId, "reason": "reason"},
      );

      if (response.status != 200) {
        AppToasting.showWarning(response.message);
        return null;
      }

      log("Cancel Booking Response: ${response.data}");
      return response.data;
    } catch (err) {
      AppToasting.showError('Error canceling booking: ${err.toString()}');
      return null;
    }
  }

  Future<dynamic> getBookingStatus({required String passengerId}) async {
    try {
      final response = await apiManager.post(NetworkConstants.getBookingStatus, data: {"passengerId": passengerId});
      if (response.status != 200) {
        AppToasting.showWarning(response.message);
        return null;
      }
      return response.data;
    } catch (err) {
      AppToasting.showError('Error fetching booking status: $err');
      return null;
    }
  }

  Future<PaginationData?> getBookingHistory({required String passengerId, required int page}) async {
    try {
      final response = await apiManager.post(NetworkConstants.getBookingHistory, data: {"passengerId": passengerId, "page": page});

      log("Booking History API Response: ${response.data}");

      if (response.status != 200) {
        AppToasting.showWarning(response.message ?? 'Failed to fetch booking history');
        return null;
      }

      // Check if we have data in the response
      if (response.data == null || response.data["docs"] == null) {
        AppToasting.showWarning('No booking history data found');
        return null;
      }

      return PaginationData.fromJson(response.data);
    } catch (err) {
      log("Error fetching booking history: $err");
      AppToasting.showError('Error fetching booking history: $err');
      return null;
    }
  }

  Future<dynamic> getStations() async {
    try {
      final response = await apiManager.get(NetworkConstants.getStations);
      if (response.status != 200) {
        AppToasting.showWarning(response.message);
        return [];
      }
      return response.data;
    } catch (err) {
      AppToasting.showError('Error fetching stations: $err');
      return [];
    }
  }

  Future<List<String>> getAllPlatforms(String stationId) async {
    try {
      final response = await apiManager.get('${NetworkConstants.getPlatforms}/$stationId');
      if (response.status != 200 || response.data == null) {
        AppToasting.showWarning('Failed to fetch platforms');
        return ['1', '2', '3', '4', '5', '6'];
      }
      return List<String>.from(response.data['platforms'] ?? ['1', '2', '3', '4', '5', '6']);
    } catch (err) {
      log("Error fetching platforms: $err");
      AppToasting.showError('Error fetching platforms: $err');
      return ['1', '2', '3', '4', '5', '6'];
    }
  }
  // Future<List<Platform>> getAllPlatforms(String stationId) async {
  //   try {
  //     final response = await apiManager.get('${NetworkConstants.getPlatforms}/$stationId');
  //     if (response.status != 200 || response.data == null || response.data['platforms'] == null) {
  //       AppToasting.showWarning('Failed to fetch platforms');
  //       return [
  //         Platform(
  //           id: 'default1',
  //           stationId: stationId,
  //           platformNumber: '1',
  //           isActive: true,
  //           isDeleted: false,
  //           createdAt: DateTime.now(),
  //           updatedAt: DateTime.now(),
  //         ),
  //         Platform(
  //           id: 'default2',
  //           stationId: stationId,
  //           platformNumber: '2',
  //           isActive: true,
  //           isDeleted: false,
  //           createdAt: DateTime.now(),
  //           updatedAt: DateTime.now(),
  //         ),
  //         Platform(
  //           id: 'default3',
  //           stationId: stationId,
  //           platformNumber: '3',
  //           isActive: true,
  //           isDeleted: false,
  //           createdAt: DateTime.now(),
  //           updatedAt: DateTime.now(),
  //         ),
  //         Platform(
  //           id: 'default4',
  //           stationId: stationId,
  //           platformNumber: '4',
  //           isActive: true,
  //           isDeleted: false,
  //           createdAt: DateTime.now(),
  //           updatedAt: DateTime.now(),
  //         ),
  //         Platform(
  //           id: 'default5',
  //           stationId: stationId,
  //           platformNumber: '5',
  //           isActive: true,
  //           isDeleted: false,
  //           createdAt: DateTime.now(),
  //           updatedAt: DateTime.now(),
  //         ),
  //         Platform(
  //           id: 'default6',
  //           stationId: stationId,
  //           platformNumber: '6',
  //           isActive: true,
  //           isDeleted: false,
  //           createdAt: DateTime.now(),
  //           updatedAt: DateTime.now(),
  //         ),
  //       ];
  //     }
  //     return (response.data['platforms'] as List<dynamic>)
  //         .map((platform) => Platform.fromJson(platform))
  //         .toList();
  //   } catch (err) {
  //     log("Error fetching platforms: $err");
  //     AppToasting.showError('Error fetching platforms: $err');
  //     return [
  //       Platform(
  //         id: 'default1',
  //         stationId: stationId,
  //         platformNumber: '1',
  //         isActive: true,
  //         isDeleted: false,
  //         createdAt: DateTime.now(),
  //         updatedAt: DateTime.now(),
  //       ),
  //       Platform(
  //         id: 'default2',
  //         stationId: stationId,
  //         platformNumber: '2',
  //         isActive: true,
  //         isDeleted: false,
  //         createdAt: DateTime.now(),
  //         updatedAt: DateTime.now(),
  //       ),
  //       Platform(
  //         id: 'default3',
  //         stationId: stationId,
  //         platformNumber: '3',
  //         isActive: true,
  //         isDeleted: false,
  //         createdAt: DateTime.now(),
  //         updatedAt: DateTime.now(),
  //       ),
  //       Platform(
  //         id: 'default4',
  //         stationId: stationId,
  //         platformNumber: '4',
  //         isActive: true,
  //         isDeleted: false,
  //         createdAt: DateTime.now(),
  //         updatedAt: DateTime.now(),
  //       ),
  //       Platform(
  //         id: 'default5',
  //         stationId: stationId,
  //         platformNumber: '5',
  //         isActive: true,
  //         isDeleted: false,
  //         createdAt: DateTime.now(),
  //         updatedAt: DateTime.now(),
  //       ),
  //       Platform(
  //         id: 'default6',
  //         stationId: stationId,
  //         platformNumber: '6',
  //         isActive: true,
  //         isDeleted: false,
  //         createdAt: DateTime.now(),
  //         updatedAt: DateTime.now(),
  //       ),
  //     ];
  //   }
  // }
  // }
}
