import 'package:bot_toast/bot_toast.dart';
import 'package:carousel_indicator/carousel_indicator.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:construction/presentation/includes/appbar.dart';
import 'package:construction/services/local_notifications.dart';
import 'package:construction/utils/app_colors.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/fluent_mdl2.dart';
import 'package:iconify_flutter/icons/zondicons.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../bloc/dropdown/dropdown_bloc.dart';
import '../../../bloc/sites/sites_bloc.dart';
import '../../../main.dart';
import '../../../utils/routes.dart';
import '../../../utils/validator.dart';
import '../../includes/custom_box.dart';

class SiteDescription extends StatefulWidget {
  const SiteDescription({super.key});

  @override
  State<SiteDescription> createState() => _SiteDescriptionState();
}

class _SiteDescriptionState extends State<SiteDescription> {
  final _formKey = GlobalKey<FormState>();
  String dropdownvalue = "";
  String sid = "";
  String sitename = "";
  String sitelocation = "";
  String clientname = "";
  String phone = "";
  String about = "";

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final padding = MediaQuery.of(context).padding;
    int dotposition = 0;
    CarouselSliderController carouselController = CarouselSliderController();

    final Map<String, dynamic> args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    showEditSiteModal({
      required String sid,
      required String sitename,
      required String sitelocation,
      required String clientname,
      required String phone,
      required String about,
    }) {
      return showDialog(
        context: context,
        builder: (context) => BlocListener<DropdownBloc, DropdownState>(
          listener: (context, state) {
            if (state is DropdownUserSelectState) {
              dropdownvalue = state.value!;
            }
          },
          child: AlertDialog(
            content: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("users")
                    .where("role", isEqualTo: "Supervisor")
                    .get()
                    .asStream(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return SizedBox(
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
                                "Update Site Info",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.blue),
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
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                  initialValue: sitename,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: padding.top * 0.4,
                                    ),
                                    hintText: "Site Name",
                                    border: InputBorder.none,
                                  ),
                                  onChanged: (value) {
                                    sitename = value;
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
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                  initialValue: sitelocation,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: padding.top * 0.4,
                                    ),
                                    hintText: "Site Location",
                                    border: InputBorder.none,
                                  ),
                                  onChanged: (value) {
                                    sitelocation = value;
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
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                  initialValue: clientname,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: padding.top * 0.4,
                                    ),
                                    hintText: "Client Name",
                                    border: InputBorder.none,
                                  ),
                                  onChanged: (value) {
                                    clientname = value;
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
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                  initialValue: phone,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: padding.top * 0.4,
                                    ),
                                    hintText: "Phone",
                                    border: InputBorder.none,
                                  ),
                                  onChanged: (value) {
                                    phone = value;
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
                                  initialValue: about,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: padding.top * 0.4,
                                    ),
                                    hintText: "About Site",
                                    border: InputBorder.none,
                                  ),
                                  onChanged: (value) {
                                    about = value;
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
                                decoration: BoxDecoration(
                                  color: AppColors.customWhite,
                                ),
                                child: DropdownButtonFormField2(
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                  ),
                                  validator: (value) =>
                                      Validator.getBlankFieldValidator(
                                          value.toString(),
                                          "Supervisor for site"),
                                  isExpanded: true,
                                  hint: const Text("Assign a Supervisior"),
                                  items: snapshot.data!.docs
                                      .map<DropdownMenuItem>((supervisor) {
                                    return DropdownMenuItem(
                                      value: "${supervisor['fullname']}",
                                      child: Text(
                                        "${supervisor['fullname']}",
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (newValue) {
                                    BlocProvider.of<DropdownBloc>(context)
                                        .onUserSelectDropdown(
                                            newValue.toString());
                                  },
                                ),
                              ),
                              SizedBox(
                                height: size.height / 90 * 1.538,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
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
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  BlocConsumer<SitesBloc, SitesState>(
                                    listener: (context, state) {
                                      if (state is UpdatingSiteState) {
                                        BotToast.showCustomLoading(
                                          toastBuilder: (context) =>
                                              customLoading(size),
                                        );
                                      }
                                      if (state is CompleteUpdatingSiteState) {
                                        BotToast.closeAllLoading();
                                        Navigator.of(context).pop();
                                        BotToast.showText(
                                          text: "Site Information Updated",
                                          contentColor: AppColors.green,
                                        );
                                      }
                                      if (state is FailedUpdatingSiteState) {
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
                                          BlocProvider.of<SitesBloc>(context)
                                              .updateSiteInfo(
                                            sid: sid,
                                            sitename: sitename,
                                            sitelocation: sitelocation,
                                            clientname: clientname,
                                            phone: phone,
                                            sitedesc: about,
                                            supervisor: dropdownvalue,
                                          );
                                        },
                                        child: const Text(
                                          "Update",
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black,
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
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator.adaptive(),
                    );
                  }
                }),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: PreferredSize(
        preferredSize: Size(size.width, size.height / 90 * 8.5),
        child: CustomAppbar(
          title: args['sitename'],
          action: [
            args['role'] == "Admin"
                ? IconButton(
                    onPressed: () {
                      showEditSiteModal(
                        sid: sid,
                        sitename: sitename,
                        sitelocation: sitelocation,
                        clientname: clientname,
                        phone: phone,
                        about: about,
                      );
                    },
                    icon: CircleAvatar(
                      backgroundColor: AppColors.yellow,
                      radius: size.width / 12.4,
                      child: Iconify(
                        FluentMdl2.edit,
                        color: AppColors.blue,
                        size: size.height / 90 * 2.3,
                      ),
                    ),
                  )
                : Container(),
          ],
          bgcolor: AppColors.white,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new,
              size: size.height / 90 * 2.3,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ).customAppBar(),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection("sites")
            .doc(args['sid'])
            .collection("siteimages")
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: padding.top * 0.8),
                    child: snapshot.data!.docs.isEmpty
                        ? Container()
                        : CarouselSlider.builder(
                            carouselController: carouselController,
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index, _) {
                              return snapshot.data!.docs[index]['image'] == null
                                  ? Container()
                                  : PageView(
                                      onPageChanged: (value) {
                                        setState(() {
                                          dotposition = value;
                                        });
                                      },
                                      children: [
                                        Container(
                                          margin: EdgeInsets.symmetric(
                                              horizontal: padding.top * 0.2,
                                              vertical: padding.top * 0.2),
                                          decoration: BoxDecoration(
                                            color: AppColors.blue,
                                            image: DecorationImage(
                                              image: NetworkImage(snapshot
                                                  .data!.docs[index]['image']),
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                            },
                            options: CarouselOptions(
                              viewportFraction: 1.0,
                              height: size.height / 90 * 15.5,
                            ),
                          ),
                  ),
                  SizedBox(
                    height: size.height / 90 * 1.3,
                  ),
                  snapshot.data!.docs.isEmpty
                      ? Container()
                      : Align(
                          alignment: Alignment.center,
                          child: CarouselIndicator(
                            count: snapshot.data!.docs.length,
                            activeColor: AppColors.yellow,
                            color: AppColors.blue,
                            index: dotposition,
                          ),
                        ),
                  StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                    stream: FirebaseFirestore.instance
                        .collection("sites")
                        .doc(args['sid'])
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        sid = snapshot.data!['sid'];
                        sitename = snapshot.data!['sitename'];
                        sitelocation = snapshot.data!['sitelocation'];
                        clientname = snapshot.data!['clientname'];
                        phone = snapshot.data!['phone'];
                        about = snapshot.data!['sitedesc'];
                        return Container(
                          height: MediaQuery.of(context).size.height,
                          padding: EdgeInsets.symmetric(
                              horizontal: padding.top * 0.8),
                          child: ListView(
                            shrinkWrap: true,
                            children: [
                              SizedBox(
                                height: size.height / 90 * 1.2,
                              ),
                              Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "${snapshot.data!['sitename']}",
                                  style: TextStyle(
                                    color: AppColors.blue,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: size.height / 90 * 1.0,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: size.width / 2 * 1.4,
                                    child: Text(
                                      "${snapshot.data!['sitelocation']}",
                                      overflow: TextOverflow.clip,
                                      style: TextStyle(
                                        color: AppColors.grey,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  Icon(
                                    Icons.location_pin,
                                    size: size.height / 90 * 2.66,
                                    color: AppColors.grey,
                                  )
                                ],
                              ),
                              SizedBox(
                                height: size.height / 90 * 0.5,
                              ),
                              Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "${snapshot.data!['clientname']}",
                                  style: TextStyle(
                                    color: AppColors.grey,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: size.height / 90 * 0.5,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "+977${snapshot.data!['phone']}",
                                    style: TextStyle(
                                      color: AppColors.grey,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () async {
                                      final Uri launchUri = Uri(
                                        scheme: 'tel',
                                        path: args[
                                            'phone'], // Make sure args['phone'] contains the phone number
                                      );
                                      if (await canLaunchUrl(launchUri)) {
                                        await launchUrl(launchUri);
                                      } else {
                                        throw 'Could not launch $launchUri';
                                      }
                                    },
                                    child: Icon(
                                      Icons.phone,
                                      size: size.height / 90 * 2.66,
                                      color: AppColors.grey,
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: size.height / 90 * 1.5,
                              ),
                              Text(
                                "About ${snapshot.data!['sitename']}",
                                style: TextStyle(
                                  color: AppColors.blue,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18,
                                ),
                              ),
                              SizedBox(
                                height: size.height / 90 * 0.5,
                              ),
                              SizedBox(
                                height: size.height / 90 * 6.5,
                                child: Text(
                                  maxLines: 20,
                                  softWrap: true,
                                  overflow: TextOverflow.ellipsis,
                                  textWidthBasis: TextWidthBasis.parent,
                                  "${snapshot.data!['sitedesc']}",
                                  style: TextStyle(
                                    color: AppColors.grey,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: size.height / 90 * 2.8,
                              ),
                              SizedBox(
                                height: size.height / 90 * 24.5,
                                child: GridView(
                                  physics: const NeverScrollableScrollPhysics(),
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    mainAxisSpacing: padding.top * 0.4,
                                    crossAxisSpacing: padding.top * 0.4,
                                    childAspectRatio: 7 / 4,
                                  ),
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        Navigator.of(context)
                                            .pushNamed(siteStocks, arguments: {
                                          "sid": args['sid'],
                                          "sitename": args['sitename'],
                                          "sitedesc": args['sitedesc'],
                                          "sitelocation": args['sitelocation'],
                                          "clientname": args['clientname'],
                                          "phone": args['phone'],
                                          "supervisor": args['role']
                                        });
                                      },
                                      child: CustomBox(
                                        height: size.height / 90 * 6,
                                        width: size.width / 9 * 1.3,
                                        blurRadius: 4,
                                        radius: 15,
                                        shadowColor: AppColors.customWhite,
                                        color: AppColors.white,
                                        horizontalMargin: 0,
                                        verticalMargin: 0,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Iconify(
                                              FluentMdl2.storage_acount,
                                              size: size.height / 90 * 4.2,
                                              color: AppColors.red,
                                            ),
                                            Text(
                                              "Manage Stocks",
                                              style: TextStyle(
                                                color: AppColors.red,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ).customBox(),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        LocalNotificationService()
                                            .showNotification(
                                                id: 1,
                                                title: "Test Notification",
                                                body: "Mind Your  business");
                                      },
                                      child: CustomBox(
                                        height: size.height / 90 * 5,
                                        width: size.width / 8 * 1.3,
                                        blurRadius: 4,
                                        radius: 15,
                                        shadowColor: AppColors.customWhite,
                                        color: AppColors.white,
                                        horizontalMargin: 0,
                                        verticalMargin: 0,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Iconify(
                                              Zondicons.currency_dollar,
                                              size: size.height / 90 * 4.2,
                                              color: AppColors.green,
                                            ),
                                            Text(
                                              "Estimation",
                                              style: TextStyle(
                                                color: AppColors.green,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ).customBox(),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        print(args['role']);
                                        Navigator.of(context).pushNamed(
                                            workinprogress,
                                            arguments: {
                                              "sid": args['sid'],
                                              "sitename": args['sitename'],
                                              "role": args['role']
                                            });
                                      },
                                      child: CustomBox(
                                        height: size.height / 90 * 5,
                                        width: size.width / 8 * 1.3,
                                        blurRadius: 4,
                                        radius: 15,
                                        shadowColor: AppColors.customWhite,
                                        color: AppColors.white,
                                        horizontalMargin: 0,
                                        verticalMargin: 0,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Iconify(
                                              Zondicons.inbox_check,
                                              color: AppColors.blue,
                                              size: size.height / 90 * 4.2,
                                            ),
                                            Text(
                                              "Work in Progress",
                                              style: TextStyle(
                                                color: AppColors.blue,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ).customBox(),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        Navigator.of(context).pushNamed(
                                          orders,
                                          arguments: {
                                            "sid": args['sid'],
                                            "sitename": args['sitename'],
                                            "role": args['role']
                                          },
                                        );
                                      },
                                      child: CustomBox(
                                        height: size.height / 90 * 5,
                                        width: size.width / 8 * 1.3,
                                        blurRadius: 4,
                                        radius: 15,
                                        shadowColor: AppColors.customWhite,
                                        color: AppColors.white,
                                        horizontalMargin: 0,
                                        verticalMargin: 0,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Iconify(
                                              FluentMdl2.reservation_orders,
                                              color: AppColors.blue,
                                              size: size.height / 90 * 4.2,
                                            ),
                                            Text(
                                              "Manage Orders",
                                              style: TextStyle(
                                                color: AppColors.blue,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ).customBox(),
                                    ),
                                  ],
                                ),
                              ),
                              buildImageList(snapshot),
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

  Widget buildImageList(AsyncSnapshot snapshot) {
    final imageUrls = snapshot.data!['imageUrls'] as List?;

    if (imageUrls == null || imageUrls.isEmpty) {
      return const SizedBox.shrink();
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 1, // Square images
      ),
      itemCount: imageUrls.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (context) => Dialog(
                backgroundColor: Colors.transparent,
                child: Stack(
                  children: [
                    Center(
                      child: Image.network(
                        imageUrls[index],
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.error, size: 50),
                      ),
                    ),
                    Positioned(
                      top: 10,
                      right: 10,
                      child: IconButton(
                        icon: const Icon(Icons.close,
                            color: Colors.white, size: 30),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.network(
              imageUrls[index],
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.error),
            ),
          ),
        );
      },
    );
  }
}
