import 'dart:io';
import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:cameraapp/bloc/camera_event.dart';
import 'package:cameraapp/bloc/camera_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

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

  Future<void> _onSwitchCamera(
      SwitchCamera evet,
      Emitter<CameraState> emit
      ) async {
    if(state is !CameraReady) return;
    final s = state as CameraReady;
    final next = (s.selectedIndex + 1) % _camera.length;
    await _setupController(emit, next, previous : s);
  }

  Future<void> _onToggleFlash(
      ToggleFlash event,
      Emitter<CameraState> emit
      ) async {
    if(state is !CameraReady) return;
    final s = state as CameraReady;
    final next = s.flashMode == FlashMode.off ?
        FlashMode.auto : s.flashMode == FlashMode.auto ?
        FlashMode.always :
        FlashMode.off;

    await s.controller.setFlashMode(next);
    emit(s.copyWith(flashMode: next));
  }

  Future<void> _onTakePicture(
      TakePicture event,
      Emitter<CameraState> emit
      ) async {
    if(state is !CameraReady) return;
    final s = state as CameraReady;
    final file = await s.controller.takePicture();
    event.onPictureTaken(File(file.path));
  }

  Future<void> _onTapToFocus(
      TapToFocus event, Emitter<CameraState> emit
      ) async {
    if(state is !CameraReady) return;
    final s = state as CameraReady;
    final x = event.position.dx / event.previewSize.width;
    final y = event.position.dy / event.previewSize.height;

    await s.controller.setFocusPoint(Offset(x, y));
    await s.controller.setExposurePoint(Offset(x, y));
  }

  Future<void> _onPickImage(
      PickImageFromGallery event,
      Emitter<CameraState> emit
      ) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if(picked != null && state is CameraReady) {
      final file = File(picked.path);
      emit((state as CameraReady).copyWith(
        imageFile: file,
        snackbarMessage: "Berhasil memilih dari galeri"
      ));
    }
  }

}