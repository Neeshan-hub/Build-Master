import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../data/models/sites.dart';
import '../../data/models/stocks.dart';
import '../../main.dart';

part 'sites_event.dart';
part 'sites_state.dart';

class SitesBloc extends Bloc<SitesEvent, SitesState> {
  SitesBloc() : super(SitesInitial()) {
    on<SitesEvent>((event, emit) {});
    on<FailedSiteEvent>(
          (event, emit) => emit(
        FailedSiteState(error: event.error),
      ),
    );
    on<LoadingSiteEvent>(
          (event, emit) => emit(LoadingSiteState()),
    );
    on<LoadingCompleteEvent>(
          (event, emit) => emit(LoadingCompleteState()),
    );
    on<CompletedSiteEvent>(
          (event, emit) => emit(CompletedSiteState(sites: event.sites)),
    );
    on<AddedSiteEvent>(
          (event, emit) => emit(AddedSiteState(message: event.message)),
    );
    on<SiteDataEvent>(
          (event, emit) => emit(SiteDataState(siteData: event.siteData)),
    );
    on<SiteImagesEvent>(
          (event, emit) => emit(SiteImagesState(siteImages: event.siteImages)),
    );
    on<LoadingDeleteCompleteEvent>(
          (event, emit) => emit(LoadingCompleteState()),
    );
    on<LoadingDeleteSiteEvent>(
          (event, emit) => emit(LoadingDeleteSiteState()),
    );
    on<FailedDeleteSiteEvent>(
          (event, emit) => emit(FailedDeleteSiteState()),
    );
    on<UpdatingSiteEvent>(
          (event, emit) => emit(UpdatingSiteState()),
    );
    on<CompleteUpdatingSiteEvent>(
          (event, emit) => emit(CompleteUpdatingSiteState()),
    );
    on<FailedUpdatingSiteEvent>(
          (event, emit) => emit(FailedUpdatingSiteState(error: event.error)),
    );
    on<AddSiteEvent>(addSite);
    on<UpdateSiteEngineersEvent>(updateSiteEngineers);
  }

  CollectionReference sites = FirebaseFirestore.instance.collection("sites");
  CollectionReference notifications =
  FirebaseFirestore.instance.collection("notifications");
  String id = "";

  Future<void> addSite(AddSiteEvent event, Emitter<SitesState> emit) async {
    emit(LoadingSiteState());
    List<String> imageUrls = [];
    String id = sites.doc().id;

    try {
      // Upload images to Firebase Storage and collect URLs
      for (var image in event.images) {
        String? url = await _uploadSupaFile(image, id);

        if (url != null) {
          imageUrls.add(url);
        }
      }
      // Store site data along with image URLs in Firestore
      await sites.doc(id).set({
        "sid": id,
        "sitename": event.siteModel.sitename,
        "sitedesc": event.siteModel.sitedesc,
        "sitelocation": event.siteModel.sitelocation,
        "clientname": event.siteModel.clientname,
        "phone": event.siteModel.phone,
        "supervisor": event.siteModel.supervisor,
        "imageUrls": imageUrls,
        "engineers": [], // Initialize engineers as an empty array
        "lastActivity": FieldValue.serverTimestamp(),
      });

      // Log notification for site addition
      await _logNotification(
        action: "Site Added",
        details: "New site '${event.siteModel.sitename}' created",
        siteId: id,
      );

      add(CompletedSiteEvent());
      add(AddedSiteEvent(message: "Site added successfully"));
    } on FirebaseException catch (e) {
      add(FailedSiteEvent(error: e.message ?? "Failed to add site"));
    } catch (e) {
      add(FailedSiteEvent(error: e.toString()));
    }
  }

  addSiteStock(StockModel stockModel, sid) async {
    add(LoadingSiteEvent());
    try {
      sites.doc(sid).collection("sitestocks").add({
        "sid": sid,
      });
    } on FirebaseException catch (e) {
      add(FailedSiteEvent(error: e.message));
    }
  }

  Future<String?> _uploadFile(XFile image, String siteId) async {
    try {
      File file = File(image.path);
      if (!file.existsSync()) {
        return null;
      }

      String sanitizedName = image.name
          .replaceAll(RegExp(r'[^a-zA-Z0-9._-]'), '_')
          .replaceAll(' ', '_');

      Reference reference = FirebaseStorage.instance
          .ref()
          .child("siteimages")
          .child(siteId)
          .child("${DateTime.now().millisecondsSinceEpoch}_$sanitizedName");

      UploadTask uploadTask = reference.putFile(file);
      TaskSnapshot snapshot = await uploadTask;

      if (snapshot.state == TaskState.success) {
        return await reference.getDownloadURL();
      }
      return null;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<String?> _uploadSupaFile(XFile image, String siteId) async {
    try {
      File file = File(image.path);
      if (!file.existsSync()) {
        return null;
      }

      String sanitizedName = image.name
          .replaceAll(RegExp(r'[^a-zA-Z0-9._-]'), '_')
          .replaceAll(' ', '_');

      String fileName =
          "${DateTime.now().millisecondsSinceEpoch}_$siteId$sanitizedName";

      final supabase = Supabase.instance.client;
      await supabase.storage.from('sites').upload(fileName, file);

      return supabase.storage.from('sites').getPublicUrl(fileName);
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<String?> uploadFile(XFile image, String siteId) async {
    try {
      String sanitizedName = image.name
          .replaceAll(RegExp(r'[^a-zA-Z0-9._-]'), '_')
          .replaceAll(' ', '_');

      Reference reference = FirebaseStorage.instance
          .ref()
          .child("siteimages")
          .child(siteId)
          .child("${DateTime.now().millisecondsSinceEpoch}_$sanitizedName");

      UploadTask uploadTask = reference.putFile(File(image.path));

      TaskSnapshot snapshot = await uploadTask;
      if (snapshot.state == TaskState.success) {
        String downloadUrl = await reference.getDownloadURL();
        return downloadUrl;
      } else {
        print("Upload failed with state: ${snapshot.state}");
        return null;
      }
    } catch (e) {
      print("Error uploading image: $e");
      return null;
    }
  }

  Future<void> deleteSite(
      String sid, List<String> imageurl, String sname, context) async {
    final size = MediaQuery.of(context).size;
    try {
      BotToast.showCustomLoading(
        toastBuilder: (cancelFunc) {
          return customLoading(size);
        },
      );

      Future<QuerySnapshot> siteimages =
      sites.doc(sid).collection("siteimages").get();
      siteimages.then((value) {
        for (QueryDocumentSnapshot element in value.docs) {
          sites.doc(id).collection("siteimages").doc(element.id).delete();
        }
      });
      QuerySnapshot snapshot = await sites.where('sid', isEqualTo: sid).get();
      for (QueryDocumentSnapshot doc in snapshot.docs) {
        await doc.reference.delete();
      }
      for (String url in imageurl) {
        await FirebaseStorage.instance.refFromURL(url).delete();
      }

      // Log notification for site deletion
      await _logNotification(
        action: "Site Deleted",
        details: "Site '$sname' deleted",
        siteId: sid,
      );

      BotToast.closeAllLoading();
      Navigator.of(context).pop();
      BotToast.closeAllLoading();
      BotToast.showText(
        text: "Site Deleted",
        contentColor: Colors.green,
      );
    } on FirebaseException catch (e) {
      BotToast.closeAllLoading();
      Navigator.of(context).pop();
      BotToast.showText(
        text: e.message!,
        contentColor: Colors.red,
      );
    }
  }

  updateSiteInfo({
    required String sid,
    required String sitename,
    required String sitelocation,
    required String clientname,
    required String phone,
    required String sitedesc,
    required String supervisor,
  }) async {
    try {
      add(UpdatingSiteEvent());
      DocumentReference sites =
      FirebaseFirestore.instance.collection("sites").doc(sid);

      await sites.update({
        "sitename": sitename,
        "sitelocation": sitelocation,
        "clientname": clientname,
        "phone": phone,
        "sitedesc": sitedesc,
        "supervisor": supervisor,
        "lastActivity": FieldValue.serverTimestamp(),
      });

      // Log notification for site update
      await _logNotification(
        action: "Site Updated",
        details: "Updated site '$sitename'",
        siteId: sid,
      );

      add(CompleteUpdatingSiteEvent());
    } on FirebaseException catch (e) {
      add(FailedUpdatingSiteEvent(error: e.message));
    }
  }

  Future<void> updateSiteEngineers(
      UpdateSiteEngineersEvent event, Emitter<SitesState> emit) async {
    try {
      emit(UpdatingSiteState());
      DocumentReference sites =
      FirebaseFirestore.instance.collection("sites").doc(event.sid);

      await sites.update({
        "engineers": event.engineers,
        "lastActivity": FieldValue.serverTimestamp(),
      });
      print('updating engineers');
      print(event.engineers);

      // Log notification for engineer assignment
      await _logNotification(
        action: "Engineers Assigned",
        details: "Assigned engineers '${event.engineers.join(", ")}' to site",
        siteId: event.sid,
      );

      emit(CompleteUpdatingSiteState());
    } on FirebaseException catch (e) {
      emit(FailedUpdatingSiteState(error: e.message));
    }
  }

  Future<void> _logNotification({
    required String action,
    required String details,
    required String siteId,
  }) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      final userId = user?.uid ?? "unknown";
      final userName = user?.displayName ?? "unknown";

      await notifications.add({
        "action": action,
        "details": details,
        "siteId": siteId,
        "userId": userId,
        "userName": userName,
        "timestamp": FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print("Error logging notification: $e");
    }
  }
}