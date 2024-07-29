// ignore_for_file: file_names

class PostModel {
  late String userName;
  late String userProfilePic;
  late String postText;
  late String dateTime;
  late List<String> images;

  PostModel(
      {required this.userName,
      required this.userProfilePic,
      required this.postText,
      required this.dateTime,
      required this.images,});

  PostModel.fromJson(Map<String, dynamic> json) {
    userName = json['userName'];
    userProfilePic = json['userProfilePic'];
    postText = json['postText'];
    dateTime = json['dateTime'];
    images = json['images'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['userName'] = userName;
    data['userProfilePic'] = userProfilePic;
    data['postText'] = postText;
    data['dateTime'] = dateTime;
    data['images'] = images;
    return data;
  }
}
