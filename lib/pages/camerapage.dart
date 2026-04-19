import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/camera_bloc.dart';
import '../bloc/camera_event.dart';
import '../bloc/camera_state.dart';

class CameraPage extends StatelessWidget {
  const CameraPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: BlocBuilder<CameraBloc, CameraState>(
        builder: (context, state) {
          if (state is CameraReady) {
            return Stack(
              children: [
                Center(child: CameraPreview(state.controller)),
                Positioned(
                  top: 40,
                  left: 20,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white, size: 30),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                Positioned(
                  bottom: 50,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Tombol Toggle Flash
                      IconButton(
                        icon: Icon(
                          state.flashMode == FlashMode.off ? Icons.flash_off : Icons.flash_on,
                          color: Colors.white,
                        ),
                        onPressed: () => context.read<CameraBloc>().add(ToggleFlash()),
                      ),
                      GestureDetector(
                        onTap: () {
                          context.read<CameraBloc>().add(TakePicture((File file) {
                            Navigator.pop(context, file); // Kirim file saat pop
                          }));
                        },
                        child: Container(
                          height: 70,
                          width: 70,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 4),
                          ),
                          child: const Center(
                            child: Icon(Icons.circle, color: Colors.white, size: 50),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.flip_camera_ios, color: Colors.white),
                        onPressed: () => context.read<CameraBloc>().add(SwitchCamera()),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}