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
    return MovieDetailModel(
      overview: json['overview'],
      budget: json['budget'],
      revenue: json['revenue'],
      spokenLanguages: json['spoken'] == null
          ? <String>[]
          : (json['spoken'] as List<String>).map((e) => e).toList(),
    );
  }
}
