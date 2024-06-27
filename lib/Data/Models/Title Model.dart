// ignore_for_file: file_names

class TitleModel {
  String? type;
  String? title;

  TitleModel({this.type, this.title});

  TitleModel.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['title'] = title;
    return data;
  }
}