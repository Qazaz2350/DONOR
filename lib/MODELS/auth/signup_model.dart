class SignUpModel {
  String fullName;
  String email;
  String password;
  String userType; // "donor" or "orphanage"
  String phone; // new field for phone number

  SignUpModel({
    this.fullName = '',
    this.email = '',
    this.password = '',
    this.userType = '', // default empty
    this.phone = '', // default empty
  });
}
