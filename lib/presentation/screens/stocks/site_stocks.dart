import 'package:bot_toast/bot_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:construction/data/models/stocks.dart';
import 'package:construction/presentation/includes/appbar.dart';
import 'package:construction/presentation/includes/custom_box.dart';
import 'package:construction/presentation/screens/stocks/site_stock_search_bar.dart';
import 'package:construction/utils/app_colors.dart';
import 'package:construction/utils/routes.dart';

import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/fluent_mdl2.dart';
import 'package:iconify_flutter/icons/zondicons.dart';

import '../../../bloc/stock/stocks_bloc.dart';
import '../../../main.dart';
import '../../includes/custom_number_field.dart';
import '../../includes/custom_textfield.dart';

class SiteStocks extends StatefulWidget {
  const SiteStocks({super.key});

  @override
  State<SiteStocks> createState() => _SiteStocksState();
}

class _SiteStocksState extends State<SiteStocks> {
  final TextEditingController _itemname = TextEditingController();
  final TextEditingController _brandname = TextEditingController();
  final TextEditingController _suppliername = TextEditingController();
  final TextEditingController _quantity = TextEditingController();
  final TextEditingController _rate = TextEditingController();
  final TextEditingController _unit = TextEditingController();
  final TextEditingController _qty = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  FocusNode searchFocusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> data = [];
    final size = MediaQuery.of(context).size;
    final padding = MediaQuery.of(context).padding;

    final Map<String, dynamic> args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    showAddStockModal() {
      return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            content: Form(
                key: _formKey,
                child: SizedBox(
                  height: size.height / 90 * 54.334,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(
                          height: size.height / 90 * 1.338,
                        ),
                        Text(
                          "Add Stocks",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.blue),
                        ),
                        SizedBox(
                          height: size.height / 90 * 2.538,
                        ),
                        CustomTextField(
                          controller: _itemname,
                          hintText: "Item Name",
                          size: size.height / 90 * 5.44,
                          width: size.width,
                        ).customTextField(),
                        SizedBox(
                          height: size.height / 90 * 1.538,
                        ),
                        CustomTextField(
                          controller: _brandname,
                          hintText: "Brand Name",
                          size: size.height / 90 * 5.44,
                          width: size.width,
                        ).customTextField(),
                        SizedBox(
                          height: size.height / 90 * 1.538,
                        ),
                        CustomTextField(
                          controller: _suppliername,
                          hintText: "Supplier Name",
                          size: size.height / 90 * 5.44,
                          width: size.width,
                        ).customTextField(),
                        SizedBox(
                          height: size.height / 90 * 1.538,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Item Quantity",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(
                              width: size.width / 5.6,
                              child: CustomNumberField(
                                hintText: "Qty",
                                controller: _quantity,
                                color: AppColors.customWhite,
                                size: size.height / 90 * 5.44,
                              ).customNumberField(),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: size.height / 90 * 1.538,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Item rate",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(
                              width: size.width / 5.6,
                              child: CustomNumberField(
                                hintText: "Rate",
                                color: AppColors.customWhite,
                                controller: _rate,
                                size: size.height / 90 * 5.44,
                              ).customNumberField(),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: size.height / 90 * 2.334,
                        ),
                        CustomTextField(
                          controller: _unit,
                          hintText: "Unit",
                          size: size.height / 90 * 5.44,
                          width: size.width,
                        ).customTextField(),
                        SizedBox(
                          height: size.height / 90 * 1.838,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            TextButton(
                              style: ElevatedButton.styleFrom(
                                elevation: 0,

                                foregroundColor: AppColors.blue,
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text(
                                "Cancel",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            BlocConsumer<StocksBloc, StocksState>(
                              listener: (context, state) {
                                if (state is AddingSiteStockState) {
                                  BotToast.showCustomLoading(
                                    toastBuilder: (cancelFunc) {
                                      return customLoading(size);
                                    },
                                  );
                                }
                                if (state is CompletedAddingSiteStockState) {
                                  BotToast.closeAllLoading();
                                  BotToast.showText(
                                      text: "New Stock Added",
                                      contentColor: AppColors.green);
                                }
                                if (state is FailedSiteStockState) {
                                  BotToast.closeAllLoading();
                                  BotToast.showText(
                                    text: state.error!,
                                    contentColor: AppColors.red,
                                  );
                                }
                              },
                              builder: (context, state) {
                                return ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    elevation: 0,
                                    fixedSize: Size(size.width / 90 * 25.66,
                                        size.height / 90 * 3.86),
                                    backgroundColor: AppColors.yellow,
                                    foregroundColor: AppColors.blue,
                                  ),
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      StockModel stockModel = StockModel(
                                        itemname: _itemname.text.toLowerCase(),
                                        brandname: _brandname.text,
                                        suppliername: _suppliername.text,
                                        quantity: double.parse(_quantity.text),
                                        rate: double.parse(_rate.text),
                                        unit: _unit.text,
                                      );
                                      BlocProvider.of<StocksBloc>(context)
                                          .addStock(stockModel, args['sid']);
                                    }
                                  },
                                  child: const Text(
                                    "Save",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                )),
          );
        },
      );
    }

    showDeleteDialog(String skid, String sid) {
      return showDialog(
          context: context,
          builder: (context) {
            final size = MediaQuery.of(context).size;
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              content: SizedBox(
                width: size.width,
                height: size.height / 90 * 23,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    CircleAvatar(
                      radius: size.width / 9.2,
                      backgroundColor: AppColors.red,
                      child: Iconify(
                        Zondicons.trash,
                        size: size.height / 90 * 4.76,
                        color: AppColors.white,
                      ),
                    ),
                    const Text(
                      "Are you sure you want to Delete ?",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            fixedSize: const Size(103, 33),
                            backgroundColor: AppColors.white,
                            foregroundColor: AppColors.blue,
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text(
                            "Cancel",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        BlocConsumer<StocksBloc, StocksState>(
                          listener: (context, state) {
                            if (state is DeletingStockState) {
                              BotToast.showCustomLoading(
                                toastBuilder: (context) => customLoading(size),
                              );
                            }
                            if (state is CompleteDeletingStockState) {
                              BotToast.closeAllLoading();
                              Navigator.of(context).pop();
                              BotToast.showText(
                                text: "Stock Deleted",
                                contentColor: AppColors.green,
                              );
                            }
                            if (state is FailedDeletingStockState) {
                              BotToast.closeAllLoading();
                              Navigator.of(context).pop();
                              BotToast.showText(
                                text: state.error!,
                                contentColor: AppColors.red,
                              );
                            }
                          },
                          builder: (context, state) {
                            return ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                fixedSize: const Size(103, 33),
                                backgroundColor: AppColors.red,
                                foregroundColor: AppColors.white,
                              ),
                              onPressed: () {
                                BlocProvider.of<StocksBloc>(context)
                                    .deleteSiteStock(sid, skid);
                              },
                              child: const Text(
                                "Delete",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          });
    }

    showEditSiteModal({
      required String sid,
      required String skid,
      required String itemname,
      required String suppliername,
      required String itembrand,
      required double quantity,
      required String unit,
      required double rate,
    }) {
      return showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: SizedBox(
            width: size.width,
            height: size.height / 90 * 53.334,
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: size.height / 90 * 1.338,
                    ),
                    Text(
                      "Update Site Stocks Info",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.blue,
                      ),
                    ),
                    SizedBox(
                      height: size.height / 90 * 1.538,
                    ),
                    Container(
                      height: size.height / 90 * 5.44,
                      width: size.width,
                      decoration: BoxDecoration(
                        color: AppColors.customWhite,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextFormField(
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                        initialValue: itemname,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: padding.top * 0.4,
                          ),
                          hintText: "Item Name",
                          border: InputBorder.none,
                        ),
                        onChanged: (value) {
                          itemname = value;
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Cant Send Empty value";
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(
                      height: size.height / 90 * 1.538,
                    ),
                    Container(
                      height: size.height / 90 * 5.44,
                      width: size.width,
                      decoration: BoxDecoration(
                        color: AppColors.customWhite,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextFormField(
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                        initialValue: suppliername,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: padding.top * 0.4,
                          ),
                          hintText: "Supplier Name",
                          border: InputBorder.none,
                        ),
                        onChanged: (value) {
                          suppliername = value;
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Cant Send Empty value";
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(
                      height: size.height / 90 * 1.538,
                    ),
                    Container(
                      height: size.height / 90 * 5.44,
                      width: size.width,
                      decoration: BoxDecoration(
                        color: AppColors.customWhite,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextFormField(
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                        initialValue: itembrand,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: padding.top * 0.4,
                          ),
                          hintText: "Item Brand",
                          border: InputBorder.none,
                        ),
                        onChanged: (value) {
                          itembrand = value;
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Cant Send Empty value";
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(
                      height: size.height / 90 * 1.538,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Quantity",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Container(
                          height: size.height / 90 * 5.44,
                          width: size.width / 8 * 1.5,
                          decoration: BoxDecoration(
                            color: AppColors.customWhite,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: TextFormField(
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                            keyboardType: TextInputType.number,
                            initialValue: quantity.toString(),
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: padding.top * 0.4,
                              ),
                              hintText: "Quantity",
                              border: InputBorder.none,
                            ),
                            onChanged: (value) {
                              quantity = double.parse(value);
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Cant Send Empty value";
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: size.height / 90 * 1.538,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Rate (Rs.)",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Container(
                          height: size.height / 90 * 5.44,
                          width: size.width / 8 * 1.5,
                          decoration: BoxDecoration(
                            color: AppColors.customWhite,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: TextFormField(
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                            keyboardType: TextInputType.number,
                            initialValue: rate.toString(),
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: padding.top * 0.4,
                              ),
                              hintText: "Rate",
                              border: InputBorder.none,
                            ),
                            onChanged: (value) {
                              rate = double.parse(value);
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Cant Send Empty value";
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: size.height / 90 * 2.538,
                    ),
                    Container(
                      height: size.height / 90 * 5.44,
                      width: size.width,
                      decoration: BoxDecoration(
                        color: AppColors.customWhite,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextFormField(
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                        initialValue: unit,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: padding.top * 0.4,
                          ),
                          hintText: "Unit",
                          border: InputBorder.none,
                        ),
                        onChanged: (value) {
                          unit = value;
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Cant Send Empty value";
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(
                      height: size.height / 90 * 1.538,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            fixedSize: const Size(103, 33),
                            backgroundColor: AppColors.white,
                            foregroundColor: AppColors.blue,
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text(
                            "Cancel",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        BlocConsumer<StocksBloc, StocksState>(
                          listener: (context, state) {
                            if (state is UpdatingSiteStockState) {
                              BotToast.showCustomLoading(
                                toastBuilder: (context) => customLoading(size),
                              );
                            }
                            if (state is CompleteUpdatingSiteStockState) {
                              BotToast.closeAllLoading();
                              Navigator.of(context).pop();
                              BotToast.showText(
                                text: "Stock Information Updated",
                                contentColor: AppColors.green,
                              );
                            }
                            if (state is FailedUpdatingSiteStockState) {
                              BotToast.closeAllLoading();
                              Navigator.of(context).pop();
                              BotToast.showText(
                                text: state.error!,
                                contentColor: AppColors.red,
                              );
                            }
                          },
                          builder: (context, state) {
                            return ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                fixedSize: const Size(103, 33),
                                backgroundColor: AppColors.yellow,
                                foregroundColor: AppColors.blue,
                              ),
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  BlocProvider.of<StocksBloc>(context)
                                      .updateSiteStock(
                                    sid,
                                    skid,
                                    itemname,
                                    suppliername,
                                    itembrand,
                                    quantity,
                                    rate,
                                    unit,
                                  );
                                }
                              },
                              child: const Text(
                                "Update",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }

    showAddQuantityModal(String skid, String sid) {
      return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: SizedBox(
              height: size.height / 90 * 16.3,
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Add Stock Quantity",
                      style: TextStyle(
                          color: AppColors.blue,
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
                    Container(
                      height: size.height / 90 * 5.44,
                      width: size.width,
                      decoration: BoxDecoration(
                        color: AppColors.customWhite,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextFormField(
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                        keyboardType: TextInputType.number,
                        controller: _qty,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: padding.top * 0.4,
                          ),
                          hintText: "Quantity",
                          border: InputBorder.none,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Cant Send Empty value";
                          }
                          return null;
                        },
                      ),
                    ),
                    BlocConsumer<StocksBloc, StocksState>(
                      listener: (context, state) {
                        if (state is UpdatingQuantityState) {
                          BotToast.showCustomLoading(
                            toastBuilder: (cancelFunc) {
                              return customLoading(size);
                            },
                          );
                        }
                        if (state is CompleteUpdatingQuantityState) {
                          BotToast.closeAllLoading();
                          Navigator.of(context).pop();
                          BotToast.showText(
                            text: "Progress Updated",
                            contentColor: AppColors.green,
                          );
                        }
                        if (state is FailedUpdatingQuantityState) {
                          BotToast.closeAllLoading();
                          Navigator.of(context).pop();
                          BotToast.showText(
                            text: state.error!,
                            contentColor: AppColors.red,
                          );
                        }
                      },
                      builder: (context, state) {
                        return ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            fixedSize: Size(
                              size.width / 6,
                              size.height / 90 * 3.4,
                            ),
                            foregroundColor: AppColors.blue,
                            backgroundColor: AppColors.yellow,
                          ),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              BlocProvider.of<StocksBloc>(context)
                                  .addStockQuantity(
                                      sid, skid, double.parse(_qty.text));
                            }
                          },
                          child: const Iconify(FluentMdl2.forward),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    }

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: PreferredSize(
        preferredSize: Size(size.width, size.height / 90 * 8.5),
        child: CustomAppbar(
          bgcolor: AppColors.white,
          title: args['sitename'],
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new,
              size: size.height / 90 * 2.3,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          action: [
            IconButton(
              onPressed: () {
                showAddStockModal();
              },
              icon: CircleAvatar(
                backgroundColor: AppColors.yellow,
                radius: size.width / 12.4,
                child: Icon(
                  Icons.add,
                  color: AppColors.blue,
                ),
              ),
            ),
          ],
        ).customAppBar(),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection("sites")
            .doc(args['sid'])
            .collection("stocks")
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return snapshot.data!.docs.isEmpty
                ? const Center(
                    child: Text("No Stocks at the Moment"),
                  )
                : SingleChildScrollView(
                    physics: const NeverScrollableScrollPhysics(),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () => searchFocusNode
                                  .unfocus(), // Close search bar when tapping outside
                              child: CustomBox(
                                height: size.height / 90 * 6,
                                width: size.width / 8 * 5.8,
                                radius: 16,
                                blurRadius: 4.0,
                                shadowColor: AppColors.customWhite,
                                color: AppColors.white,
                                horizontalMargin: padding.top * 0.4,
                                verticalMargin: padding.top * 0.2,
                                child:// In the build method of _SiteStocksState, update the StockSearchBar widget:
                                StockSearchBar(
                                  siteId: args['sid'],
                                  focusNode: searchFocusNode,
                                  onStockSelected: showEditSiteModal, // Pass the edit dialog function as callback
                                ),
                              ).customBox(),
                            ),
                            IconButton(
                              onPressed: () {
                                data.clear();
                                if (snapshot.data!.docs.isNotEmpty) {
                                  for (int i = 0;
                                      i < snapshot.data!.docs.length;
                                      i++) {
                                    double amount = snapshot.data!.docs[i]
                                            ['quantity'] *
                                        snapshot.data!.docs[i]['rate'];
                                    data.add({
                                      'sn': "${i + 1}",
                                      "sitename": args['sitename'],
                                      "itemname": snapshot.data!.docs[i]
                                          ['itemname'],
                                      "brandname": snapshot.data!.docs[i]
                                          ['brandname'],
                                      "suppliername": snapshot.data!.docs[i]
                                          ['suppliername'],
                                      "unit": snapshot.data!.docs[i]['unit'],
                                      "quantity": snapshot.data!.docs[i]
                                          ['quantity'],
                                      "rate": snapshot.data!.docs[i]['rate'],
                                      "amount": amount,
                                    });
                                  }
                                }
                                double total = 0;
                                for (int i = 0; i < data.length; i++) {
                                  total += data[i]['amount'];
                                }

                                if (data.isEmpty) {
                                  BotToast.showText(
                                      text: "No Orders at the moment",
                                      contentColor: AppColors.red);
                                } else {
                                  Navigator.of(context).pushNamed(
                                    stockSignaturePadPage,
                                    arguments: {
                                      "count": 8,
                                      "data": data,
                                      "total": total,
                                      "name":
                                          "Order Invoice ${data[0]['sitename']}"
                                    },
                                  );
                                }
                              },
                              icon: CircleAvatar(
                                backgroundColor: AppColors.yellow,
                                radius: size.width / 21,
                                child: Icon(
                                  Icons.picture_as_pdf,
                                  color: AppColors.blue,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: size.height / 90 * 68,
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              return CustomBox(
                                height: size.height / 90 * 12,
                                width: size.width,
                                radius: 15,
                                blurRadius: 4.0,
                                shadowColor: AppColors.customWhite,
                                color: AppColors.white,
                                horizontalMargin: padding.top * 0.4,
                                verticalMargin: padding.top * 0.2,
                                child: InkWell(
                                  onTap: () {
                                    showAddQuantityModal(
                                      snapshot.data!.docs[index]['skid'],
                                      snapshot.data!.docs[index]['sid'],
                                    );
                                  },
                                  child: Stack(
                                    children: [
                                      Container(
                                        height: size.height,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: padding.top * 0.4),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            SizedBox(
                                              height: size.height / 90 * 0.3,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  snapshot.data!.docs[index]
                                                      ['itemname'],
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    color: AppColors.grey,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                SizedBox(
                                                  width: size.width / 7 * 2.6,
                                                  child: Text(
                                                    snapshot.data!.docs[index]
                                                        ['brandname'],
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                                const Spacer(),
                                                CustomBox(
                                                  height:
                                                      size.height / 90 * 2.44,
                                                  width: size.width / 3.16,
                                                  radius: 15,
                                                  blurRadius: 4.0,
                                                  shadowColor:
                                                      AppColors.customWhite,
                                                  color: snapshot.data!
                                                                  .docs[index]
                                                              ['quantity'] ==
                                                          0
                                                      ? AppColors.red
                                                      : snapshot.data!.docs[
                                                                      index][
                                                                  'quantity'] >=
                                                              10
                                                          ? AppColors.green
                                                          : Colors
                                                              .deepOrangeAccent,
                                                  horizontalMargin: 0,
                                                  verticalMargin: 0,
                                                  child: Center(
                                                    child: Text(
                                                      snapshot.data!.docs[index]
                                                                  [
                                                                  'quantity'] ==
                                                              0
                                                          ? "Out of Stock"
                                                          : snapshot.data!.docs[
                                                                          index]
                                                                      [
                                                                      'quantity'] >=
                                                                  10
                                                              ? "In Stock"
                                                              : "Low Stock",
                                                      style: TextStyle(
                                                          color:
                                                              AppColors.white),
                                                    ),
                                                  ),
                                                ).customBox(),
                                                const Spacer(),
                                                const Spacer(),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                SizedBox(
                                                  width: size.width / 7 * 2.2,
                                                  child: const Text(
                                                    "Quantities : ",
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                                const Spacer(),
                                                SizedBox(
                                                  width: size.width / 6 * 1.8,
                                                  child: Text(
                                                    "${snapshot.data!.docs[index]['quantity']} ${snapshot.data!.docs[index]['unit']}",
                                                    style: const TextStyle(
                                                      overflow:
                                                          TextOverflow.clip,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                                const Spacer(),
                                              ],
                                            ),
                                            SizedBox(
                                              height: size.height / 90 * 0.1,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Align(
                                            alignment: Alignment.centerRight,
                                            child: IconButton(
                                              onPressed: () {
                                                showDeleteDialog(
                                                  snapshot.data!.docs[index]
                                                      ['skid'],
                                                  snapshot.data!.docs[index]
                                                      ['sid'],
                                                );
                                              },
                                              icon: Iconify(
                                                Zondicons.trash,
                                                color: AppColors.red,
                                                size: size.height / 90 * 2.3,
                                              ),
                                            ),
                                          ),
                                          Align(
                                            alignment: Alignment.centerRight,
                                            child: IconButton(
                                              onPressed: () {
                                                showEditSiteModal(
                                                  sid: snapshot
                                                      .data!.docs[index]['sid'],
                                                  skid: snapshot.data!
                                                      .docs[index]['skid'],
                                                  itemname: snapshot.data!
                                                      .docs[index]['itemname'],
                                                  suppliername:
                                                      snapshot.data!.docs[index]
                                                          ['suppliername'],
                                                  itembrand: snapshot.data!
                                                      .docs[index]['brandname'],
                                                  quantity: snapshot.data!
                                                      .docs[index]['quantity'],
                                                  unit: snapshot.data!
                                                      .docs[index]['unit'],
                                                  rate: snapshot.data!
                                                      .docs[index]['rate'],
                                                );
                                              },
                                              icon: Iconify(
                                                FluentMdl2.edit,
                                                color: AppColors.grey,
                                                size: size.height / 90 * 2.3,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ).customBox();
                            },
                          ),
                        ),
                      ],
                    ),
                  );
          } else {
            return Center(
              child: Builder(
                builder: (context) => customLoading(size),
              ),
            );
          }
        },
      ),
    );
  }
}
