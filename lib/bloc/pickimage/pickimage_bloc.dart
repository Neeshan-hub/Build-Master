import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:image_picker/image_picker.dart';

import 'package:meta/meta.dart'; // Add this import for @immutable
import 'package:image_picker/image_picker.dart';

part 'pickimage_event.dart';
part 'pickimage_state.dart';

class PickimageBloc extends Bloc<PickimageEvent, PickimageState> {
  PickimageBloc() : super(PickimageState()) {
    on<OnSelectImage>((event, emit) {
      // Validate images before emitting
      List<XFile>? validImages = event.siteimage?.where((xfile) {
        File file = File(xfile.path);
        return file.existsSync() && file.lengthSync() > 0;
      }).toList();
      emit(PickimageState(siteimage: validImages));
    });

    on<RemoveImageEvent>((event, emit) {
      List<XFile> updatedImages = List.from(state.siteimage ?? []);
      if (event.index >= 0 && event.index < updatedImages.length) {
        updatedImages.removeAt(event.index);
        emit(PickimageState(siteimage: updatedImages));
      }
    });

    on<ClearImagesEvent>((event, emit) {
      emit(PickimageState(siteimage: []));
    });
  }

  Future<void> pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final List<XFile>? images = await picker.pickMultiImage();
      if (images != null && images.isNotEmpty) {
        add(OnSelectImage(siteimage: images));
      }
    } catch (e) {
      print("Error picking images: $e");
    }
  }
}
