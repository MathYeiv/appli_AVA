import 'dart:io';
import 'package:flutter/material.dart';
import '../../global_files.dart';

/// Controller used for handling a song file
class SongFileController {

  void deleteSong(BuildContext context, AudioCompleteDataClass audioData) async{
    try{
      File selectedFile = File(audioData.audioUrl);
      if(selectedFile.existsSync()){
        final Uri? uri = await mediaStorePlugin.getUriFromFilePath(path: selectedFile.path);
        final bool deleted = await mediaStorePlugin.deleteFileUsingUri(
          uriString: uri.toString(),
        );
        if(deleted) { 
          final AudioCompleteDataClass newAudioData = appStateRepo.allAudiosList[audioData.audioUrl]!.notifier.value.copy();
          newAudioData.deleted = true;
          appStateRepo.allAudiosList[audioData.audioUrl]!.notifier.value = newAudioData;
          DeleteAudioDataStreamClass().emitData(
            DeleteAudioDataStreamControllerClass(appStateRepo.allAudiosList[audioData.audioUrl]!.notifier.value)
          );
          if(appStateRepo.audioHandler!.audioStateController.currentAudioUrl.value == audioData.audioUrl){
            appStateRepo.audioHandler!.stop();
          }
          if(context.mounted) {
            handler.displaySnackbar(
              context, 
              SnackbarType.successful, 
              tSuccess.deleteSong
            );
          }
        } else {
          if(context.mounted) {
            handler.displaySnackbar(
              context,
              SnackbarType.error, 
              tErr.unknown
            );
          }
        }
      } else {
        if(context.mounted) {
          handler.displaySnackbar(
            context,
            SnackbarType.error, 
            'File does not exist.'
          );
        }
      }
    } catch (e) {
      if(context.mounted) {
        handler.displaySnackbar(
          context,
          SnackbarType.error, 
          e.toString()
        );
      }
    }
  }
}

final SongFileController songFileController = SongFileController();