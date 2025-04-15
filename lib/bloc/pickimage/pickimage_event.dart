part of 'pickimage_bloc.dart';

@immutable
class PickimageEvent {}

class OnSelectImage extends PickimageEvent {
  final List<XFile>? siteimage;
  OnSelectImage({this.siteimage});
}
class RemoveImageEvent extends PickimageEvent {
  final int index;
  RemoveImageEvent(this.index);
}

class ClearImagesEvent extends PickimageEvent {}