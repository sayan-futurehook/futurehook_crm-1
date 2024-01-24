import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:futurehook_crm/core/error/failure.dart';
import 'package:futurehook_crm/feature/auth/data/model/get_tokens_response.dart';
import 'package:futurehook_crm/feature/auth/data/model/user_model.dart';

import '../../../../config/constatnt_config.dart';
import '../../../../config/zoho_url_config.dart';

abstract class AuthRemoteDataSource {
  // Future<UserModel> signInWithZoho(String grantToken);
  // Future<void> refreshToken();
  // Future<void> signOut();
  // Future<UserModel?> getCurrentUser();

  Future<Either<Failure, AccessTokensModel>> getAccessTokens(String grantToken);
  Future<Either<Failure, UserModel>> getuser(String accessToken);
  Future<Either<Failure, RefreshTokenModel>> refreshToken(String refreshToken);
}

// class AuthRemoteDataSourceImpl extends AuthRemoteDataSource {
//   final Dio dio;

//   AuthRemoteDataSourceImpl(
//     this.dio,
//   );

//   @override
//   Future<UserModel> signInWithZoho(String grantToken) async {
//     await _token(grantToken);
//     await getCurrentUserApi();
//     if (user == null) {
//       throw Exception();
//     }
//     return user!;
//   }

//   @override
//   Future<void> refreshToken() async {
//     try {
//       final res = await dio.post(
//         '${ZohoUrlConfig.accountsZohoUrl}/oauth/v2/token',
//         queryParameters: {
//           'refresh_token': _refreshToken,
//           'client_id': ConstantConfig.clientId,
//           'client_secret': ConstantConfig.clientSecet,
//           'grant_type': 'refresh_token',
//         },
//       );
//       _accessToken = res.data['access_token'];
//       var box = await hive.openBox(HiveKeyConfig.tokenBoxKey);
//       box.put(HiveKeyConfig.accessTokenKey, _accessToken);
//       box.close();
//     } on DioException catch (_) {
//       rethrow;
//     }
//   }

//   @override
//   Future<void> signOut() async {}

//   Future<void> _token(String grintToken) async {
//     try {
//       final res = await dio.post(
//         '${ZohoUrlConfig.accountsZohoUrl}/oauth/v2/token',
//         data: FormData.fromMap({
//           'grant_type': 'authorization_code',
//           'client_id': ConstantConfig.clientId,
//           'client_secret': ConstantConfig.clientSecet,
//           'redirect_uri': ZohoUrlConfig.redirectUrl,
//           'code': grintToken,
//         }),
//       );
//       _accessToken = res.data['access_token'];
//       _refreshToken = res.data['refresh_token'];
//       var box = await hive.openBox(HiveKeyConfig.tokenBoxKey);
//       box.put(HiveKeyConfig.accessTokenKey, _accessToken);
//       box.put(HiveKeyConfig.refreshTokenKey, _refreshToken);
//       box.close();
//     } on DioException catch (_) {
//       rethrow;
//     }
//   }

//   Future<void> getCurrentUserApi() async {
//     try {
//       final res = await dio.get(
//           '${ZohoUrlConfig.zohoApiUrl}/users?type=CurrentUser',
//           options: Options(
//               headers: {'Authorization': 'Zoho-oauthtoken $_accessToken'}));
//       user = UserModel.fomJson(res.data);
//       if (user != null) {
//         var box = await hive.openBox(HiveKeyConfig.tokenBoxKey);
//         box.put(HiveKeyConfig.user, user!.toJson);
//         box.close();
//       }
//     } on DioException catch (_) {
//       rethrow;
//     }
//   }

//   @override
//   Future<UserModel?> getCurrentUser() async {
//     if (!isSigned || user == null) {
//       return null;
//     }
//     return user;
//   }
// }

class AuthRemoteDataSourceImpl extends AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSourceImpl(this.dio);

  @override
  Future<Either<Failure, AccessTokensModel>> getAccessTokens(
      String grantToken) async {
    try {
      final res = await dio.post(
        '${ZohoUrlConfig.accountsZohoUrl}/oauth/v2/token',
        data: FormData.fromMap({
          'grant_type': 'authorization_code',
          'client_id': ConstantConfig.clientId,
          'client_secret': ConstantConfig.clientSecet,
          'redirect_uri': ZohoUrlConfig.redirectUrl,
          'code': grantToken,
        }),
      );
      if (AccessTokensModel.fromJson(res.data)
          case AccessTokensModel accessTokenModel) {
        return right(accessTokenModel);
      } else {
        return left(JsonParseFailure());
      }
    } on DioException catch (e) {
      return left(
          ServerFailure(e.response?.data['error'] as String? ?? e.message));
    }
  }

  @override
  Future<Either<Failure, UserModel>> getuser(String accessToken) async {
    try {
      final res = await dio.get(
          '${ZohoUrlConfig.zohoApiUrl}/users?type=CurrentUser',
          options: Options(
              headers: {'Authorization': 'Zoho-oauthtoken $accessToken'}));
      if (UserModel.fromJson(res.data) case UserModel userModel) {
        return right(userModel);
      } else {
        return left(JsonParseFailure());
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return left(TokenExpireFailure());
      }
      return left(
          ServerFailure(e.response?.data['error'] as String? ?? e.message));
    }
  }

  @override
  Future<Either<Failure, RefreshTokenModel>> refreshToken(
      String refreshToken) async {
    try {
      final res = await dio.post(
        '${ZohoUrlConfig.accountsZohoUrl}/oauth/v2/token',
        queryParameters: {
          'refresh_token': refreshToken,
          'client_id': ConstantConfig.clientId,
          'client_secret': ConstantConfig.clientSecet,
          'grant_type': 'refresh_token',
        },
      );
      if (RefreshTokenModel.fromJson(res.data)
          case RefreshTokenModel refreshTokenModel) {
        return right(refreshTokenModel);
      } else {
        return left(JsonParseFailure());
      }
    } on DioException catch (e) {
      return left(
          ServerFailure(e.response?.data['error'] as String? ?? e.message));
    }
  }
}
