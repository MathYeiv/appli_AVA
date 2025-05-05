import 'package:get/get.dart';
import '../../global_files.dart';

class AudioCompleteDataNotifier extends GetxController {  
  final String audioID;
  final Rx<AudioCompleteDataClass> notifier;

  AudioCompleteDataNotifier(this.audioID, this.notifier);
}