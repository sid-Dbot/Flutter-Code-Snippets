Future<void> _captureAndSharePng() async {
  try {
    RenderRepaintBoundary boundary =
        globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    var image = await boundary.toImage();
    ByteData? byteData = await image.toByteData(format: ImageByteFormat.png);
    Uint8List pngBytes = byteData!.buffer.asUint8List();

    // final directory = await getDownloadsDirectory();
    if (Platform.isIOS) {
      final iosDir = await getApplicationDocumentsDirectory();
      extDir = iosDir.path;
    }

    String fileName = 'qr';
    int i = 1;

    while (await File('${extDir}/$fileName.png').exists()) {
      fileName = 'qr_$i';
      i++;
    }

    // dirExists = await File(extDir).exists();
    // if (!dirExists) {
    //   await Directory(extDir).create(recursive: true);
    //   dirExists = true;
    // }

    final file = await File('${extDir}/$fileName.png').create();
    await file.writeAsBytes(pngBytes);

    final result = await Share.shareXFiles([XFile('${extDir}/$fileName.png')],
        text: 'My QR');
    print(result.raw);
    print(result.status);
    if (result.status == ShareResultStatus.success) {
      showSnackBar(
          title: 'Success',
          message: 'Success!',
          color: kCreditColor,
          icon: Icons.done);
    }
  } catch (e) {
    // if (mounted) {
    //   ScaffoldMessenger.of(context)
    //       .showSnackBar(SnackBar(content: Text('Something went wrong!!')));
    // }
    print(e.toString());
  }
}

//-----------with ImageGallerySaver package________________________

Future<void> _captureAndSavePng() async {
  try {
    RenderRepaintBoundary boundary =
        globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    var image = await boundary.toImage();
    ByteData? byteData = await image.toByteData(format: ImageByteFormat.png);
    Uint8List pngBytes = byteData!.buffer.asUint8List();

    String fileName = 'qr';
    int i = 1;
    if (Platform.isIOS) {
      // final iosDir = await getApplicationDocumentsDirectory();
      // extDir = iosDir.path;

      final result = await ImageGallerySaver.saveImage(pngBytes,
          name: '$fileName', quality: 100);
      if (mounted) {
        showSnackBar(
            title: 'Success',
            message: 'QR saved successfully!',
            color: kCreditColor,
            icon: Icons.done);
      }

      // setState(() {});
    } else {
      while (await File('${extDir}/$fileName.png').exists()) {
        fileName = 'qr_$i';
        i++;
      }

      // dirExists = await File(extDir).exists();
      // if (!dirExists) {
      //   await Directory(extDir).create(recursive: true);
      //   dirExists = true;
      // }

      final file =
          await File('${extDir}/$fileName.png').create(recursive: true);

      await file.writeAsBytes(pngBytes);
      if (mounted) {
        showSnackBar(
            title: 'Success',
            message: 'QR saved successfully!',
            color: kCreditColor,
            icon: Icons.done);
      }
    }
  } catch (e) {
    if (mounted) {
      showSnackBar(
          message: 'Something went wrong!!',
          color: kDebitColor,
          icon: Icons.error);
    }
    print(e.toString());
  }
}
