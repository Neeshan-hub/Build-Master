part of 'orders_bloc.dart';

abstract class OrdersState {}

class OrdersInitial extends OrdersState {}
class AddingSiteOrderState extends OrdersState {}
class CompletedAddingSiteOrderState extends OrdersState {}
class FailedSiteOrderState extends OrdersState {
  final String error;
  FailedSiteOrderState({required this.error});
}
class CompleteUpdatingOrderQuantityState extends OrdersState {}
class UpdatingOrderQuantityState extends OrdersState {}
class FailedUpdatingOrderQuantityState extends OrdersState {
  final String error;
  FailedUpdatingOrderQuantityState({required this.error});
}
class FailedDeletingOrderState extends OrdersState {
  final String error;
  FailedDeletingOrderState({required this.error});
}
class DeletingOrderState extends OrdersState {}
class CompleteDeletingOrderState extends OrdersState {}
class CompleteUpdatingSiteOrderState extends OrdersState {}
class UpdatingSiteOrderState extends OrdersState {}
class FailedUpdatingSiteOrderState extends OrdersState {
  final String error;
  FailedUpdatingSiteOrderState({required this.error});
}
class CompleteUpdatingQuantityState extends OrdersState {}
class UpdatingQuantityState extends OrdersState {}
class FailedUpdatingQuantityState extends OrdersState {
  final String error;
  FailedUpdatingQuantityState({required this.error});
}
class AddingSiteStockState extends OrdersState {}
class CompletedAddingSiteStockState extends OrdersState {}
class FailedSiteStockState extends OrdersState {
  final String error;
  FailedSiteStockState({required this.error});
}