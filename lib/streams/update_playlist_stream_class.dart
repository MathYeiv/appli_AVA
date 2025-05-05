import 'dart:async';
import '../../global_files.dart';

class UpdatePlaylistStreamControllerClass{
  final String playlistID;
  final List<PlaylistSongsModel> playlistsList;

  UpdatePlaylistStreamControllerClass(this.playlistID, this.playlistsList);
}

class UpdatePlaylistStreamClass {
  static final UpdatePlaylistStreamClass _instance = UpdatePlaylistStreamClass._internal();
  late StreamController<UpdatePlaylistStreamControllerClass> _updatePlaylistStreamController;

  factory UpdatePlaylistStreamClass(){
    return _instance;
  }

  UpdatePlaylistStreamClass._internal() {
    _updatePlaylistStreamController = StreamController<UpdatePlaylistStreamControllerClass>.broadcast();
  }

  Stream<UpdatePlaylistStreamControllerClass> get updatePlaylistStream => _updatePlaylistStreamController.stream;


  void removeListener(){
    _updatePlaylistStreamController.stream.drain();
  }

  void emitData(UpdatePlaylistStreamControllerClass data){
    if(!_updatePlaylistStreamController.isClosed){
      _updatePlaylistStreamController.add(data);
    }
  }

  void dispose(){
    _updatePlaylistStreamController.close();
  }
}