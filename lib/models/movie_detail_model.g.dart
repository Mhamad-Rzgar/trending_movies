// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie_detail_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MovieDetailModelAdapter extends TypeAdapter<MovieDetailModel> {
  @override
  final int typeId = 0;

  @override
  MovieDetailModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MovieDetailModel(
      overview: fields[0] as String,
      budget: fields[1] as int?,
      revenue: fields[2] as int?,
      spokenLanguages: (fields[3] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, MovieDetailModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.overview)
      ..writeByte(1)
      ..write(obj.budget)
      ..writeByte(2)
      ..write(obj.revenue)
      ..writeByte(3)
      ..write(obj.spokenLanguages);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MovieDetailModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
