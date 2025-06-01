import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../main.dart';

class ImageManager {
  static Future<File> pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);

      if (image == null) return File("");

      final imageTemp = File(image.path);
      // return cropImage(imageTemp);
      return imageTemp;
    } on PlatformException catch (e) {
      var status = await Permission.storage.status;
      if (Platform.isIOS) {
        await showDialogPermission("You did not allow photo access",
            'Allow Application to access photo on your device?');
      }
      return File("");
    }
  }

  static showDialogPermission(String title, String content) async {
    await showCupertinoDialog(
        context: GlobalVariable.navState.currentContext!,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text(title),
            content: Text(content),
            actions: <Widget>[
              CupertinoDialogAction(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              CupertinoDialogAction(
                child: const Text('Settings'),
                onPressed: () async {
                  await openAppSettings();
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }
}
