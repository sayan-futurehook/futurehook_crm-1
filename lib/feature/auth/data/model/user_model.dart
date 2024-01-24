import 'package:futurehook_crm/feature/auth/domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.name,
    required super.email,
  });

  static UserModel? fromJson(Map<String, dynamic> json) {
    if (json
        case {
          "users": [
            {
              'id': String id,
              'full_name': String? name,
              'email': String? email,
            }
          ]
        }) {
      return UserModel(id: id, name: name, email: email);
    }

    return null;
  }

  Map<String, dynamic> get toJson =>
      {'id': id, 'full_name': name, 'email': email};
}
