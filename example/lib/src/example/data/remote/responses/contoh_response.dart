import 'package:json_annotation/json_annotation.dart';

part 'contoh_response.g.dart';

@JsonSerializable()
class ContohResponse {
  @JsonKey(name: "id")
  final String? id;

  @JsonKey(name: "name")
  final String? name;

  @JsonKey(name: "sub_areas")
  final List<SubAreasResponse>? subAreas;

  @JsonKey(name: "created_at")
  final String? createdAt;

  @JsonKey(name: "project_id")
  final String? projectId;

  @JsonKey(name: "updated_at")
  final String? updatedAt;

  @JsonKey(name: "project_name")
  final String? projectName;

  @JsonKey(name: "total_sub_area")
  final int? totalSubArea;

  ContohResponse(this.id, this.name, this.subAreas, this.createdAt,
      this.projectId, this.updatedAt, this.projectName, this.totalSubArea);
}

class SubAreasResponse {
  @JsonKey(name: "id")
  final String? id;

  @JsonKey(name: "name")
  final String? name;

  @JsonKey(name: "pics")
  final List<PicsResponse>? pics;

  @JsonKey(name: "area_id")
  final String? areaId;

  @JsonKey(name: "total_pic")
  final int? totalPic;

  @JsonKey(name: "created_at")
  final String? createdAt;

  @JsonKey(name: "updated_at")
  final String? updatedAt;

  SubAreasResponse(this.id, this.name, this.pics, this.areaId, this.totalPic,
      this.createdAt, this.updatedAt);
}

class PicsResponse {
  @JsonKey(name: "nik")
  final String? nik;

  @JsonKey(name: "name")
  final String? name;

  @JsonKey(name: "image_profile")
  final String? imageProfile;

  @JsonKey(name: "position_name")
  final String? positionName;

  @JsonKey(name: "departement_name")
  final String? departementName;

  PicsResponse(this.nik, this.name, this.imageProfile, this.positionName,
      this.departementName);
}
