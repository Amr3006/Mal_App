// ignore_for_file: file_names

class CharacterModel {
  late int malId;
  String? url;
  String? image;
  String? name;

  CharacterModel(
      {required this.malId,
      this.url,
      this.image,
      this.name,
      });

  CharacterModel.fromJson(Map<String, dynamic> json) {
    malId = json['mal_id'];
    url = json['url'];
    image = json["images"]["jpg"]["image_url"];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['mal_id'] = malId;
    data['url'] = url;
    data['image'] = image;
    data['name'] = name;
    return data;
  }
}
