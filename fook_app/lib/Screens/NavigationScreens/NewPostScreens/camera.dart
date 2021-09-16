import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:fook_app/Controllers/Providers/collectionController.dart';
import 'package:provider/provider.dart';
import 'newTokkenPreview.dart';

List<CameraDescription>? cameras;

class Camera extends StatefulWidget {
  @override
  _CameraState createState() => _CameraState();
}

class _CameraState extends State<Camera> {
  CameraController? _controller;
  Future<void>? cameraValue;
  int selectedCamera = 0;
  @override
  void initState() {
    print('test');
    super.initState();
    _controller = CameraController(
      cameras![0],
      ResolutionPreset.ultraHigh,
      imageFormatGroup: ImageFormatGroup.yuv420,
    );
    _controller?.initialize().then((_) {
      if (!mounted) {
        return;
      }

      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userCollections =
        Provider.of<CollectionController>(context, listen: false);
    return Scaffold(
      body: !(_controller!.value.isInitialized)
          ? Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: CameraPreview(_controller!)),
                Positioned(
                  top: 22,
                  right: 20,
                  child: IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(Icons.close),
                    color: Colors.white,
                  ),
                ),
                Positioned(
                  left: 20,
                  bottom: 0,
                  child: Container(
                    //color: Colors.white,
                    width: MediaQuery.of(context).size.width,
                    height: 150,
                    // child: Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    // Padding(
                    //   padding: const EdgeInsets.only(left: 50, bottom: 35),
                    //   child: InkWell(
                    //     splashColor: Colors.amber,
                    //     child: ImageIcon(
                    //       AssetImage('lib/Assets/record.png'),
                    //       color: Colors.red,
                    //       size: 100,
                    //     ),

                    //   ),
                    // ),
                    child: Padding(
                      padding: const EdgeInsets.only(right: 50, bottom: 35),
                      child: InkWell(
                        child: ImageIcon(
                          AssetImage('lib/Assets/camera.png'),
                          color: Colors.white,
                          size: 100,
                        ),
                        onTap: () async {
                          try {
                            await cameraValue;
                            final image = await _controller?.takePicture();

                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => TokkenPreviewScreen(
                                  collectionNames:
                                      userCollections.collectionNames,
                                  image: image!,
                                ),
                              ),
                            );
                          } catch (e) {
                            print(e);
                          }
                        },
                      ),
                    ),
                    //],
                    //),
                  ),
                ),
              ],
            ),
    );
  }
}
