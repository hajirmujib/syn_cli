class BasePaginationDto<T> {
  final List<T> data;
  final int page;
  final int totalData;
  final int count;

  const BasePaginationDto({
    required this.data,
    this.page = 1,
    this.totalData = 1,
    this.count = 1,
  });

  @override
  String toString() {
    return 'BasePaginationDto{data: $data, page: $page, totalData: $totalData, count: $count}';
  }
}