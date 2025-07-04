// ignore_for_file: prefer_null_aware_operators

import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../global_files.dart';

class CustomCurrentlyPlayingExpandedWidget extends StatefulWidget{
  const CustomCurrentlyPlayingExpandedWidget({super.key});

  @override
  State<CustomCurrentlyPlayingExpandedWidget> createState() =>_CustomCurrentlyPlayingExpandedWidgetState();
}

class _CustomCurrentlyPlayingExpandedWidgetState extends State<CustomCurrentlyPlayingExpandedWidget>{
  Rx<SongOptionController?> controller = Rx<SongOptionController?>(null);
  Rx<AudioCompleteDataClass?> audioCompleteData = Rx<AudioCompleteDataClass?>(null);
  Rx<Duration> timeRemaining = Duration.zero.obs;
  RxBool isDraggingSlider = false.obs; 
  RxDouble currentPosition = 0.toDouble().obs;
  RxString currentDurationStr = '00:00'.obs; 
  Rx<DurationEndDisplay> displayCurrentDurationType = DurationEndDisplay.totalDuration.obs;
  Rx<LoopStatus> currentLoopStatus = LoopStatus.repeatCurrent.obs;
  late StreamSubscription editAudioMetadataStreamClassSubscription;

  @override initState(){
    super.initState();
    initializeAudio(appStateRepo.audioHandler!.audioStateController.currentAudioUrl.value);
    currentLoopStatus.value = appStateRepo.audioHandler!.currentLoopStatus;
    updateSliderPosition();
    isDraggingSlider.listen((data) {
      if(mounted){
        if(audioCompleteData.value != null && !isDraggingSlider.value){
          updateSliderPosition();
        }
      }
    });
    appStateRepo.audioHandler!.audioPlayer.positionStream.listen((newPosition) {
      if(appStateRepo.audioHandler!.audioPlayer.duration == null) {
        return;
      }
      
      if(mounted){
        if(audioCompleteData.value != null && !isDraggingSlider.value && newPosition.inMilliseconds <= appStateRepo.audioHandler!.audioPlayer.duration!.inMilliseconds){
          currentPosition.value = min((newPosition.inMilliseconds / appStateRepo.audioHandler!.audioPlayer.duration!.inMilliseconds), 1);
          currentDurationStr.value = _formatDuration(newPosition);
          timeRemaining.value = appStateRepo.audioHandler!.audioPlayer.duration! - newPosition;
        }
      }
    });
    appStateRepo.audioHandler?.audioStateController.currentAudioUrl.listen((audioUrl) {
      initializeAudio(audioUrl);
    });
    editAudioMetadataStreamClassSubscription = EditAudioMetadataStreamClass().editAudioMetadataStream.listen((EditAudioMetadataStreamControllerClass data) {
      if(mounted){
        if(audioCompleteData.value != null){
          if(appStateRepo.audioHandler!.audioStateController.currentAudioUrl.value == data.newAudioData.audioUrl){
            audioCompleteData.value = data.newAudioData;
            controller = Rx<SongOptionController>(
              SongOptionController(
                context, 
                audioCompleteData.value!, 
                null
              )
            );
          }
        }
      }
    });
  }

  void initializeAudio(String? currentAudioUrl) {
    if(mounted){
      if(currentAudioUrl == null) {
        Navigator.of(context).pop();
        audioCompleteData.value = null;
        return;
      }
      audioCompleteData.value = appStateRepo.allAudiosList[currentAudioUrl]?.notifier.value;
      if(audioCompleteData.value == null) {
        return;
      }
      controller.value = SongOptionController(
        context, 
        audioCompleteData.value!, 
        null
      );
    }
  }

  @override void dispose(){
    super.dispose();
    editAudioMetadataStreamClassSubscription.cancel();
  }

  void updateSliderPosition(){
    if(appStateRepo.audioHandler!.audioPlayer.duration == null) {
      return;
    }
    
    if(mounted){
      if(appStateRepo.audioHandler != null && audioCompleteData.value != null){
        Duration? currentDuration = appStateRepo.audioHandler!.audioPlayer.duration;
        currentPosition.value = min(
  (currentDuration?.inMilliseconds ?? 0) / 
  (appStateRepo.audioHandler?.audioPlayer.duration?.inMilliseconds ?? 1), 
  1
);

currentDurationStr.value = _formatDuration(currentDuration ?? Duration.zero);

timeRemaining.value = 
  (appStateRepo.audioHandler?.audioPlayer.duration ?? Duration.zero) - 
  (currentDuration ?? Duration.zero);

            }
    }
  }

  void pauseAudio() async{
    await appStateRepo.audioHandler!.pause();
  }  

  void resumeAudio() async{
    await appStateRepo.audioHandler!.play();
  }

  void modifyLoopStatus(LoopStatus loopStatus){
    if(mounted){
      currentLoopStatus.value = loopStatus;
    }
    appStateRepo.audioHandler!.modifyLoopStatus(loopStatus);
  }

  void playNext() async{
    await appStateRepo.audioHandler!.skipToNext();
  }

  void playPrev() async{
    await appStateRepo.audioHandler!.skipToPrevious();
  }

  void onSliderChange(value){ 
    if(appStateRepo.audioHandler!.audioPlayer.duration == null) {
      return;
    }

    if(mounted){
      isDraggingSlider.value = true;
      currentPosition.value = value;
      var currentSecond = (value * appStateRepo.audioHandler!.audioPlayer.duration!.inMilliseconds / 1000).floor();
      currentDurationStr.value = formatSeconds(currentSecond);
    }
  }

  void onSliderEnd(value) async{
    if(appStateRepo.audioHandler!.audioPlayer.duration == null) {
      return;
    }
    
    if(mounted){
      var duration = ((value * appStateRepo.audioHandler!.audioPlayer.duration!.inMilliseconds) ~/ 10) * 10;
      currentPosition.value = value ;
      isDraggingSlider.value = false;
      await appStateRepo.audioHandler!.audioPlayer.seek(Duration(milliseconds: duration));
    } 
  }

  String _formatDuration(Duration duration) { //convert duration to string
    String hours = (duration.inHours).toString().padLeft(2, '0');
    String minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    String seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');

    if (hours == '00') {
      return '$minutes:$seconds';
    } else {
      return '$hours:$minutes:$seconds';
    }
  }

  String formatSeconds(int seconds) { //convert total seconds to string
    int hours = seconds ~/ 3600;
    int minutes = (seconds ~/ 60) % 60;
    int remainingSeconds = seconds % 60;
    
    String formattedTime = '';
    
    if (hours > 0) {
      formattedTime += '${hours.toString().padLeft(2, '0')}:';
    }
    
    formattedTime += '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
    
    return formattedTime;
  }

  @override
  Widget build(BuildContext context){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Obx(() {
          AudioCompleteDataClass? audioCompleteDataValue = audioCompleteData.value;
          LoopStatus currentLoopStatusValue = currentLoopStatus.value;
          DurationEndDisplay displayType = displayCurrentDurationType.value;
          
          if(audioCompleteDataValue == null){
            return Container(key: UniqueKey());
          }

          return Container(
            padding: EdgeInsets.symmetric(horizontal: defaultHorizontalPadding, vertical: defaultVerticalPadding * 2.5),
            child: Material(
              color: Colors.transparent,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: getScreenWidth() * 0.7, 
                        height: getScreenWidth() * 0.7,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5.0),
                          child: Image.memory(
                            audioCompleteData.value!.audioMetadataInfo.albumArt == null ?
                              appStateRepo.audioImageData!
                            : 
                              audioCompleteData.value!.audioMetadataInfo.albumArt!,
                            errorBuilder: (context, exception, stackTrace) => Image.memory(appStateRepo.audioImageData!),
                            fit: BoxFit.cover
                          )
                        ),
                      ),
                      SizedBox(height: getScreenHeight() * 0.02),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: getScreenHeight() * 0.02),
                          child: Text(
                            audioCompleteDataValue.audioMetadataInfo.title ?? audioCompleteDataValue.audioMetadataInfo.fileName, 
                            style: const TextStyle(fontSize: 20), maxLines: 1
                          ),
                        ),
                      ),
                      Text(audioCompleteDataValue.audioMetadataInfo.artistName ?? 'Unknown', style: const TextStyle(fontSize: 16.5),),
                      SizedBox(height: getScreenHeight() * 0.04),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(width: getScreenWidth() * 0.07,),
                          GestureDetector(
                            onTap: (){
                              if(currentLoopStatusValue == LoopStatus.repeatCurrent){
                                modifyLoopStatus(LoopStatus.repeatAll);
                              }else if(currentLoopStatusValue == LoopStatus.repeatAll){
                                modifyLoopStatus(LoopStatus.shuffleAll);
                              }else if(currentLoopStatusValue == LoopStatus.shuffleAll){
                                modifyLoopStatus(LoopStatus.repeatCurrent);
                              }
                            },
                            child: currentLoopStatusValue == LoopStatus.repeatCurrent ?
                              const Icon(Icons.repeat_one, size: 30)
                            : currentLoopStatusValue == LoopStatus.repeatAll ?
                              const Icon(Icons.repeat , size: 30)
                            : currentLoopStatusValue == LoopStatus.shuffleAll ?
                              const Icon(Icons.shuffle, size: 30)
                            : Container()
                          ),
                          SizedBox(width: getScreenWidth() * 0.07,),
                          GestureDetector(
                            onTap: () => playPrev(),
                            child: const Icon(Icons.skip_previous, size: 30)
                          ),
                          SizedBox(width: getScreenWidth() * 0.07,),
                          GetBuilder<AudioStateController>( 
                            id: 'playerState',
                            builder: (controller) {
                              final AudioPlayerState playerState = controller.playerState.value;
                              return Container(
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(Radius.circular(50)),
                                  color: Colors.grey.withOpacity(0.35)
                                ),
                                padding: const EdgeInsets.all(5),
                                child: GestureDetector(
                                  onTap: (){
                                    if(playerState == AudioPlayerState.paused){
                                      resumeAudio();
                                    }else if(playerState == AudioPlayerState.playing){
                                      pauseAudio();
                                    }
                                  },
                                  child: playerState == AudioPlayerState.paused ?
                                    const Icon(Icons.play_arrow, size: 35)
                                  : const Icon(Icons.pause, size: 35)
                                ),
                              );
                            }
                          ),
                          SizedBox(width: getScreenWidth() * 0.07,),
                          GestureDetector(
                            onTap: () => playNext(),
                            child: const Icon(Icons.skip_next, size: 30)
                          ),
                          SizedBox(width: getScreenWidth() * 0.07),
                          GestureDetector(
                            onTap: () => controller.value!.displayOptionsBottomSheet(),
                            child: const Icon(Icons.more_vert, size: 30)
                          ),
                          SizedBox(width: getScreenWidth() * 0.07,),
                        ]
                      )
                    ],
                  ),
                  SizedBox(height: getScreenHeight() * 0.04),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: defaultHorizontalPadding / 4),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: defaultHorizontalPadding / 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                currentDurationStr.value, style: const TextStyle(fontSize: 15)
                              ),
                              GestureDetector(
                                onTap: (){
                                  if(mounted){
                                    if(displayType == DurationEndDisplay.totalDuration){
                                      displayCurrentDurationType.value = DurationEndDisplay.timeRemaining;
                                    }else{
                                      displayCurrentDurationType.value = DurationEndDisplay.totalDuration;
                                    }
                                  }
                                },
                                child: displayType == DurationEndDisplay.totalDuration ?
                                  Text(
                                    _formatDuration(appStateRepo.audioHandler!.audioPlayer.duration ?? Duration.zero),
                                    style: const TextStyle(fontSize: 15)
                                  )
                                : 
                                  Text(
                                    _formatDuration(timeRemaining.value), style: const TextStyle(fontSize: 15)
                                  )
                              )
                            ]
                          ),
                        ),
                        SizedBox(height: getScreenHeight() * 0.01),
                        SizedBox(
                          height: 15,
                          child: SliderTheme(
                            data: SliderThemeData(
                              trackHeight: 3.0,
                              thumbColor: Colors.red,
                              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 5.0),
                              overlayShape: const RoundSliderOverlayShape(overlayRadius: 0.0),
                              activeTrackColor: Colors.red,
                              inactiveTrackColor: Colors.grey.withOpacity(0.7)
                            ),
                            child: Slider(
                              min: 0.0,
                              max: 1.0,
                              value: currentPosition.value,
                              onChanged: (newValue) {
                                onSliderChange(newValue);
                              },
                              onChangeEnd: (newValue){
                                onSliderEnd(newValue);
                              },
                            )
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ),
          );
        }),
      ],
    );
  }
}