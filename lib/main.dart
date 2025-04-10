import 'package:bot_toast/bot_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:construction/bloc/auth/auth_bloc.dart';
import 'package:construction/bloc/dropdown/dropdown_bloc.dart';
import 'package:construction/bloc/forgotpassword/forgot_password_bloc.dart';
import 'package:construction/bloc/hidepassword/hidepassword_cubit.dart';
import 'package:construction/bloc/orders/orders_bloc.dart';
import 'package:construction/bloc/pickimage/pickimage_bloc.dart';
import 'package:construction/bloc/pickworkimage/pickworkimage_bloc.dart';
import 'package:construction/bloc/progressbar/progressbar_cubit.dart';
import 'package:construction/bloc/sites/sites_bloc.dart';
import 'package:construction/bloc/stock/stocks_bloc.dart';
import 'package:construction/bloc/users/users_bloc.dart';
import 'package:construction/services/local_notifications.dart';
import 'package:construction/utils/app_colors.dart';

import 'package:construction/utils/router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/workinprogress/workinprogress_bloc.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalNotificationService().initialize();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    BuildMaster(
      router: AppRouter(),
    ),
  );
}


class BuildMaster extends StatelessWidget {
  final AppRouter router;
  const BuildMaster({super.key, required this.router});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<HidepasswordCubit>(
            create: (context) => HidepasswordCubit()),
        BlocProvider<AuthBloc>(create: (context) => AuthBloc()),
        BlocProvider<ForgotPasswordBloc>(
            create: (context) => ForgotPasswordBloc()),
        BlocProvider<ProgressbarCubit>(create: (context) => ProgressbarCubit()),
        BlocProvider<UsersBloc>(create: (context) => UsersBloc()),
        BlocProvider<OrdersBloc>(create: (context) => OrdersBloc()),
        BlocProvider<StocksBloc>(create: (context) => StocksBloc()),
        BlocProvider<WorkinprogressBloc>(
            create: (context) => WorkinprogressBloc()),
        BlocProvider<DropdownBloc>(
          create: (context) => DropdownBloc(),
        ),
        BlocProvider<SitesBloc>(create: (context) => SitesBloc()),
        BlocProvider<PickworkimageBloc>(
            create: (context) => PickworkimageBloc()),
        BlocProvider<PickimageBloc>(create: (context) => PickimageBloc()),
      ],
      child: MaterialApp(
        builder: BotToastInit(),
        theme: ThemeData(useMaterial3: true),
        navigatorObservers: [BotToastNavigatorObserver()],
        debugShowCheckedModeBanner: false,
        title: "Build Master",
        onGenerateRoute: router.onGenerateRoute,
      ),
    );
  }
}

Container customLoading(Size size) {
  return Container(
    height: size.width / 7 * 1.8,
    width: size.width / 7 * 1.8,
    alignment: Alignment.center,
    decoration: BoxDecoration(
      color: AppColors.customWhite,
      borderRadius: BorderRadius.circular(15),
    ),
    child: Center(
      child: CircularProgressIndicator(
        color: AppColors.blue,
        strokeWidth: 4.0,
      ),
    ),
  );
}
