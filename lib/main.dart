import 'package:bot_toast/bot_toast.dart';
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
import 'package:supabase_flutter/supabase_flutter.dart';

import 'bloc/workinprogress/workinprogress_bloc.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize local notifications
  await LocalNotificationService().initialize();

  // Initialize Firebase
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print("Firebase initialized successfully");
  } catch (e) {
    print("Error initializing Firebase: $e");
  }

  // Initialize Supabase
  try {
    await Supabase.initialize(
      url: 'https://szryfaofmlgwwannagpl.supabase.co',
      anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InN6cnlmYW9mbWxnd3dhbm5hZ3BsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDU0ODEwMTQsImV4cCI6MjA2MTA1NzAxNH0.Mr2hzMjy0FRascaT7ZkQ-zXAvxn73wg4tJEpXK6YKg0', // Replace with your actual key
    );
    print("Supabase initialized successfully");
  } catch (e) {
    print("Error initializing Supabase: $e");
  }

  // Start the app
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
