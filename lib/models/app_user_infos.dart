class AppUserInfos {
  int? id;
  String? displayName;
  String? role;
  String? avatar;

  AppUserInfos({
    this.id,
    this.displayName,
    this.role,
    this.avatar
  });

  AppUserInfos.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    displayName = json['displayName'];
    role = json['role'];
    avatar = json['avatar'];
  }
}