///json ในการเก็บข้อมูล login
class LoginModel {
  String? authId;
  String? password;
  String? email;

  LoginModel({this.authId, this.password, this.email});

  LoginModel.fromJson(Map<String, dynamic> json) {
    authId = json['user_name'];
    password = json['password'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_name'] = this.authId;
    data['password'] = this.password;
    data['email'] = this.email;
    return data;
  }
}