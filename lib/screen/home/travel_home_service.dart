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

  Future<dynamic> getBookingHistory({required String passengerId, required int page}) async {
    try {
      final response = await apiManager.post(NetworkConstants.getBookingHistory, data: {"passengerId": passengerId, "page": page});
      if (response.status != 200) {
        AppToasting.showWarning(response.message);
        return [];
      }
      return PaginationData.fromJson(response.data);
    } catch (err) {
      AppToasting.showError('Error fetching booking history: $err');
      return [];
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
}
