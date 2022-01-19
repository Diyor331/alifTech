import 'package:aliftech_test/blocs/navbar/navbar_cubit.dart';
import 'package:aliftech_test/ui/screens/add_todo.dart';
import 'package:aliftech_test/ui/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'screens/screens.dart';

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<NavigationCubit>(
          create: (context) => NavigationCubit(),
        ),
      ],
      child: MaterialApp(
        title: 'Aliftech test',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            fontFamily: 'Montserrat',
            primarySwatch: Colors.blue,
            appBarTheme: AppBarTheme(
              backgroundColor: primaryColor,
            )),
        initialRoute: Splash.routeName,
        routes: {
          Splash.routeName: (context) => Splash(),
          Main.routeName: (context) => Main(),
        },
      ),
    );
  }
}
