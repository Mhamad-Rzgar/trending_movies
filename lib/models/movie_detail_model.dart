import 'package:hive/hive.dart';

part 'movie_detail_model.g.dart';

@HiveType(typeId: 0)
class MovieDetailModel {
  @HiveField(0)
  final String overview;

  @HiveField(1)
  final int? budget;

  @HiveField(2)
  final int? revenue;

  @HiveField(3)
  final List<String> spokenLanguages;

  MovieDetailModel({
    required this.overview,
    this.budget,
    this.revenue,
    required this.spokenLanguages,
  });

  factory MovieDetailModel.fromJson(Map<String, dynamic> json) {
    List<String> languages = (json['spoken_languages'] as List?)
            ?.map((e) => e['english_name'] as String)
            .toList() ??
        <String>[];
    return MovieDetailModel(
        overview: json['overview'],
        budget: json['budget'],
        revenue: json['revenue'],
        spokenLanguages:
            languages.length > 2 ? languages.sublist(0, 2) : languages);
  }
}
