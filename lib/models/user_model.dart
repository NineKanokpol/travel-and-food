class UserModel {
  String? auth;
  String? userName;
  String? password;
  String? email;
  String? firstName;
  String? lastName;

  UserModel(
      {this.userName,
      this.firstName,
      this.password,
      this.email,
      this.lastName,
      this.auth});

  UserModel.fromJson(Map<String, dynamic> json) {
    userName = json['user_name'];
    password = json['password'];
    email = json['email'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    auth = json['auth'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_name'] = this.userName;
    data['password'] = this.password;
    data['email'] = this.email;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['auth'] = this.auth;
    return data;
  }
}
