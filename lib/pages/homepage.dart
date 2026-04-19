import 'package:cameraapp/bloc/camera_bloc.dart';
import 'package:cameraapp/bloc/camera_event.dart';
import 'package:cameraapp/bloc/camera_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Beranda"),),
      body: SafeArea(
          child: BlocConsumer<CameraBloc, CameraState>(
            listener: (context,state) {
              if(state is CameraReady && state.snackbarMessage != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.snackbarMessage!))
                );
                context.read<CameraBloc>().add(ClearSnackbar());
              }
            },
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                            onPressed: () {
                              final bloc = context.read<CameraBloc>();
                              if(bloc.state is !CameraReady) {
                                bloc.add(IntializeCamera());
                              }
                              bloc.add(OpenCameraAndCapture(context));
                            },
                            icon: Icon(Icons.camera),
                            label: Text("Ambil Foto")
                        ),
                      ),
                      ElevatedButton.icon(
                          onPressed: () => context.read<CameraBloc>().add(PickImageFromGallery()),
                          icon: Icon(Icons.folder),
                          label: Text("Pilih dari galeri")
                      ),
                    ],
                  ),
                  SizedBox(height: 20,),
                  BlocBuilder<CameraBloc, CameraState>(
                      builder: (context,state) {
                        final imageFile = state is CameraReady ? state.imageFile : null;

                        return imageFile != null ?
                        Column(
                          children: [
                            SizedBox(
                              width: double.infinity,
                              height: 300,
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Image.file(
                                  imageFile,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Text("Gambar disimpan di : ${imageFile.path}"),
                            ElevatedButton.icon(
                                onPressed: () {
                                  context.read<CameraBloc>().add(DeleteImage());
                                  setState(() {

                                  });
                                },
                                icon: Icon(Icons.delete),
                                label: Text("Hapus Gambar"))
                          ],
                        ) : Padding(
                          padding: EdgeInsets.all(12),
                          child: Text("Belum ada gambar diambil/dipilih"),
                        );
                      }
                  )
                ],
              );
            },
          )
      ),
    );
  }
}
