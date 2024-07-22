// ignore_for_file: file_names

class PostModel {
  String? userName;
  String? userProfilePic;
  String? postText;
  String? dateTime;
  List<String>? images;
  List<String>? animes;

  PostModel(
      {this.userName,
      this.userProfilePic,
      this.postText,
      this.dateTime,
      this.images,
      this.animes});

  PostModel.fromJson(Map<String, dynamic> json) {
    userName = json['userName'];
    userProfilePic = json['userProfilePic'];
    postText = json['postText'];
    dateTime = json['dateTime'];
    images = json['images'].cast<String>();
    animes = json['animes'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['userName'] = userName;
    data['userProfilePic'] = userProfilePic;
    data['postText'] = postText;
    data['dateTime'] = dateTime;
    data['images'] = images;
    data['animes'] = animes;
    return data;
  }
}
