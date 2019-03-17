import 'package:surprize/Models/User.dart';
import 'package:surprize/Resources/StringResources.dart';

/*
Model class for player
 */
class Player extends User{
  Player(String membershipId, String name, String dob, String address, String country, String gender, String email, String phoneNumber, DateTime membershipDate, String profileImageURL) :
        super(membershipId, name, dob, address, country, gender, email, phoneNumber, membershipDate, profileImageURL);

  /*
 Convert player to map
   */
  Map<String, dynamic> toMap(){
    var map = new Map<String, dynamic>();

    if(membershipId != null){
      map[StringResources.fieldPlayerId] = membershipId;
    }
    map[StringResources.fieldPlayerName] = name;
    map[StringResources.fieldPlayerDOB] = dob;
    map[StringResources.fieldPlayerAddress] = address;
    map[StringResources.fieldPlayerCountry] = country;
    map[StringResources.fieldPlayerGender] = gender;
    map[StringResources.fieldPlayerEmail] = email;
    map[StringResources.fieldPlayerPhoneNumber] = phoneNumber;
    map[StringResources.fieldPlayerMembershipDate] = membershipDate;
    map[StringResources.fieldPlayerProfileURL] = profileImageURL;

    return map;
  }

  /*
  Convert map to player
   */
  Player.fromMap(Map<String, dynamic> map) : super( map[StringResources.fieldPlayerId],
      map[StringResources.fieldPlayerName],
      map[StringResources.fieldPlayerDOB],
      map[StringResources.fieldPlayerAddress],
      map[StringResources.fieldPlayerCountry],
      map[StringResources.fieldPlayerGender],
      map[StringResources.fieldPlayerEmail] ,
      map[StringResources.fieldPlayerPhoneNumber],
      map[StringResources.fieldPlayerMembershipDate],
      map[StringResources.fieldPlayerProfileURL]);

}