import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:app_ekos/services/service_http_client.dart';
import 'package:app_ekos/data/repository/auth_repository.dart';
import 'package:app_ekos/data/repository/kosan_repository.dart';

import 'package:app_ekos/presentation/auth/bloc/login/login_bloc.dart';
import 'package:app_ekos/presentation/auth/bloc/register/register_bloc.dart';
import 'package:app_ekos/presentation/kosan/bloc/kosan_bloc.dart';

import 'package:app_ekos/presentation/auth/login_screen.dart';
import 'package:app_ekos/presentation/home_screen.dart';
import 'package:app_ekos/presentation/kosan/select_location_screen.dart';

void main() {
  // 🔁 Inisialisasi service client dan repository
  final serviceHttpClient = ServiceHttpClient();
  final authRepository = AuthRepository(serviceHttpClient);
  final kosanRepository = KosanRepository(serviceHttpClient);

  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepository>.value(value: authRepository),
        RepositoryProvider<KosanRepository>.value(value: kosanRepository),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<LoginBloc>(
            create: (context) =>
                LoginBloc(authRepository: context.read<AuthRepository>()),
          ),
          BlocProvider<RegisterBloc>(
            create: (context) =>
                RegisterBloc(authRepository: context.read<AuthRepository>()),
          ),
          BlocProvider<KosanBloc>(
            create: (context) =>
                KosanBloc(context.read<KosanRepository>()),
          ),
        ],
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'eKos - Aplikasi Pencari Kos',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple).copyWith(
          primary: Colors.deepPurple.shade700,
          secondary: Colors.amber.shade600,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/select-location': (context) => const SelectLocationScreen(),
      },
    );
  }
}