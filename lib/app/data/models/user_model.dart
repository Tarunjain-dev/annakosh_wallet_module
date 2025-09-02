class UserModel {
  final String userName;
  final String email;
  final String password;
  final String currentUserUid;
  final String currentUserReferralCode;
  final String? parentUserUid;
  final int numberOfDirectReferrals;
  final int totalAnnakoshCoins;
  final List<String> directs;
  final int bonusPoints;

  UserModel({
    required this.userName,
    required this.email,
    required this.password,
    required this.currentUserUid,
    required this.currentUserReferralCode,
    this.parentUserUid,
    this.numberOfDirectReferrals = 0,
    this.totalAnnakoshCoins = 0,
    this.directs = const [],
    this.bonusPoints = 0,
  });

  Map<String, dynamic> toJSON() {
    return {
      "userName": userName,
      "email": email,
      "password": password,
      "currentUserUid": currentUserUid,
      "currentUserReferralCode": currentUserReferralCode,
      "parentUserUid": parentUserUid,
      "numberOfDirectReferrals": numberOfDirectReferrals,
      "totalAnnakoshCoins": totalAnnakoshCoins,
      "directs": directs,
      "bonusPoints" : bonusPoints,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userName: json["userName"], //d
      email: json["email"], //d
      password: json["password"], //d
      currentUserUid: json["currentUserUid"], //d
      currentUserReferralCode: json["currentUserReferralCode"], //d
      parentUserUid: json["parentUserUid"], //d
      numberOfDirectReferrals: json["numberOfDirectReferrals"], //d
      totalAnnakoshCoins: json["totalAnnakoshCoins"] ?? 0, //d
      directs: List<String>.from(json["directs"] ?? []),
      bonusPoints: json["bonusPoints"] ?? 0,
    );
  }

}
