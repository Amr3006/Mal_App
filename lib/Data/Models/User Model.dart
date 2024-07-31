// ignore_for_file: non_constant_identifier_names, file_names

class UserModel {
  late String name;
  late String email;
  late String phone;
  late String uId;
  late List<dynamic> favourites;
  late List<dynamic> postIDs;
  late String profilePicture;

  UserModel(
      {required this.name,
      required this.favourites,
      required this.email,
      required this.phone,
      required this.profilePicture,
      required this.uId,
      required this.postIDs});

  UserModel.fromJson(Map<String, dynamic> json) {
    name = json["name"];
    email = json["email"];
    favourites = json["favourites"];
    phone = json["phone"];
    uId = json["uId"];
    postIDs = json["postIDs"];
    profilePicture = json["profilePicture"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['email'] = email;
    data['phone'] = phone;
    data['uId'] = uId;
    data['favourites'] = favourites;
    data['profilePicture'] = profilePicture;
    data['postIDs'] = postIDs;
    return data;
  }

  UserModel clone() {
    return UserModel(
      favourites: List.from(favourites),
      postIDs: List.from(postIDs),
        name: name,
        email: email,
        phone: phone,
        profilePicture: profilePicture,
        uId: uId);
  }
}
