import 'dart:async';
import 'dart:io';

import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart' as im;
import 'package:instagram_share_plus/instagram_share_plus.dart';

void main() {
  runApp(MyApp());
}

enum Type { image, video }

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
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

      im.XFile? file = switch (type) {
        Type.image =>
          await im.ImagePicker().pickImage(source: im.ImageSource.gallery),
        Type.video =>
          await im.ImagePicker().pickVideo(source: im.ImageSource.gallery),
      };

      return await InstagramSharePlus.shareInstagram(
        path: file!.path,
        type: EnumToString.convertToString(type),
      );
    } on Exception catch (_) {
      return null;
    }
  }
}
