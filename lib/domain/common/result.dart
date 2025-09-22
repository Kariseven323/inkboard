/// 通用结果类，用于封装操作的成功或失败状态
class Result<T> {
  final T? data;
  final String? error;
  final bool isSuccess;

  Result._(this.data, this.error, this.isSuccess);

  /// 创建成功结果
  factory Result.success(T data) => Result._(data, null, true);

  /// 创建失败结果
  factory Result.failure(String error) => Result._(null, error, false);

  /// 是否失败
  bool get isFailure => !isSuccess;

  /// 获取数据，如果失败则抛出异常
  T get dataOrThrow {
    if (isFailure) {
      throw Exception(error);
    }
    final value = data;
    if (value == null) {
      throw Exception('数据为空');
    }
    return value;
  }

  /// 获取数据，如果失败则返回默认值
  T getDataOrDefault(T defaultValue) {
    final value = data;
    return isSuccess && value != null ? value : defaultValue;
  }

  /// 转换数据类型
  Result<R> map<R>(R Function(T data) transform) {
    if (isFailure) {
      return Result.failure(error!);
    }
    try {
      final value = data;
      if (value == null) {
        return Result.failure('数据为空');
      }
      return Result.success(transform(value));
    } catch (e) {
      return Result.failure('数据转换失败: $e');
    }
  }

  /// 链式操作
  Result<R> flatMap<R>(Result<R> Function(T data) transform) {
    if (isFailure) {
      return Result.failure(error!);
    }
    final value = data;
    if (value == null) {
      return Result.failure('数据为空');
    }
    return transform(value);
  }

  @override
  String toString() {
    if (isSuccess) {
      return 'Result.success($data)';
    } else {
      return 'Result.failure($error)';
    }
  }
}
