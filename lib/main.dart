import 'package:flutter/material.dart';
import 'package:Qtz/screens/splash_screen.dart';
import 'package:Qtz/screens/home_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:Qtz/constant.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Qtz/bloc/qtz/qtz_bloc.dart';
import 'package:Qtz/provider/api_provider.dart';
import 'package:flutter/services.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitDown,DeviceOrientation.portraitUp]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context)  => QtzBloc(),
      child: MaterialApp(
        title: 'Qtz',
        theme: ThemeData(
          textTheme: GoogleFonts.rubikTextTheme(
              Theme.of(context).textTheme.apply(bodyColor: Colors.white)),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: SplashPage(),
      ),
    );
  }
}
