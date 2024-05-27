import 'package:example/src/example/data/remote/responses/example_response.dart';
import 'package:example/src/example/domain/models/example_dto.dart';

extension ExampleExt on ExampleResponse? {
  ExampleDto toDto() {
    return ExampleDto(
      id: this?.id ?? '',
      name: this?.name ?? '',
      subAreas: this
              ?.subAreas
              ?.map((subAreas) => SubAreasDto(
                    id: subAreas.id ?? '',
                    name: subAreas.name ?? '',
                    pics: subAreas.pics
                            ?.map((pics) => PicsDto(
                                  nik: pics.nik ?? '',
                                  name: pics.name ?? '',
                                  imageProfile: pics.imageProfile ?? '',
                                  positionName: pics.positionName ?? '',
                                  departementName: pics.departementName ?? '',
                                ))
                            .toList() ??
                        const [],
                    areaId: subAreas.areaId ?? '',
                    totalPic: subAreas.totalPic ?? 0,
                    createdAt: subAreas.createdAt ?? '',
                    updatedAt: subAreas.updatedAt ?? '',
                  ))
              .toList() ??
          const [],
      createdAt: this?.createdAt ?? '',
      projectId: this?.projectId ?? '',
      updatedAt: this?.updatedAt ?? '',
      projectName: this?.projectName ?? '',
      totalSubArea: this?.totalSubArea ?? 0,
    );
  }
}
