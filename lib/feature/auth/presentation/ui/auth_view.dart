import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:futurehook_crm/config/zoho_url_config.dart';
import 'package:futurehook_crm/core/components/animation/models/loading_animation_view.dart';
import 'package:futurehook_crm/feature/auth/presentation/bloc/auth_bloc.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AuthenticationView extends StatefulWidget {
  const AuthenticationView({super.key});

  @override
  State<AuthenticationView> createState() => _AuthenticationViewState();
}

class _AuthenticationViewState extends State<AuthenticationView> {
  late final WebViewController controller;

  @override
  void initState() {
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {},
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            log(request.url);
            final uri = Uri.parse(request.url);
            if (uri.origin == ZohoUrlConfig.redirectUrl) {
              if (uri.queryParameters['code'] != null) {
                context
                    .read<AuthBloc>()
                    .add(SignInWithZohoAuthEvent(uri.queryParameters['code']!));
              }
              if (uri.queryParameters['error'] case String errorMsg) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(errorMsg.replaceAll('_', ' ')),
                  ),
                );
              }
            }
            if (request.url
                .startsWith('${ZohoUrlConfig.accountsZohoUrl}/oauth')) {
              return NavigationDecision.navigate;
            }
            return NavigationDecision.prevent;
          },
        ),
      )
      ..loadRequest(Uri.parse(ZohoUrlConfig.loginPageUrl));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        log(state.toString());
      },
      builder: (context, state) {
        return Scaffold(
          body: SafeArea(child: _buildBody(state)),
        );
      },
    );
  }

  Widget _buildBody(AuthState state) => switch (state) {
        LoadingAuthState() => const LoadingAnimationView(),
        _ => WebViewWidget(controller: controller),
      };
}
