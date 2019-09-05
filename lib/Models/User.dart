/*
Model of basic user
 */
class User{
  String _membershipId;
  String _email;
  String _name;
  String _gender;
  String _dob;
  String _address;
  String _country;
  String _phoneNumber;
  DateTime _membershipDate;
  String _profileImageURL;

  User(this._membershipId, this._name, this._dob, this._address, this. _country, this._gender,
      this._email, this._phoneNumber, this._membershipDate, this._profileImageURL);

  String get membershipId => _membershipId;
  String get name => _name;
  String get dob => _dob;
  String get gender => _gender;
  String get email => _email;
  DateTime get membershipDate => _membershipDate;
  String get profileImageURL => _profileImageURL;
  String get phoneNumber => _phoneNumber;
  String get country => _country;
  String get address => _address;

  set membershipId(String membershipId) => _membershipId;
  set name(String name) => _name = name;
  set dob(String dob) => _dob = dob;
  set gender(String gender) => _gender = gender;
  set email(String email) => _email = email;
  set membershipDate(DateTime membershipDate) => _membershipId;
  set profileImageURL(String url) => _profileImageURL = url;
  set phoneNumber(String phoneNumber) => _phoneNumber = phoneNumber;
  set country(String country) => _country = country;
  set address(String address) => _address = address;
}