import 'package:surprize/Helper/AppHelper.dart';
import 'package:surprize/Models/User.dart';
import 'package:surprize/Resources/FirestoreResources.dart';

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
      map[FirestoreResources.fieldPlayerId] = membershipId;
    }
    map[FirestoreResources.fieldPlayerName] = name;
    map[FirestoreResources.fieldPlayerDOB] = dob;
    map[FirestoreResources.fieldPlayerAddress] = address;
    map[FirestoreResources.fieldPlayerCountry] = country;
    map[FirestoreResources.fieldPlayerGender] = gender;
    map[FirestoreResources.fieldPlayerEmail] = email;
    map[FirestoreResources.fieldPlayerPhoneNumber] = phoneNumber;
    map[FirestoreResources.fieldPlayerMembershipDate] = membershipDate;
    map[FirestoreResources.fieldPlayerProfileURL] = profileImageURL;

    return map;
  }

  /*
  Convert map to player
   */
  Player.fromMap(Map<String, dynamic> map) : super( map[FirestoreResources.fieldPlayerId],
      map[FirestoreResources.fieldPlayerName],
      map[FirestoreResources.fieldPlayerDOB],
      map[FirestoreResources.fieldPlayerAddress],
      map[FirestoreResources.fieldPlayerCountry],
      map[FirestoreResources.fieldPlayerGender],
      map[FirestoreResources.fieldPlayerEmail] ,
      map[FirestoreResources.fieldPlayerPhoneNumber],
      AppHelper.convertToDateTime(map[FirestoreResources.fieldPlayerMembershipDate]),
      map[FirestoreResources.fieldPlayerProfileURL]);
}
