import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:futurehook_crm/core/route/route_name.dart';
import 'package:futurehook_crm/feature/auth/presentation/bloc/auth_bloc.dart';
import 'package:futurehook_crm/feature/dash_board/ui/dash_boad_view.dart';
import 'package:go_router/go_router.dart';

import '../../feature/auth/presentation/ui/auth_view.dart';

class GoRouterProvider {
  GoRouterProvider();

  GoRouter get goRouter => GoRouter(
        debugLogDiagnostics: true,
        initialLocation: RoutePath.home.path,
        routes: [
          GoRoute(
              path: RoutePath.home.path,
              name: RoutePath.home.name,
              builder: (BuildContext context, GoRouterState state) =>
                  const DashboardView()),
          GoRoute(
            path: RoutePath.login.path,
            name: RoutePath.login.name,
            builder: (BuildContext context, GoRouterState state) =>
                const AuthenticationView(),
          ),
        ],
        redirect: (context, state) {
          String route = '/login';
          if (context.watch<AuthBloc>().state is SuccessAuthState) {
            route = '/';
          }
          return route;
        },
      );
}
