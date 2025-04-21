import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:construction/bloc/workinprogress/workinprogress_bloc.dart';
import 'package:construction/main.dart';
import 'package:construction/presentation/includes/appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../bloc/pickimage/pickimage_bloc.dart';
import '../../../utils/app_colors.dart';

class WorkImagesPage extends StatefulWidget {
  const WorkImagesPage({super.key});

  @override
  State<WorkImagesPage> createState() => _WorkImagesPageState();
}

class _WorkImagesPageState extends State<WorkImagesPage> {
  List<XFile> selectedImages = [];
  final ImagePicker _picker = ImagePicker();
  String? _fullScreenImageUrl;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final padding = MediaQuery.of(context).padding;
    final Map<String, dynamic> args =
    ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final siteimageBloc = BlocProvider.of<PickimageBloc>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size(size.width, size.height * 0.09),
        child: CustomAppbar(
          title: "${args["title"]}",
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ).customAppBar(),
      ),
      body: Stack(
        children: [
          Container(
            height: size.height,
            width: size.width,
            padding: EdgeInsets.symmetric(horizontal: padding.top * 0.5, vertical: padding.top * 0.3),
            // decoration: BoxDecoration(
            //   gradient: LinearGradient(
            //     begin: Alignment.bottomCenter,
            //     end: Alignment.topCenter,
            //     colors: [AppColors.blue.withOpacity(0.051), Colors.white],
            //   ),
            // ),
            child: StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("sites")
                  .doc(args['sid'])
                  .collection("works")
                  .doc(args['wid'])
                  .snapshots(),
              builder: (context, snapshot) {
                List<String> existingImages = [];
                if (snapshot.hasData) {
                  final data = snapshot.data!.data() as Map<String, dynamic>?;
                  existingImages = List<String>.from(data?['images'] ?? []);
                }

                return ListView(
                  children: [
                    _buildImagePickerButton(size),
                    if (selectedImages.isNotEmpty) ...[
                      SizedBox(height: size.height * 0.02),
                      _buildSelectedImagesGrid(size),
                    ],
                    SizedBox(height: size.height * 0.02),
                    _buildExistingImagesSection(size, existingImages, args),
                    SizedBox(height: size.height * 0.02),
                    _buildUploadButton(context, args),
                  ],
                );
              },
            ),
          ),
          if (_fullScreenImageUrl != null)
            _buildFullScreenImageViewer(),
        ],
      ),
    );
  }

  Widget _buildImagePickerButton(Size size) {
    return GestureDetector(
      onTap: () async {
        final List<XFile>? images = await _picker.pickMultiImage();
        if (images != null) {
          setState(() {
            selectedImages.addAll(images);
          });
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: size.height * 0.02),
        decoration: BoxDecoration(
          color: AppColors.blue.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.blue.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_a_photo, color: AppColors.blue, size: 28),
            SizedBox(width: size.width * 0.03),
            Text(
              "Add Site Images",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedImagesGrid(Size size) {
    return Container(
      padding: EdgeInsets.all(size.width * 0.02),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Selected Images",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.blue,
            ),
          ),
          SizedBox(height: size.height * 0.01),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: selectedImages.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 1,
            ),
            itemBuilder: (context, index) {
              return Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                        image: FileImage(File(selectedImages[index].path)),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 4,
                    right: 4,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedImages.removeAt(index);
                        });
                      },
                      child: CircleAvatar(
                        radius: 12,
                        backgroundColor: AppColors.red,
                        child: Icon(Icons.close, size: 14, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildExistingImagesSection(Size size, List<String> existingImages, Map<String, dynamic> args) {
    return Container(
      padding: EdgeInsets.all(size.width * 0.02),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Existing Images",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.blue,
            ),
          ),
          SizedBox(height: size.height * 0.01),
          existingImages.isEmpty
              ? Center(
            child: Text(
              "No images uploaded yet",
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          )
              : GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: existingImages.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 1,
            ),
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _fullScreenImageUrl = existingImages[index];
                  });
                },
                child: CachedNetworkImage(
                  imageUrl: existingImages[index],
                  fit: BoxFit.cover,
                  imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  placeholder: (context, url) => Center(
                    child: CircularProgressIndicator(
                      color: AppColors.blue,
                    ),
                  ),
                  errorWidget: (context, url, error) => Icon(
                    Icons.error,
                    color: AppColors.red,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildUploadButton(BuildContext context, Map<String, dynamic> args) {
    return BlocConsumer<WorkinprogressBloc, WorkinprogressState>(
      listener: (context, state) {
        if (state is UploadingWorkImagesState) {
          BotToast.showCustomLoading(
            toastBuilder: (cancelFunc) => customLoading(MediaQuery.of(context).size),
          );
        }
        if (state is FailedUploadingWorkImagesState) {
          BotToast.closeAllLoading();
          BotToast.showText(
            text: state.error!,
            contentColor: AppColors.red,
          );
        }
        if (state is CompletedUploadingWorkImagesState) {
          BotToast.closeAllLoading();
          BotToast.showText(
            text: "Upload Successful",
            contentColor: AppColors.green,
          );
          setState(() {
            selectedImages.clear();
          });
        }
      },
      builder: (context, state) {
        return ElevatedButton(
          onPressed: selectedImages.isEmpty
              ? null
              : () {
            BlocProvider.of<WorkinprogressBloc>(context)
                .uploadWorkImagesSupa(selectedImages, args['sid'], args['wid']);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.blue,
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 3,
          ),
          child: Text(
            "Upload Images",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        );
      },
    );
  }

  Widget _buildFullScreenImageViewer() {
    return Container(
      color: Colors.black.withOpacity(0.9),
      child: Stack(
        children: [
          Center(
            child: CachedNetworkImage(
              imageUrl: _fullScreenImageUrl!,
              fit: BoxFit.contain,
              placeholder: (context, url) => CircularProgressIndicator(
                color: AppColors.blue,
              ),
              errorWidget: (context, url, error) => Icon(
                Icons.error,
                color: AppColors.red,
              ),
            ),
          ),
          Positioned(
            top: 16,
            right: 16,
            child: IconButton(
              icon: CircleAvatar(
                radius: 16,
                backgroundColor: AppColors.red,
                child: Icon(Icons.close, color: Colors.white, size: 18),
              ),
              onPressed: () {
                setState(() {
                  _fullScreenImageUrl = null;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Updated upload function
extension WorkInProgressBlocExtension on WorkinprogressBloc {
  Future<void> uploadWorkImagesSupa(List<XFile> images, String sid, String wid) async {
    if (images.isEmpty) {
      add(FailedUploadingWorkImagesEvent(error: "No images selected"));
      return;
    }

    try {
      add(UploadingWorkImagesEvent());

      final supabase = Supabase.instance.client;
      List<String> imgUrls = [];

      for (var image in images) {
        File file = File(image.path);
        if (!file.existsSync()) {
          continue;
        }

        String sanitizedName = image.name
            .replaceAll(RegExp(r'[^a-zA-Z0-9._-]'), '_')
            .replaceAll(' ', '_');

        String fileName =
            "${DateTime.now().millisecondsSinceEpoch}_$sid$sanitizedName";

        await supabase.storage.from('sites-wip').upload(fileName, file);
        final imgUrl = supabase.storage.from('sites-wip').getPublicUrl(fileName);
        imgUrls.add(imgUrl);
      }

      if (imgUrls.isNotEmpty) {
        await FirebaseFirestore.instance
            .collection("sites")
            .doc(sid)
            .collection("works")
            .doc(wid)
            .update({
          "images": FieldValue.arrayUnion(imgUrls),
        });

        add(CompletedUploadingWorkImagesEvent());
      } else {
        add(FailedUploadingWorkImagesEvent(error: "No valid images to upload"));
      }
    } catch (e) {
      add(FailedUploadingWorkImagesEvent(error: e.toString()));
    }
  }
}