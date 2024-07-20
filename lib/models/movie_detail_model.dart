class MovieDetailModel {
  final String overview;
  final int? budget;
  final int? revenue;
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
