import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../../global_files.dart';

class CustomPlaylistDisplayWidget extends StatefulWidget{
  final PlaylistSongsModel playlistSongsData;
  const CustomPlaylistDisplayWidget({super.key, required this.playlistSongsData});

  @override
  State<CustomPlaylistDisplayWidget> createState() =>_CustomPlaylistDisplayWidgetState();
}

class _CustomPlaylistDisplayWidgetState extends State<CustomPlaylistDisplayWidget>{
  late PlaylistSongsModel playlistSongsData;

  @override initState(){
    super.initState();
    playlistSongsData = widget.playlistSongsData;
  }

  @override void dispose(){
    super.dispose();
  }

  void deletePlaylist(){
    if(mounted){
      String playlistID = playlistSongsData.playlistID;
      List<PlaylistSongsModel> playlistList = appStateRepo.playlistList;
      int index = playlistList.indexWhere((e) => e.playlistID == playlistID);
      isarController.deletePlaylist(playlistList[index]);
      playlistList.removeAt(index);
      appStateRepo.setPlaylistList(playlistID, playlistList);
    }
  }


  void displayOptionsBottomSheet(){
    if(mounted){
      showModalBottomSheet(
        context: context,
        builder: (BuildContext bottomSheetContext) {
          return SingleChildScrollView(
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).bottomSheetTheme.backgroundColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10.0),
                  topRight: Radius.circular(10.0)
                )
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: getScreenHeight() * 0.015),
                  Container(
                    height: getScreenHeight() * 0.01,
                    width: getScreenWidth() * 0.15,
                    decoration: const BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.all(Radius.circular(10))
                    )
                  ),
                  SizedBox(height: getScreenHeight() * 0.015), 
                  CustomButton(
                    onTapped: (){
                      if(mounted){
                        Navigator.of(bottomSheetContext).pop();
                      }
                      runDelay(() async{
                        if(mounted){
                          var updatedPlaylist = await Navigator.of(context).push(MaterialPageRoute(builder: (context) => PlaylistEditorWidget(playlistSongsData: playlistSongsData)));
                          if(updatedPlaylist != null){
                            appStateRepo.setPlaylistList(playlistSongsData.playlistID, updatedPlaylist);
                          }
                        }
                      }, navigationDelayDuration);
                    },
                    text: 'Edit playlist',
                    width: double.infinity,
                    height: getScreenHeight() * 0.08,
                    setBorderRadius: false,
                    prefix: null,
                    loading: false
                  ),
                  CustomButton(
                    onTapped: (){
                      if(mounted){
                        Navigator.of(bottomSheetContext).pop();
                      }
                      runDelay(() => deletePlaylist(), navigationDelayDuration);
                    },
                    text: 'Delete playlist',
                    width: double.infinity,
                    height: getScreenHeight() * 0.08,
                    setBorderRadius: false,
                    prefix: null,
                    loading: false
                  ),
                ]
              )
            )
          );
        }
      );
    }
  }

  @override
  Widget build(BuildContext context){
    List<String> filteredPlaylists = playlistSongsData.songsList.where((e) {
      if(appStateRepo.allAudiosList[e] == null) {
        return false;
      }
      return !appStateRepo.allAudiosList[e]!.notifier.value.deleted;
    }).toList();
    
    return Card(
      margin: EdgeInsets.symmetric(horizontal: defaultHorizontalPadding / 2, vertical: defaultVerticalPadding / 2),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => DisplayPlaylistSongsWidget(playlistSongsData: playlistSongsData))),
          splashFactory: InkSparkle.splashFactory,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: defaultHorizontalPadding / 2, vertical: defaultVerticalPadding / 2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: getScreenWidth() * 0.125, 
                        height: getScreenWidth() * 0.125,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5.0),
                          child: Image.memory(
                            playlistSongsData.imageBytes == null ?
                              appStateRepo.audioImageData!
                            : 
                              Uint8List.fromList(playlistSongsData.imageBytes!),
                            errorBuilder: (context, exception, stackTrace) => Image.memory(appStateRepo.audioImageData!),
                            fit: BoxFit.cover
                          )
                        ),
                      ),
                      SizedBox(width: getScreenWidth() * 0.035),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    playlistSongsData.playlistName, 
                                    style: const TextStyle(fontSize: 16), 
                                    maxLines: 1, 
                                    overflow: TextOverflow.ellipsis
                                  )
                                ),
                              ],
                            ),
                            SizedBox(height: getScreenHeight() * 0.005),
                            Text(filteredPlaylists.length == 1 ? '1 song' : '${filteredPlaylists.length} songs', style: const TextStyle(fontSize: 13),)
                          ]
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: (){
                    displayOptionsBottomSheet();
                  },
                  child: const Icon(Icons.more_vert)
                )
              ],
            )
          )
        )
      )
    );
  }
}