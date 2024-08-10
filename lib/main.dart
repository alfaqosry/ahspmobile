import 'package:ahsp2/screens/bahan_upah_screen.dart';
import 'package:ahsp2/screens/home_screen.dart';
import 'package:ahsp2/screens/bahanupahscreencreate.dart';
import 'package:ahsp2/screens/login_screen.dart';
import 'package:ahsp2/services/auth.dart';
import 'package:ahsp2/services/tugas_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => Auth()),
        ChangeNotifierProvider(create: (context) => TugasProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

// final isLogin = false;
final GoRouter _router = GoRouter(routes: <RouteBase>[
  GoRoute(
    // redirect: (context, state) {
    //   if (isLogin) {
    //     return '/';
    //   } else {
    //     return '/login';
    //   }
    // },
    path: '/login',
    name: 'login',
    builder: (BuildContext context, GoRouterState state) {
      return const LoginScren();
    },
    // routes: <RouteBase>[
    //   GoRoute(
    //     path: 'details',
    //     builder: (BuildContext context, GoRouterState state) {
    //       return const DetailsScreen();
    //     },
    //   ),
    // ],
  ),
  GoRoute(
      path: '/',
      name: 'main_page',
      builder: (BuildContext context, GoRouterState state) {
        return const HomeScreen();
      },
      routes: [
        GoRoute(
            path: 'bahan_upah/:id',
            name: 'bahan_upah',
            builder: (context, state) {
              String id = state.pathParameters['id'] ?? "no data";
              return BahanUpahScreen(id: id);
            },
            routes: [
              GoRoute(
                path: 'bahan_upah/create/:idbahan/:bahan',
                name: 'bahan_upah.create',
                builder: (context, state) {
                  String idtugas = state.pathParameters['id'] ?? "no data";
                  String idbahan = state.pathParameters['idbahan'] ?? "no data";
                  String bahan = state.pathParameters['bahan'] ?? "no data";
                  return BahanUpahScreenCreate(
                    idbahan: int.parse(idbahan),
                    idtugas: int.parse(idtugas),
                    bahan: bahan,
                  );
                },
              )
            ])
      ]),
], initialLocation: '/login', debugLogDiagnostics: true);

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routeInformationParser: _router.routeInformationParser,
      routerDelegate: _router.routerDelegate,
      routeInformationProvider: _router.routeInformationProvider,
      debugShowCheckedModeBanner: false,
      title: 'AHSP ',
      // home: Container(
      //     color: Color.fromRGBO(246, 249, 255, 1), child: HomeScreen()),
    );
  }
}
