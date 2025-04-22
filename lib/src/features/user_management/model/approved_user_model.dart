class ApprovedUserModel {
  int? id;
  String? username;
  String? email;
  String? firstName;
  bool? isSuperuser;
  bool? isStaff;

  ApprovedUserModel(
      {this.id,
        this.username,
        this.email,
        this.firstName,
        this.isSuperuser,
        this.isStaff});

  ApprovedUserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    email = json['email'];
    firstName = json['first_name'];
    isSuperuser = json['is_superuser'];
    isStaff = json['is_staff'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['username'] = username;
    data['email'] = email;
    data['first_name'] = firstName;
    data['is_superuser'] = isSuperuser;
    data['is_staff'] = isStaff;
    return data;
  }
}
