part of 'sites_bloc.dart';

abstract class SitesEvent {}

class FailedSiteEvent extends SitesEvent {
  final String? error;
  FailedSiteEvent({this.error});
}

class LoadingSiteEvent extends SitesEvent {}

class LoadingCompleteEvent extends SitesEvent {}

class CompletedSiteEvent extends SitesEvent {
  final List<dynamic>? sites;
  CompletedSiteEvent({this.sites});
}

class AddedSiteEvent extends SitesEvent {
  final String? message;
  AddedSiteEvent({this.message});
}

class SiteDataEvent extends SitesEvent {
  final Map<String, dynamic>? siteData;
  SiteDataEvent({this.siteData});
}

class SiteImagesEvent extends SitesEvent {
  final List<dynamic>? siteImages;
  SiteImagesEvent({this.siteImages});
}

class LoadingDeleteCompleteEvent extends SitesEvent {}

class LoadingDeleteSiteEvent extends SitesEvent {}

class FailedDeleteSiteEvent extends SitesEvent {}

class UpdatingSiteEvent extends SitesEvent {}

class CompleteUpdatingSiteEvent extends SitesEvent {}

class FailedUpdatingSiteEvent extends SitesEvent {
  final String? error;
  FailedUpdatingSiteEvent({this.error});
}

class AddSiteEvent extends SitesEvent {
  final SiteModel siteModel;
  final List<XFile> images;
  AddSiteEvent(this.siteModel, this.images);
}

class UpdateSiteEngineersEvent extends SitesEvent {
  final String sid;
  final String siteName;
  final List<Map<String, String>> engineers;
  UpdateSiteEngineersEvent({required this.sid,required this.siteName, required this.engineers});
}