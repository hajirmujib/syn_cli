class KeyValueDto<T> {
  final String key;
  final T? value;

  const KeyValueDto({
    required this.key,
    this.value,
  });

  @override
  String toString() {
    return 'KeyValueDto{key: $key, value: $value}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is KeyValueDto && other.key == key && other.value == value;
  }

  @override
  int get hashCode => key.hashCode ^ value.hashCode;

  KeyValueDto<T> copyWith({
    String? key,
    T? value,
  }) {
    return KeyValueDto<T>(
      key: key ?? this.key,
      value: value ?? this.value,
    );
  }
}
