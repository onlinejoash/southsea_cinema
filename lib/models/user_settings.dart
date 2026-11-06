class UserSettings {
  String name;
  String address;
  String email;
  bool receiveNewsletter;

  UserSettings({
    this.name = '',
    this.address = '',
    this.email = '',
    this.receiveNewsletter = false,
  });
}
