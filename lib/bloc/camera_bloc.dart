import 'package:camera/camera.dart';
import 'package:cameraapp/bloc/camera_event.dart';
import 'package:cameraapp/bloc/camera_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CameraBloc extends Bloc<CameraEvent, CameraState> {
  late List<CameraDescription> _camera;

  CameraBloc() : super(CameraInitial()) {
    on<IntializeCamera>(_onInitialize);
    on<SwitchCamera>(_onSwitchCamera);
    on<ToggleFlash>(_onToggleFlash);
    on<TakePicture>(_onTakePicture);
    on<TapToFocus>(_onTapToFocus);
    on<PickImageFromGallery>(_onPickImage);
    on<OpenCameraAndCapture>(_onOpenCamera);
    on<DeleteImage>(_onDeleteImage);
    on<ClearSnackbar>(_onClearSnackBar);
    on<RequestPermission>(_onRequestPermisson);
  }

  Future<void> _onInitialize(
      IntializeCamera event,
      Emitter<CameraState> emit
      ) async {
    _camera = await availableCameras();
    await _setupController(emit, 0);
  }

}