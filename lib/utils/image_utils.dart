import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';

Future<void> capturePng({GlobalKey widgetKey}) async {
  final RenderRepaintBoundary boundary =
      widgetKey.currentContext.findRenderObject() as RenderRepaintBoundary;
  final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
  final ByteData byteData =
      await image.toByteData(format: ui.ImageByteFormat.png);
  await writeByteToImageFile(byteData);
}

Future<String> writeByteToImageFile(ByteData byteData) async {
  final Directory dir = Platform.isAndroid
      ? await getExternalStorageDirectory()
      : await getApplicationDocumentsDirectory();
  final File imageFile = File('${dir.path}/screenshot.png');
  // ignore: avoid_slow_async_io
  if (await imageFile.exists()) {
    imageFile.delete();
  }

  imageFile.createSync(recursive: true);
  imageFile.writeAsBytesSync(byteData.buffer.asUint8List(0));
  return imageFile.path;
}
