// ignore_for_file: file_names

class DetailedCharacterModel {
  late int malId;
  String? url;
  String? image;
  String? name;
  String? nameKanji;
  List<String>? nicknames;
  int? favorites;
  String? about;

  DetailedCharacterModel(
      {required this.malId,
      this.url,
      this.image,
      this.name,
      this.nameKanji,
      this.nicknames,
      this.favorites,
      this.about});

  DetailedCharacterModel.fromJson(Map<String, dynamic> json) {
    malId = json['mal_id'];
    url = json['url'];
    image = json["images"]["jpg"]["image_url"];
    name = json['name'];
    nameKanji = json['name_kanji'];
    nicknames = json['nicknames'].cast<String>();
    favorites = json['favorites'];
    about = json['about'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['mal_id'] = malId;
    data['url'] = url;
    data['image'] = image;
    data['name'] = name;
    data['name_kanji'] = nameKanji;
    data['nicknames'] = nicknames;
    data['favorites'] = favorites;
    data['about'] = about;
    return data;
  }
}
