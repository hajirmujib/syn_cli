class Example2Dto {
  final String? id;
  final String? name;
  final List<SubAreasDto>? subAreas;
  final String? createdAt;
  final String? projectId;
  final String? updatedAt;
  final String? projectName;
  final int? totalSubArea;

  Example2Dto(
      {this.id = '',
      this.name = '',
      this.subAreas = const [],
      this.createdAt = '',
      this.projectId = '',
      this.updatedAt = '',
      this.projectName = '',
      this.totalSubArea = 0});
}

class SubAreasDto {
  final String? id;
  final String? name;
  final List<PicsDto>? pics;
  final String? areaId;
  final int? totalPic;
  final String? createdAt;
  final String? updatedAt;

  SubAreasDto(
      {this.id = '',
      this.name = '',
      this.pics = const [],
      this.areaId = '',
      this.totalPic = 0,
      this.createdAt = '',
      this.updatedAt = ''});
}

class PicsDto {
  final String? nik;
  final String? name;
  final String? imageProfile;
  final String? positionName;
  final String? departementName;

  PicsDto(
      {this.nik = '',
      this.name = '',
      this.imageProfile = '',
      this.positionName = '',
      this.departementName = ''});
}
