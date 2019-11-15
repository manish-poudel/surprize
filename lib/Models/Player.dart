import 'package:Surprize/Helper/AppHelper.dart';
import 'package:Surprize/Models/User.dart';
import 'package:Surprize/Resources/FirestoreResources.dart';

/*
Model class for player
 */
class Player extends User{
  Player(String membershipId, String name, String dob, String address, String country, String gender, String email, String phoneNumber, DateTime membershipDate, String profileImageURL, bool accountVerified) :
        super(membershipId, name, dob, address, country, gender, email, phoneNumber, membershipDate, profileImageURL,accountVerified);

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
    map[FirestoreResources.fieldPlayerAccountVerified] = accountVerified;

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
      map[FirestoreResources.fieldPlayerProfileURL],
      map[FirestoreResources.fieldPlayerAccountVerified]
  );

  /*
  Convert map to player
   */
  Player.fromSQLiteMap(Map<String, dynamic> map) : super( map[FirestoreResources.fieldPlayerId],
      map[FirestoreResources.fieldPlayerName],
      map[FirestoreResources.fieldPlayerDOB],
      map[FirestoreResources.fieldPlayerAddress],
      map[FirestoreResources.fieldPlayerCountry],
      map[FirestoreResources.fieldPlayerGender],
      map[FirestoreResources.fieldPlayerEmail] ,
      map[FirestoreResources.fieldPlayerPhoneNumber],
      DateTime.parse(map[FirestoreResources.fieldPlayerMembershipDate].toString().split('&&&')[0]),
      map[FirestoreResources.fieldPlayerProfileURL],
      map[FirestoreResources.fieldPlayerAccountVerified] == "true"
  );
}
