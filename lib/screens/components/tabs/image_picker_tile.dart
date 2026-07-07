import 'dart:io';
import 'package:flutter/material.dart';

class ImagePickerTile extends StatelessWidget {
  final File? file;
  final VoidCallback onTap;

  const ImagePickerTile({super.key, required this.file, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        height: 160,
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFFF0FDF4),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        clipBehavior: Clip.antiAlias,
        child: file == null
            ? const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.photo_camera_rounded,
                    size: 36,
                    color: Color(0xFF0F9F68),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Tambahkan foto barang',
                    style: TextStyle(
                      fontSize: 13,
                      color: Color(0xFF0F9F68),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Kamera / Galeri',
                    style: TextStyle(fontSize: 11, color: Color(0xFF6B7280)),
                  ),
                ],
              )
            : Stack(
                fit: StackFit.expand,
                children: [
                  Image.file(file!, fit: BoxFit.cover),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.55),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.edit_rounded,
                            size: 14,
                            color: Colors.white,
                          ),
                          SizedBox(width: 4),
                          Text(
                            'Ganti',
                            style: TextStyle(fontSize: 11, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
