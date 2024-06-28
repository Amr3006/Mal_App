// ignore_for_file: file_names

import 'package:mal_app/Data/Models/Genre%20Model.dart';
import 'package:mal_app/Data/Models/Title%20Model.dart';

class AnimeModel {
  late int malId;
  String? url;
  String? image;
  bool? approved;
  List<TitleModel>? titles;
  int? episodes;
  String? status;
  String? duration;
  String? rating;
  double? score;
  String? type;
  int? scoredBy;
  int? rank;
  int? popularity;
  int? members;
  int? favorites;
  String? synopsis;
  String? season;
  String? background;
  int? year;
  List<GenreModel>? genres;
  List<GenreModel>? explicitGenres;
  List<GenreModel>? demographics;

  AnimeModel(
      {required this.malId,
      this.url,
      this.image,
      this.approved,
      this.titles,
      this.episodes,
      this.status,
      this.duration,
      this.rating,
      this.score,
      this.background,
      this.scoredBy,
      this.rank,
      this.popularity,
      this.type,
      this.members,
      this.favorites,
      this.synopsis,
      this.season,
      this.year,
      this.genres,
      this.explicitGenres,
      this.demographics});

  AnimeModel.fromJson(Map<String, dynamic> json) {
    malId = json['mal_id'];
    url = json['url'];
    image = json["images"]["jpg"]["image_url"];
    approved = json['approved'];
    if (json['titles'] != null) {
      titles = <TitleModel>[];
      json['titles'].forEach((v) {
        titles!.add(TitleModel.fromJson(v));
      });
    }
    episodes = json['episodes'];
    background = json['background'];
    status = json['status'];
    type = json['type'];
    duration = json['duration'];
    rating = json['rating'];
    score = json['score']==null ? null : json["score"].toDouble();
    scoredBy = json['scored_by'];
    rank = json['rank'];
    popularity = json['popularity'];
    members = json['members'];
    favorites = json['favorites'];
    synopsis = json['synopsis'];
    season = json['season'];
    year = json['year'];
    if (json['genres'] != null) {
      genres = <GenreModel>[];
      json['genres'].forEach((v) {
        genres!.add(GenreModel.fromJson(v));
      });
    }
    if (json['explicit_genres'] != null) {
      explicitGenres = <GenreModel>[];
      json['explicit_genres'].forEach((v) {
        explicitGenres!.add(GenreModel.fromJson(v));
      });
    }
    if (json['demographics'] != null) {
      demographics = <GenreModel>[];
      json['demographics'].forEach((v) {
        demographics!.add(GenreModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['mal_id'] = malId;
    data['url'] = url;
    data['image'] = image;
    data['approved'] = approved;
    if (titles != null) {
      data['titles'] = titles!.map((v) => v.toJson()).toList();
    }
    data['episodes'] = episodes;
    data['background'] = background;
    data['status'] = status;
    data['duration'] = duration;
    data['type'] = type;
    data['rating'] = rating;
    data['score'] = score;
    data['scored_by'] = scoredBy;
    data['rank'] = rank;
    data['popularity'] = popularity;
    data['members'] = members;
    data['favorites'] = favorites;
    data['synopsis'] = synopsis;
    data['season'] = season;
    data['year'] = year;
    if (genres != null) {
      data['genres'] = genres!.map((v) => v.toJson()).toList();
    }
    if (explicitGenres != null) {
      data['explicit_genres'] =
          explicitGenres!.map((v) => v.toJson()).toList();
    }
    if (demographics != null) {
      data['demographics'] = demographics!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}


