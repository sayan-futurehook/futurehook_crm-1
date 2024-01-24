import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:futurehook_crm/feature/auth/presentation/bloc/auth_bloc.dart';

import 'core/route/go_router_provider.dart';
import 'core/sevice_locator.dart';

class FuturehookCRMApp extends StatelessWidget {
  const FuturehookCRMApp({super.key});

  @override
  Widget build(BuildContext context) {
    final route = getIt<GoRouterProvider>();
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getIt<AuthBloc>()..add(IsSighnedInAuthEvent()),
        ),
      ],
      child: MaterialApp.router(
        routerConfig: route.goRouter,
        title: 'Futurehook CRM',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
