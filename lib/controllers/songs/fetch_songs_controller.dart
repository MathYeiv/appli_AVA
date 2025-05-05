// ignore_for_file: empty_catches, non_constant_identifier_names

import 'dart:io';
import 'package:get/get.dart';
import '../../controllers/permission/permission_controller.dart';
import '../../global_files.dart';

class FetchSongsController {
  Future<void> fetchLocalSongs(LoadType loadType) async {
    mainPageController.setLoadingState(false, loadType);
    if(await permission.checkAudioGranted()) {
      Directory dir = Directory(defaultDirectory);
      List<FileSystemEntity> directoryList = dir.listSync().toList();
      directoryList.removeWhere((e) => e.path == restrictedDirectory);
      List<FileSystemEntity> songsList = [];
      List<String> audioFormats = [
        '.mp3', // working format
      ];
      for(var dir in directoryList){
        if(dir is Directory) {
          try {
            for(int i = 0; i < audioFormats.length; i++) {
              songsList.addAll(
                dir.listSync(recursive: true).where((e) => e.path.endsWith(audioFormats[i])).toList()
              );
            }
          } catch (_) {

          }
        }  
      }
      
      final Map<String, AudioCompleteDataNotifier> filesCompleteDataList = {};
      final Map<String, AudioListenCountModel> localListenCountData = await isarController.fetchAllCounts();
      Map<String, AudioListenCountModel> getListenCountData = {};
      List<String> songUrlsList = [];
      for(int i = 0; i < songsList.length; i++) {
        String path = songsList[i].path;
        if(File(path).existsSync()){
          try {
            var metadata = await metadataController.fetchAudioMetadata(path);
            if(metadata != null){
              songUrlsList.add(path);
              filesCompleteDataList[path] = AudioCompleteDataNotifier(
                path, 
                AudioCompleteDataClass(
                  path, metadata, false
                ).obs
              );
              if(localListenCountData[path] != null){
                getListenCountData[path] = localListenCountData[path]!;
              }else{
                getListenCountData[path] = AudioListenCountModel(path, 0);
              }
            }
          } catch(e) {}
        }
      }
      appStateRepo.allAudiosList.value = filesCompleteDataList;
      appStateRepo.audioListenCount = getListenCountData;
      final _ = appStateRepo.setFavoritesList(await isarController.fetchFavorites());
      final __ = appStateRepo.setPlaylistList('', await isarController.fetchPlaylists());

      mainPageController.setLoadingState(true, loadType);
      
      if(loadType == LoadType.scan) {
        sortedAlbumsController.initializeController();
        sortedArtistsController.initializeController();
        playlistsController.initializeController();
      }
    } else{
      if(loadType == LoadType.scan) {
        final _ = await permission.requestAudio();
        if(permission.audioIsGranted) {
          await fetchLocalSongs(loadType);
        }
      }
      mainPageController.setLoadingState(true, loadType);
      /*
      if(context.mounted) {
        handler.displaySnackbar(
          context,
          SnackbarType.warning,
          tWarning.scanPermission
        );
      }
      */
    }
    return;
  }
}

final fetchSongsController = FetchSongsController();