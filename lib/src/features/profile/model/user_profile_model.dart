class UserProfileModel {
  String? email;
  String? firstName;
  String? phoneNo;
  String? companyName;
  String? address;

  UserProfileModel(
      {this.email,
        this.firstName,
        this.phoneNo,
        this.companyName,
        this.address});

  UserProfileModel.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    firstName = json['first_name'];
    phoneNo = json['phone_no'];
    companyName = json['company_name'];
    address = json['address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = email;
    data['first_name'] = firstName;
    data['phone_no'] = phoneNo;
    data['company_name'] = companyName;
    data['address'] = address;
    return data;
  }
}
