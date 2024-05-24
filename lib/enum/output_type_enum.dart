enum OutputTypeEnum {
  pagination,
  baseOutput,
  unknown;

  static OutputTypeEnum fromtInt(String? type) {
    switch (type) {
      case "pagination":
        return pagination;
      case "base":
        return baseOutput;

      default:
        return unknown;
    }
  }

  static String fromtType(OutputTypeEnum? type) {
    switch (type) {
      case OutputTypeEnum.pagination:
        return "pagination";
      case OutputTypeEnum.baseOutput:
        return "base";

      default:
        return "";
    }
  }
}
