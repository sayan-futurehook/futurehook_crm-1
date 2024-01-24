import 'package:futurehook_crm/feature/auth/domain/entities/access_tokens.dart';

class AccessTokensModel extends AccessTokens {
  AccessTokensModel({
    required super.accessToken,
    required super.refreshToken,
  });

  static AccessTokensModel? fromJson(Map<String, dynamic> json) {
    if (json
        case {
          "access_token": String accessToken,
          "refresh_token": String refreshToken,
        }) {
      return AccessTokensModel(
          accessToken: accessToken, refreshToken: refreshToken);
    }
    return null;
  }
}

class RefreshTokenModel {
  final String accessToken;
  RefreshTokenModel({
    required this.accessToken,
  });

  static RefreshTokenModel? fromJson(Map<String, dynamic> json) {
    if (json
        case {
          "access_token": String accessToken,
        }) {
      return RefreshTokenModel(
        accessToken: accessToken,
      );
    }
    return null;
  }
}
