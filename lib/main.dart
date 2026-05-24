import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zyboexpensetracker/core/splashscreen/splash_screen.dart';
import 'package:zyboexpensetracker/features/auth/onboarding_active_screen/presentation/bloc/create_account_bloc.dart';
import 'package:zyboexpensetracker/features/auth/presentation/send_otpbloc/bloc/send_otp_bloc_bloc.dart';
import 'package:zyboexpensetracker/features/home/presentation/bloc/home_bloc.dart';
import 'package:zyboexpensetracker/features/home/presentation/screens/home_screen.dart';
import 'package:zyboexpensetracker/features/home/presentation/synctocloudbloc/bloc/syncto_cloud_bloc.dart';
import 'package:zyboexpensetracker/features/home/services/notification_service.dart';
import 'package:zyboexpensetracker/features/onboarding_screens/on_boarding_screenone.dart';
import 'package:zyboexpensetracker/core/dependency_injections/injection_container.dart'
    as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.init();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  await di.initDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SendOtpBlocBloc>(create: (_) => di.sl<SendOtpBlocBloc>()),
        BlocProvider<CreateAccountBloc>(
          create: (_) => di.sl<CreateAccountBloc>(),
        ),
        BlocProvider<HomeBloc>(create: (_) => di.sl<HomeBloc>()),

        BlocProvider<SynctoCloudBloc>(create: (_) => di.sl<SynctoCloudBloc>()),
      ],
      child: MaterialApp(
        title: 'Zybo Finance',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.dark,
          scaffoldBackgroundColor: const Color(0xFF0D0D0D),
          fontFamily: GoogleFonts.inter().fontFamily,
        ),
        home: SplashScreen(),
      ),
    );
  }
}
