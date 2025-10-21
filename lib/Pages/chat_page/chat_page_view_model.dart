import 'dart:io';
import 'dart:ui';

import 'package:image_picker/image_picker.dart';
import 'package:reins/Services/services.dart';

class ChatPageViewModel {
  final OllamaService _ollamaService;
  final DatabaseService _databaseService;
  final PermissionService _permissionService;
  final ImageService _imageService;

  ChatPageViewModel({
    required OllamaService ollamaService,
    required DatabaseService databaseService,
    required PermissionService permissionService,
    required ImageService imageService,
  })  : _ollamaService = ollamaService,
        _databaseService = databaseService,
        _permissionService = permissionService,
        _imageService = imageService;

  /// Handles image picking and compression
  Future<List<File>> pickImages({
    VoidCallback? onPermissionDenied,
    int quality = 10,
  }) async {
    // Check permissions
    final hasPermission = await _permissionService.requestPhotoPermission(
      onDenied: onPermissionDenied,
    );
    if (!hasPermission) return [];

    // Pick images
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(
      source: ImageSource.gallery,
    );
    // await _picker.pickMultiImage(limit: maxImages);

    if (pickedImage == null) return [];

    // Compress and save
    final compressedFile = await _imageService.compressAndSave(
      pickedImage.path,
      quality: quality,
    );

    // Add an empty path if the image could not be compressed to show error
    return compressedFile != null ? [compressedFile] : [File('')];
  }

  /// Deletes a single image
  Future<void> deleteImage(File imageFile) async {
    await _imageService.deleteImage(imageFile);
  }

  /// Deletes multiple images
  Future<void> deleteImages(List<File> imageFiles) async {
    await _imageService.deleteImages(imageFiles);
  }
}
