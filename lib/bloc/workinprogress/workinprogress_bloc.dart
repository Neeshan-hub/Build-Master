import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:construction/data/models/works.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'workinprogress_event.dart';

part 'workinprogress_state.dart';

class WorkinprogressBloc
    extends Bloc<WorkinprogressEvent, WorkinprogressState> {
  WorkinprogressBloc() : super(WorkinprogressInitial()) {
    on<WorkinprogressEvent>((event, emit) {});
    on<AddingWorkEvent>(
      (event, emit) {
        emit(AddingWorkState());
      },
    );
    on<CompletedAddingWorkEvent>(
      (event, emit) {
        emit(CompletedAddingWorkState());
      },
    );
    on<FailedAddingWorkEvent>(
      (event, emit) {
        emit(FailedAddingWorkState(error: event.error));
      },
    );
    on<CompleteUpdatingWorkProgressEvent>(
      (event, emit) {
        emit(CompleteUpdatingWorkProgressState());
      },
    );
    on<UpdatingWorkProgressEvent>(
      (event, emit) {
        emit(UpdatingWorkProgressState());
      },
    );
    on<FailedUpdatingWorkProgressEvent>(
      (event, emit) {
        emit(FailedUpdatingWorkProgressState(error: event.error));
      },
    );
    on<CompleteUpdatingWorkInfoEvent>(
      (event, emit) {
        emit(CompleteUpdatingWorkInfoState());
      },
    );
    on<UpdatingWorkInfoEvent>(
      (event, emit) {
        emit(UpdatingWorkInfoState());
      },
    );
    on<FailedUpdatingWorkInfoEvent>(
      (event, emit) {
        emit(FailedUpdatingWorkInfoState(error: event.error));
      },
    );
    on<CompleteDeletingWorkInfoEvent>(
      (event, emit) {
        emit(CompleteDeletingWorkInfoState());
      },
    );
    on<DeletingWorkInfoEvent>(
      (event, emit) {
        emit(DeletingWorkInfoState());
      },
    );
    on<DeletingWorkImagesEvent>(
      (event, emit) {
        emit(DeletingWorkImagesState());
      },
    );
    on<CompletedDeletingWorkImagesEvent>(
      (event, emit) {
        emit(CompletedDeletingWorkImagesState());
      },
    );
    on<FailedDeletingWorkImagesEvent>(
      (event, emit) {
        emit(FailedDeletingWorkImagesState(error: event.error));
      },
    );
    on<FailedUploadingWorkImagesEvent>(
      (event, emit) {
        emit(FailedUploadingWorkImagesState(error: event.error));
      },
    );
    on<UploadingWorkImagesEvent>(
      (event, emit) {
        emit(UploadingWorkImagesState());
      },
    );
    on<CompletedUploadingWorkImagesEvent>(
      (event, emit) {
        emit(CompletedUploadingWorkImagesState());
      },
    );
  }

  deleteWork(String sid, String wid) async {
    add(DeletingWorkInfoEvent());
    try {
      DocumentReference works = FirebaseFirestore.instance
          .collection('sites')
          .doc(sid)
          .collection("works")
          .doc(wid);
      await works.delete();
      add(CompleteDeletingWorkInfoEvent());
    } on FirebaseException catch (e) {
      add(FailedDeletingWorkProgressEvent(error: e.message!));
    }
  }

 // uploadWorkImagesSupa(
 //      List<XFile> images, String sid, String wid) async {
 //    try {
 //      List<String> imgUrls = [];
 //      images.forEach((image)async{
 //        File file = File(image.path);
 //        if (!file.existsSync()) {
 //          print('image 2 re');
 //          return null;
 //        }
 //        String sanitizedName = image.name
 //            .replaceAll(RegExp(r'[^a-zA-Z0-9._-]'), '_')
 //            .replaceAll(' ', '_');
 //
 //        String fileName =
 //            "${DateTime.now().millisecondsSinceEpoch}_$sid$sanitizedName";
 //        final supabase = Supabase.instance.client;
 //        await supabase.storage.from('sites_WIP').upload(fileName, file);
 //        var img = supabase.storage.from('sites_WIP').getPublicUrl(fileName);
 //        imgUrls.add(img);
 //
 //      });
 //
 //      FirebaseFirestore.instance
 //          .collection("sites")
 //          .doc(sid)
 //          .collection("works")
 //          .doc(wid)
 //          .update({
 //        "images": FieldValue.arrayUnion(imgUrls),
 //      }).whenComplete((){      add(CompletedUploadingWorkImagesEvent());
 //      });
 //    } catch (e) {
 //      print(e);
 //      add(FailedUploadingWorkImagesEvent(error: e.toString()));
 //
 //    }
 //  }

  addWorkImages(String sid, String wid, List<XFile> images) async {
    add(UploadingWorkImagesEvent());
    List<dynamic> imageUrls = [];

    try {
      for (int i = 0; i < images.length; i++) {
        var url = uploadWorkImageFile(images[i], sid, wid);
        imageUrls.add(url.toString());
      }

      add(CompletedUploadingWorkImagesEvent());
    } on FirebaseException catch (e) {}
  }

  uploadWorkImageFile(XFile image, String sid, String wid) async {
    Reference reference =
        FirebaseStorage.instance.ref().child("workimages").child(image.name);
    UploadTask uploadTask = reference.putFile(File(image.path));
    await uploadTask.whenComplete(() async {
      FirebaseFirestore.instance
          .collection("sites")
          .doc(sid)
          .collection("works")
          .doc(wid)
          .collection("images")
          .add({
        "sid": sid,
        "wid": wid,
        "date": DateTime.now(),
        "image": await reference.getDownloadURL(),
      });
    });
    return await reference.getDownloadURL();
  }

  addWork(WorksModel worksModel, String sid) async {
    add(AddingWorkEvent());
    try {
      CollectionReference works = FirebaseFirestore.instance
          .collection('sites')
          .doc(sid)
          .collection("works");
      String wid = works.doc().id;
      works.doc(wid).set({
        "sid": sid,
        "wid": wid,
        "title": worksModel.title,
        "startdate": worksModel.startdate,
        "endDate": worksModel.endDate,
        "workdesc": worksModel.workdesc,
        "progress": num.parse("0.0"),
      });
      add(CompletedAddingWorkEvent());
    } on FirebaseException catch (e) {
      add(FailedAddingWorkEvent(error: e.message));
    }
  }

  updateWorkProgress(double progress, String wid, String sid) async {
    try {
      add(UpdatingWorkProgressEvent());
      DocumentReference workDoc = FirebaseFirestore.instance
          .collection("sites")
          .doc(sid)
          .collection("works")
          .doc(wid);
      await workDoc.update({
        "progress": progress,
      });
      add(CompleteUpdatingWorkProgressEvent());
    } on FirebaseException catch (e) {
      add(
        FailedUpdatingWorkProgressEvent(error: e.message!),
      );
    }
  }

  updateWorkInfo(WorksModel worksModel, String sid) async {
    try {
      add(UpdatingWorkInfoEvent());
      DocumentReference workDoc = FirebaseFirestore.instance
          .collection("sites")
          .doc(sid)
          .collection("works")
          .doc(worksModel.wid);
      await workDoc.update({
        "title": worksModel.title,
        "startdate": worksModel.startdate,
        "endDate": worksModel.endDate,
      });
      if (worksModel.workdesc != null) {
        await workDoc.update({
          "workdesc": worksModel.workdesc,
        });
      }

      add(CompleteUpdatingWorkInfoEvent());
    } on FirebaseException catch (e) {
      add(
        FailedUpdatingWorkInfoEvent(error: e.message!),
      );
    }
  }
}
