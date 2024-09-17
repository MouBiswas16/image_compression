// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_native_image/flutter_native_image.dart';

class CompressedImage extends StatefulWidget {
  const CompressedImage({super.key});

  @override
  State<CompressedImage> createState() => _CompressedImageState();
}

class _CompressedImageState extends State<CompressedImage> {
  File? fileImage;
  Future<File> customCompressed(
      {@required imagePathToCompress, // File type data
      quality = 100,
      percentage = 10}) async {
    var path = FlutterNativeImage.compressImage(
      imagePathToCompress.absolute.path,
      quality: 100,
      percentage: 10,
    );
    return path;
  }

  pickImage() async {
    XFile? file = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    // convert into File
    File image = File(file!.path);
    final sizeInKbBefore = image.lengthSync() / 1024;
    print("before compressed ${sizeInKbBefore}kb");
    File compressedImage = await customCompressed(imagePathToCompress: image);
    final sizeInKb = compressedImage.lengthSync() / 1024;
    print("after compressed ${sizeInKb}");
    setState(() {
      fileImage = compressedImage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            "Compressed Image before Upload to Firebase/Supabase or Server"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          SizedBox(height: 200),
          Center(
            child: SizedBox(
              height: 30,
              width: 150,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  textStyle: TextStyle(
                    color: Colors.white,
                  ),
                ),
                onPressed: () {
                  pickImage();
                },
                child: Text("Upload Image"),
              ),
            ),
          ),
          SizedBox(height: 20),
          Center(
            child: Text("Show Image"),
          ),
          SizedBox(height: 10),
          fileImage != null
              ? Center(
                  child: Image.file(
                    fileImage!,
                    height: 200,
                  ),
                )
              : SizedBox.shrink(),
        ],
      ),
    );
  }
}
