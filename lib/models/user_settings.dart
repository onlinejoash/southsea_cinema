class UserSettings {
  String patron;
  String address;
  String email;
  bool receiveNewsletter;

  UserSettings({
    this.patron = '',
    this.address = '',
    this.email = '',
    this.receiveNewsletter = false,
  });
}
