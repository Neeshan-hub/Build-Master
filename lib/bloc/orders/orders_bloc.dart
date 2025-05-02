import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../data/models/order_model.dart';
import '../../data/models/stocks.dart';

part 'orders_event.dart';
part 'orders_state.dart';

class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  OrdersBloc() : super(OrdersInitial()) {
    on<AddingSiteOrderEvent>((event, emit) => emit(AddingSiteOrderState()));
    on<CompletedAddingSiteOrderEvent>(
            (event, emit) => emit(CompletedAddingSiteOrderState()));
    on<FailedSiteOrderEvent>(
            (event, emit) => emit(FailedSiteOrderState(error: event.error)));
    on<CompleteUpdatingOrderQuantityEvent>(
            (event, emit) => emit(CompleteUpdatingOrderQuantityState()));
    on<UpdatingOrderQuantityEvent>(
            (event, emit) => emit(UpdatingOrderQuantityState()));
    on<FailedUpdatingOrderQuantityEvent>(
            (event, emit) => emit(FailedUpdatingOrderQuantityState(error: event.error)));
    on<FailedDeletingOrderEvent>(
            (event, emit) => emit(FailedDeletingOrderState(error: event.error)));
    on<DeletingOrderEvent>((event, emit) => emit(DeletingOrderState()));
    on<CompleteDeletingOrderEvent>(
            (event, emit) => emit(CompleteDeletingOrderState()));
    on<CompleteUpdatingSiteOrderEvent>(
            (event, emit) => emit(CompleteUpdatingSiteOrderState()));
    on<UpdatingSiteOrderEvent>((event, emit) => emit(UpdatingSiteOrderState()));
    on<FailedUpdatingSiteOrderEvent>(
            (event, emit) => emit(FailedUpdatingSiteOrderState(error: event.error)));
    on<CompleteUpdatingQuantityEvent>(
            (event, emit) => emit(CompleteUpdatingQuantityState()));
    on<UpdatingQuantityEvent>((event, emit) => emit(UpdatingQuantityState()));
    on<FailedUpdatingQuantityEvent>(
            (event, emit) => emit(FailedUpdatingQuantityState(error: event.error)));
    on<AddingSiteStockEvent>((event, emit) => emit(AddingSiteStockState()));
    on<CompletedAddingSiteStockEvent>(
            (event, emit) => emit(CompletedAddingSiteStockState()));
    on<FailedSiteStockEvent>(
            (event, emit) => emit(FailedSiteStockState(error: event.error)));
  }

  Future<void> deleteStock(String itemname, String brandname, String suppliername, String sid) async {
    try {
      emit(AddingSiteStockState());
      CollectionReference sitestock = FirebaseFirestore.instance
          .collection("sites")
          .doc(sid)
          .collection("stocks");

      // Find stock item
      final existingStock = await sitestock
          .where("itemname", isEqualTo: itemname)
          .where("brandname", isEqualTo: brandname)
          .where("suppliername", isEqualTo: suppliername)
          .get();

      if (existingStock.docs.isNotEmpty) {
        // Delete stock item
        await existingStock.docs.first.reference.delete();
      }

      await FirebaseFirestore.instance.collection("sites").doc(sid).update({
        "lastActivity": FieldValue.serverTimestamp(),
      });

      emit(CompletedAddingSiteStockState());
    } on FirebaseException catch (e) {
      emit(FailedSiteStockState(error: e.message!));
    } catch (e) {
      emit(FailedSiteStockState(error: e.toString()));
    }
  }
  // Add an order to the orders collection
  Future<void> addOrder(OrderModel orderModel, String sid) async {
    try {
      emit(AddingSiteOrderState());
      CollectionReference siteOrder = FirebaseFirestore.instance
          .collection("sites")
          .doc(sid)
          .collection("orders");
      String oid = siteOrder.doc().id;
      await siteOrder.doc(oid).set({
        "sid": sid,
        "oid": oid,
        "itemname": orderModel.itemname,
        "brandname": orderModel.brandname,
        "suppliername": orderModel.suppliername,
        "unit": orderModel.unit,
        "quantity": orderModel.quantity,
        "status": "On The Way",
        "rate": orderModel.rate,
        "approvalStatus": orderModel.approvalStatus,
      });
      await FirebaseFirestore.instance.collection("sites").doc(sid).update({
        "lastActivity": FieldValue.serverTimestamp(),
      });
      emit(CompletedAddingSiteOrderState());
    } on FirebaseException catch (e) {
      emit(FailedSiteOrderState(error: e.message!));
    }
  }

  // Update order quantity
  Future<void> updateOrderQuantity(String sid, double quantity, String oid) async {
    try {
      emit(UpdatingOrderQuantityState());
      double qty = 0;
      QuerySnapshot orderdoc = await FirebaseFirestore.instance
          .collection("sites")
          .doc(sid)
          .collection("orders")
          .where("oid", isEqualTo: oid)
          .get();
      for (QueryDocumentSnapshot<Object?> element in orderdoc.docs) {
        qty = element['quantity'] - quantity;
      }
      if (qty.isNegative) {
        emit(FailedUpdatingOrderQuantityState(
            error: "Order used is greater than available quantity"));
      } else {
        DocumentReference orderdoc = FirebaseFirestore.instance
            .collection("sites")
            .doc(sid)
            .collection("orders")
            .doc(oid);
        await orderdoc.update({"quantity": qty});
        await FirebaseFirestore.instance.collection("sites").doc(sid).update({
          "lastActivity": FieldValue.serverTimestamp(),
        });
        emit(CompleteUpdatingOrderQuantityState());
      }
    } on FirebaseException catch (e) {
      emit(FailedUpdatingOrderQuantityState(error: e.message!));
    }
  }

  // Update approval status and add to stock if approved
  Future<void> updateApprovalStatus(String sid, String oid, String approvalStatus) async {
    try {
      emit(UpdatingSiteOrderState());
      await FirebaseFirestore.instance
          .collection('sites')
          .doc(sid)
          .collection('orders')
          .doc(oid)
          .update({'approvalStatus': approvalStatus});

      // Get order data
      final orderDoc = await FirebaseFirestore.instance
          .collection("sites")
          .doc(sid)
          .collection("orders")
          .doc(oid)
          .get();

      final orderData = orderDoc.data()!;

      if (approvalStatus == "Approved") {
        final stockModel = StockModel(
          itemname: orderData['itemname'],
          brandname: orderData['brandname'],
          suppliername: orderData['suppliername'],
          unit: orderData['unit'],
          quantity: orderData['quantity'].toDouble(),
          rate: orderData['rate'].toDouble(),
        );
        await addStock(stockModel, sid);
      } else if (approvalStatus == "Disapproved") {
        await deleteStock(
          orderData['itemname'],
          orderData['brandname'],
          orderData['suppliername'],
          sid,
        );
      }

      await FirebaseFirestore.instance.collection("sites").doc(sid).update({
        "lastActivity": FieldValue.serverTimestamp(),
      });

      emit(CompleteUpdatingSiteOrderState());
    } on FirebaseException catch (e) {
      emit(FailedUpdatingSiteOrderState(error: e.message!));
    } catch (e) {
      emit(FailedUpdatingSiteOrderState(error: e.toString()));
    }
  }
  // Add order quantity
  Future<void> addOrderQuantity(String sid, String oid, double quantity) async {
    try {
      emit(UpdatingQuantityState());
      double qty = 0;
      QuerySnapshot orderDocs = await FirebaseFirestore.instance
          .collection("sites")
          .doc(sid)
          .collection("orders")
          .where("oid", isEqualTo: oid)
          .get();
      for (QueryDocumentSnapshot<Object?> element in orderDocs.docs) {
        qty = element['quantity'] + quantity;
      }

      DocumentReference orderdoc = FirebaseFirestore.instance
          .collection("sites")
          .doc(sid)
          .collection("orders")
          .doc(oid);
      await orderdoc.update({"quantity": qty});
      await FirebaseFirestore.instance.collection("sites").doc(sid).update({
        "lastActivity": FieldValue.serverTimestamp(),
      });
      emit(CompleteUpdatingQuantityState());
    } on FirebaseException catch (e) {
      emit(FailedUpdatingQuantityState(error: e.message!));
    }
  }

  // Update site order
  Future<void> updateSiteOrder(
      String sid,
      String oid,
      String itemname,
      String suppliername,
      String itembrand,
      double quantity,
      String status,
      double rate,
      String approvalStatus,
      String unit) async {
    try {
      emit(UpdatingSiteOrderState());
      DocumentReference ordersDoc = FirebaseFirestore.instance
          .collection("sites")
          .doc(sid)
          .collection("orders")
          .doc(oid);
      await ordersDoc.update({
        "itemname": itemname,
        'approvalStatus': approvalStatus,
        "brandname": itembrand,
        "suppliername": suppliername,
        "quantity": quantity,
        "rate": rate,
        "unit": unit,
      });
      if (status.isNotEmpty) {
        await ordersDoc.update({"status": status});
      }

      await FirebaseFirestore.instance.collection("sites").doc(sid).update({
        "lastActivity": FieldValue.serverTimestamp(),
      });

      emit(CompleteUpdatingSiteOrderState());
    } on FirebaseException catch (e) {
      emit(FailedUpdatingSiteOrderState(error: e.message!));
    }
  }

  // Delete site order
  Future<void> deleteSiteOrder(String sid, String oid) async {
    try {
      emit(DeletingOrderState());
      DocumentReference orders = FirebaseFirestore.instance
          .collection("sites")
          .doc(sid)
          .collection("orders")
          .doc(oid);
      await orders.delete();
      emit(CompleteDeletingOrderState());
    } on FirebaseException catch (e) {
      emit(FailedDeletingOrderState(error: e.message!));
    }
  }

  // Add stock to the stocks collection
  Future<void> addStock(StockModel stockModel, String sid) async {
    try {
      emit(AddingSiteStockState());
      CollectionReference sitestock = FirebaseFirestore.instance
          .collection("sites")
          .doc(sid)
          .collection("stocks");

      // Check if stock already exists for this item
      final existingStock = await sitestock
          .where("itemname", isEqualTo: stockModel.itemname)
          .where("brandname", isEqualTo: stockModel.brandname)
          .where("suppliername", isEqualTo: stockModel.suppliername)
          .get();

      if (existingStock.docs.isNotEmpty) {
        // Update existing stock quantity
        final existingDoc = existingStock.docs.first;
        await existingDoc.reference.update({
          "quantity": existingDoc['quantity'] + stockModel.quantity,
          "lastUpdated": FieldValue.serverTimestamp(),
        });
      } else {
        // Add new stock
        String skid = sitestock.doc().id;
        await sitestock.doc(skid).set({
          "sid": sid,
          "skid": skid,
          "itemname": stockModel.itemname,
          "brandname": stockModel.brandname,
          "suppliername": stockModel.suppliername,
          "unit": stockModel.unit,
          "quantity": stockModel.quantity,
          "rate": stockModel.rate,
          "lastUpdated": FieldValue.serverTimestamp(),
        });
      }

      await FirebaseFirestore.instance.collection("sites").doc(sid).update({
        "lastActivity": FieldValue.serverTimestamp(),
      });

      emit(CompletedAddingSiteStockState());
    } on FirebaseException catch (e) {
      emit(FailedSiteStockState(error: e.message!));
    } catch (e) {
      emit(FailedSiteStockState(error: e.toString()));
    }
  }
}