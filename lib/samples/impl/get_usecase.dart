import '../interface/sample_interface.dart';

/// [Sample] file from Module_Controller file creation.
class UseCaseSample extends Sample {
  final String _nameRepository;
  final String _parameter;
  final String _nameDto;
  final String _nameUsecase;
  final String _nameFuncRepo;
  final String _import;

  final bool _isPagination;
  UseCaseSample(
      super.path,
      this._isPagination,
      this._nameRepository,
      this._parameter,
      this._nameDto,
      this._nameUsecase,
      this._nameFuncRepo,
      this._import,
      {super.overwrite});

  @override
  String get content => _isPagination ? contentPagination : customParameter;

  String get customParameter => '''
$_import

class ${_nameUsecase}UseCase{
  final ${_nameRepository}Repository _repository;

  ${_nameUsecase}UseCase(this._repository);

  FutureOrError<${_nameDto}Dto> execute($_parameter) {
      return _repository
          .$_nameFuncRepo(${_parameter.replaceAll("String ", "").replaceAll("int", "").replaceAll("double", "").replaceAll("bool", "")})
          .mapRight((response) => response.data.toDto());
  }
}
''';

  String get contentPagination => '''
$_import

class ${_nameUsecase}UseCase{
  final ${_nameRepository}Repository _repository;

  ${_nameUsecase}UseCase(this._repository);

  FutureOrError<BasePaginationDto<${_nameDto}Dto>> execute({
    int? page = 1,
    int? size = 10,
    String keyword=''}) {
      return _repository
          .$_nameFuncRepo(
        page: page,
        size:size,
        keyword:keyword,
      )
        .mapRight((response) {
        var data = response.data?.map(_mapData).toList() ?? [];

        return BasePaginationDto(
          data: data,
          page: response.page ?? 1,
          totalData: response.totalData ?? 1,
          count: response.count ?? 1,
        );
      });
      
  }
  ${_nameDto}Dto _mapData(${_nameDto}Response ${_nameDto.toLowerCase()}Response) {
    return ${_nameDto.toLowerCase()}Response.toDto();
  }
}
''';
}
