import 'dart:async';
import '../../global_files.dart';

class DeleteAudioDataStreamControllerClass{
  final AudioCompleteDataClass audioData;

  DeleteAudioDataStreamControllerClass(this.audioData);
}

class DeleteAudioDataStreamClass {
  static final DeleteAudioDataStreamClass _instance = DeleteAudioDataStreamClass._internal();
  late StreamController<DeleteAudioDataStreamControllerClass> _deleteAudioDataStreamController;

  factory DeleteAudioDataStreamClass(){
    return _instance;
  }

  DeleteAudioDataStreamClass._internal() {
    _deleteAudioDataStreamController = StreamController<DeleteAudioDataStreamControllerClass>.broadcast();
  }

  Stream<DeleteAudioDataStreamControllerClass> get deleteAudioDataStream => _deleteAudioDataStreamController.stream;


  void removeListener(){
    _deleteAudioDataStreamController.stream.drain();
  }

  void emitData(DeleteAudioDataStreamControllerClass data){
    if(!_deleteAudioDataStreamController.isClosed){
      _deleteAudioDataStreamController.add(data);
    }
  }

  void dispose(){
    _deleteAudioDataStreamController.close();
  }
}