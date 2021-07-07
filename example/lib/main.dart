import 'dart:io';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:image_picker/image_picker.dart' as im;
import 'package:instagram_share_plus/instagram_share_plus.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(MyApp());
}

enum Type { image, video }

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Instagram Share Plus'),
        ),
        body: const HomePage(),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _permissionGranted = false;

// TODO: Ask for Permission
  @override
  void initState() {
    _requestPermission();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        if (!_permissionGranted)
          Container(
            child: Column(
              children: [
                Center(
                  child: Text(
                    'You have disabled access to the photos, please enable in settings.',
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  height: 24,
                ),
                TextButton(
                    onPressed: () => openAppSettings(),
                    child: Text('Enable Again'))
              ],
            ),
          )
        else
          Column(
            children: [
              TextButton(
                onPressed: () => _shareToInstagram(type: Type.video),
                child: Text('Share video to Instagram'),
              ),
              TextButton(
                onPressed: () => _shareToInstagram(type: Type.image),
                child: Text('Share image to Instagram'),
              ),
            ],
          )
      ],
    );
  }

  Future<String?> _shareToInstagram({required Type type}) async {
    try {
      if (Platform.isIOS) {
        String? _status = await InstagramSharePlus.shareInstagram();
        return _status;
      }

      im.PickedFile? file;
      //TODO : Refactor - implement picker inside native code?
      switch (type) {
        case Type.image:
          file =
              await im.ImagePicker().getImage(source: im.ImageSource.gallery);
          break;
        case Type.video:
          file =
              await im.ImagePicker().getVideo(source: im.ImageSource.gallery);
          break;
      }

      String? _status = await InstagramSharePlus.shareInstagram(
          path: file!.path, type: EnumToString.convertToString(type));
      print(_status);

      return _status;
    } on Exception catch (_) {
      return null;
    }
  }

  _requestPermission() async {
    if (Platform.isAndroid) {
      if (await Permission.storage.request().isGranted) {
        setState(() {
          _permissionGranted = true;
        });
      } else {
        setState(() {
          _permissionGranted = false;
        });
      }
    } else if (Platform.isIOS) {
      if (await Permission.photos.request().isGranted) {
        setState(() {
          _permissionGranted = true;
        });
      } else {
        setState(() {
          _permissionGranted = false;
        });
      }
    }
  }
}
