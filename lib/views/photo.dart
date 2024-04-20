import 'dart:io';

import 'package:camera/camera.dart';
import 'package:crop_your_image/crop_your_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lingolearn/controllers/photoProvider.dart';

class TakePictureScreen extends StatefulWidget {
  const TakePictureScreen({
    super.key,
  });

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  bool init = false;

  @override
  void initState() {
    super.initState();
    initialize();
  }

  initialize() async {
    final cameras = await availableCameras();
    final camera = cameras.first;
    // To display the current output from the Camera,
    // create a CameraController.
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      camera,
      // Define the resolution to use.
      ResolutionPreset.medium,
    );

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
    setState(() {
      init = true;
    });
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Take a picture')),
      // You must wait until the controller is initialized before displaying the
      // camera preview. Use a FutureBuilder to display a loading spinner until the
      // controller has finished initializing.
      body: init
          ? FutureBuilder<void>(
              future: _initializeControllerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  // If the Future is complete, display the preview.
                  return CameraPreview(_controller);
                } else {
                  // Otherwise, display a loading indicator.
                  return const Center(child: CircularProgressIndicator());
                }
              },
            )
          : const CircularProgressIndicator(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue.shade900,
        // Provide an onPressed callback.
        onPressed: () async {
          // Take the Picture in a try / catch block. If anything goes wrong,
          // catch the error.
          try {
            // Ensure that the camera is initialized.
            await _initializeControllerFuture;

            // Attempt to take a picture and get the file `image`
            // where it was saved.
            final image = await _controller.takePicture();

            if (!context.mounted) return;

            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => Edit(
                  // Pass the automatically generated path to
                  // the DisplayPictureScreen widget.
                  image.path,
                ),
              ),
            );
          } catch (e) {
            // If an error occurs, log the error to the console.
            // print(e);
          }
        },
        child: const Icon(
          Icons.camera_alt,
          color: Colors.white,
        ),
      ),
    );
  }
}

// A widget that displays the picture taken by the user.
class Edit extends ConsumerStatefulWidget {
  const Edit(this.imagePath, {super.key});
  final String imagePath;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EditState();
}

class _EditState extends ConsumerState<Edit> {
  final _controller = CropController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Photo')),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: Crop(
        image: File(widget.imagePath).readAsBytesSync(),
        controller: _controller,
        onCropped: (image) async {
          File newImg =
              await File(widget.imagePath).writeAsBytes(image, flush: true);
          ref.read(photoProvider.notifier).state = newImg.path;
          context.go('/grammar_correction');
        },
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue.shade900,
        child: const Icon(
          Icons.check,
          color: Colors.white,
        ),
        onPressed: () {
          _controller.crop();
        },
      ),
    );
  }
}
