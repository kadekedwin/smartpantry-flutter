import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

Future<ImageSource?> showImageSourceSheet(BuildContext context) {
  return showModalBottomSheet<ImageSource>(
    context: context,
    builder: (ctx) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.photo_camera_rounded),
            title: const Text('Kamera'),
            onTap: () => Navigator.pop(ctx, ImageSource.camera),
          ),
          ListTile(
            leading: const Icon(Icons.photo_library_rounded),
            title: const Text('Galeri'),
            onTap: () => Navigator.pop(ctx, ImageSource.gallery),
          ),
        ],
      ),
    ),
  );
}
