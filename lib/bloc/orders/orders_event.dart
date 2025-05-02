part of 'orders_bloc.dart';

abstract class OrdersEvent {}

class AddingSiteOrderEvent extends OrdersEvent {}
class CompletedAddingSiteOrderEvent extends OrdersEvent {}
class FailedSiteOrderEvent extends OrdersEvent {
  final String error;
  FailedSiteOrderEvent({required this.error});
}
class CompleteUpdatingOrderQuantityEvent extends OrdersEvent {}
class UpdatingOrderQuantityEvent extends OrdersEvent {}
class FailedUpdatingOrderQuantityEvent extends OrdersEvent {
  final String error;
  FailedUpdatingOrderQuantityEvent({required this.error});
}
class FailedDeletingOrderEvent extends OrdersEvent {
  final String error;
  FailedDeletingOrderEvent({required this.error});
}
class DeletingOrderEvent extends OrdersEvent {}
class CompleteDeletingOrderEvent extends OrdersEvent {}
class CompleteUpdatingSiteOrderEvent extends OrdersEvent {}
class UpdatingSiteOrderEvent extends OrdersEvent {}
class FailedUpdatingSiteOrderEvent extends OrdersEvent {
  final String error;
  FailedUpdatingSiteOrderEvent({required this.error});
}
class CompleteUpdatingQuantityEvent extends OrdersEvent {}
class UpdatingQuantityEvent extends OrdersEvent {}
class FailedUpdatingQuantityEvent extends OrdersEvent {
  final String error;
  FailedUpdatingQuantityEvent({required this.error});
}
class AddingSiteStockEvent extends OrdersEvent {}
class CompletedAddingSiteStockEvent extends OrdersEvent {}
class FailedSiteStockEvent extends OrdersEvent {
  final String error;
  FailedSiteStockEvent({required this.error});
}