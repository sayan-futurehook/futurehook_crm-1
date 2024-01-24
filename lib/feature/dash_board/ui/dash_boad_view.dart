import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../auth/presentation/bloc/auth_bloc.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('HomeScreen'),
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (state is SuccessAuthState) ...[
                Text(state.user.id),
                Text(state.user.name ?? ''),
                Text(state.user.email ?? ''),
              ],
              FilledButton(
                onPressed: () {
                  context.read<AuthBloc>().add(SignOutEvent());
                },
                child: const Text('SignOut'),
              ),
            ],
          ),
        );
      },
    );
  }
}
