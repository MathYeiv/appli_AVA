import 'package:get/get.dart';
import '../../constants/loading/enums.dart';

class LoadingController {
  Rx<LoadingStatus> status = LoadingStatus.loading.obs;

  void changeStatus(LoadingStatus newStatus) => status.value = newStatus;
}