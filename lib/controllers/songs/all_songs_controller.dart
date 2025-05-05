import 'package:flutter/material.dart';
import '../../controllers/songs/fetch_songs_controller.dart';
import '../../global_files.dart';

class AllSongsController {

  final BuildContext context;

  AllSongsController(
    this.context,
  );

  bool get mounted => context.mounted;

  Future<void> initializeController() async {
  }

  void dispose(){}

  void scan() async{
    await appStateRepo.audioHandler!.stop().then((value){
      fetchSongsController.fetchLocalSongs(LoadType.scan);
    });
  }
}