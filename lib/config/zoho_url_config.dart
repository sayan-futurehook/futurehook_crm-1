import 'constatnt_config.dart';

class ZohoUrlConfig {
  ZohoUrlConfig._();
  static const accountsZohoUrl = "https://accounts.zoho.com";
  static const zohoApiUrl = "https://www.zohoapis.com/crm/v2";
  static const redirectUrl = 'https://www.futurehook.com';
  static String loginPageUrl =
      'https://accounts.zoho.com/oauth/v2/auth?scope=${ConstantConfig.authScop}&client_id=${ConstantConfig.clientId}&response_type=code&access_type=offline&redirect_uri=$redirectUrl';
}
