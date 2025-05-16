part of 'sites_bloc.dart';



@immutable
abstract class SitesState {}

class SitesInitial extends SitesState {}

class LoadingSiteState extends SitesState {}

class LoadingCompleteState extends SitesState {}

class FailedSiteState extends SitesState {
  final String? error;

  FailedSiteState({this.error});
}

class AddedSiteState extends SitesState {
  final String? message;

  AddedSiteState({this.message});
}

class CompletedSiteState extends SitesState {
  final List<SiteModel>? sites;

  CompletedSiteState({this.sites});
}

class SiteDataState extends SitesState {
  final Map<String, dynamic>? siteData;

  SiteDataState({this.siteData});
}

class SiteImagesState extends SitesState {
  final List<String>? siteImages;

  SiteImagesState({this.siteImages});
}

class LoadingDeleteSiteState extends SitesState {}

class FailedDeleteSiteState extends SitesState {
  final String? error;

  FailedDeleteSiteState({this.error});
}

class LoadingDeleteCompleteState extends SitesState {}

class UpdatingSiteState extends SitesState {}

class CompleteUpdatingSiteState extends SitesState {}

class FailedUpdatingSiteState extends SitesState {
  final String? error;

  FailedUpdatingSiteState({this.error});
}

class AddingSiteImageState extends SitesState {}

class AddedSiteImageState extends SitesState {}

class FailedAddingSiteImageState extends SitesState {
  final String? error;

  FailedAddingSiteImageState({this.error});
}