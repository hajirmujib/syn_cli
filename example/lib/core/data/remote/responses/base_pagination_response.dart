import 'package:json_annotation/json_annotation.dart';

part 'base_pagination_response.g.dart';

///
/// {
///   "status": <bool>,
///   "code": <int>,
///   "data": <T>
/// }
///
@JsonSerializable(genericArgumentFactories: true)
class BasePaginationResponse<T> {
  @JsonKey(name: 'status')
  final bool? status;
  @JsonKey(name: 'code')
  final int? code;
  @JsonKey(name: 'message')
  final String? message;
  @JsonKey(name: 'page')
  final int? page;
  @JsonKey(name: 'count')
  final int? count;
  @JsonKey(name: 'total_data')
  final int? totalData;
  @JsonKey(name: 'data')
  final T? data;

  BasePaginationResponse({
    this.status,
    this.code,
    this.message,
    this.page,
    this.count,
    this.totalData,
    this.data,
  });

  factory BasePaginationResponse.fromJson(
      Map<String, dynamic> json,
      T Function(Object? json) fromJsonT,
      ) =>
      _$BasePaginationResponseFromJson(json, fromJsonT);
}
