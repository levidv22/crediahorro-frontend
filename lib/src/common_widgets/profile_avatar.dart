import 'dart:io';
import 'package:flutter/material.dart';

class ProfileAvatar extends StatelessWidget {
  final String? imagePath;
  final double size;
  final VoidCallback? onTap;

  const ProfileAvatar({super.key, this.imagePath, this.size = 70, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        radius: size / 2,
        backgroundColor: Colors.white,
        backgroundImage: imagePath != null && imagePath!.isNotEmpty
            ? FileImage(File(imagePath!)) as ImageProvider
            : const AssetImage('assets/img/default_avatar.png'),
      ),
    );
  }
}
