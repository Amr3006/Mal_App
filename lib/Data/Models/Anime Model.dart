// ignore_for_file: file_names

class AnimeModel {
  int? malId;
  String? url;
  String? image;
  bool? approved;
  List<Titles>? titles;
  int? episodes;
  String? status;
  String? duration;
  String? rating;
  double? score;
  int? scoredBy;
  int? rank;
  int? popularity;
  int? members;
  int? favorites;
  String? synopsis;
  String? season;
  int? year;
  List<Genre>? genres;
  List<Genre>? explicitGenres;
  List<Genre>? demographics;

  AnimeModel(
      {this.malId,
      this.url,
      this.image,
      this.approved,
      this.titles,
      this.episodes,
      this.status,
      this.duration,
      this.rating,
      this.score,
      this.scoredBy,
      this.rank,
      this.popularity,
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
      titles = <Titles>[];
      json['titles'].forEach((v) {
        titles!.add(Titles.fromJson(v));
      });
    }
    episodes = json['episodes'];
    status = json['status'];
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
      genres = <Genre>[];
      json['genres'].forEach((v) {
        genres!.add(Genre.fromJson(v));
      });
    }
    if (json['explicit_genres'] != null) {
      explicitGenres = <Genre>[];
      json['explicit_genres'].forEach((v) {
        explicitGenres!.add(Genre.fromJson(v));
      });
    }
    if (json['demographics'] != null) {
      demographics = <Genre>[];
      json['demographics'].forEach((v) {
        demographics!.add(Genre.fromJson(v));
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
    data['status'] = status;
    data['duration'] = duration;
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

class Titles {
  String? type;
  String? title;

  Titles({this.type, this.title});

  Titles.fromJson(Map<String, dynamic> json) {
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

class Genre {
  int? malId;
  String? type;
  String? name;
  String? url;

  Genre({this.malId, this.type, this.name, this.url});

  Genre.fromJson(Map<String, dynamic> json) {
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
