class AppUserInfos {
  String? email;
  String? firstname;
  String? lastname;
  String? avatar;
  int? roleId;
  String? roleLabel;
  int? rolePower;

  AppUserInfos({
    this.email,
    this.firstname,
    this.lastname,
    this.avatar,
    this.roleId,
    this.roleLabel,
    this.rolePower
  });

  AppUserInfos.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    firstname = json['firstName'];
    lastname = json['lastName'];
    avatar = json['avatar'];
    roleId = json["roleId"];
    roleLabel = json["roleLabel"];
    rolePower = json["rolePower"];
  }
}