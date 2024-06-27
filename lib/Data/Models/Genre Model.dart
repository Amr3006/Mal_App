
// ignore_for_file: file_names

class GenreModel {
  int? malId;
  String? type;
  String? name;
  String? url;

  GenreModel({this.malId, this.type, this.name, this.url});

  GenreModel.fromJson(Map<String, dynamic> json) {
    malId = json['mal_id'];
    type = json['type'];
    name = json['name'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['mal_id'] = malId;
    data['type'] = type;
    data['name'] = name;
    data['url'] = url;
    return data;
  }
}
