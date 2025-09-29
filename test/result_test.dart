import 'package:flutter_test/flutter_test.dart';

import 'package:inkboard/domain/common/result.dart';

void main() {
  test('Result success/failure 基本行为', () {
    final r1 = Result.success(42);
    expect(r1.isSuccess, isTrue);
    expect(r1.isFailure, isFalse);
    expect(r1.dataOrThrow, 42);
    expect(r1.getDataOrDefault(0), 42);

    final r2 = Result.failure('错误');
    expect(r2.isSuccess, isFalse);
    expect(r2.isFailure, isTrue);
    expect(r2.getDataOrDefault(7), 7);
    expect(() => r2.dataOrThrow, throwsA(isA<Exception>()));
  });

  test('Result.map 与 flatMap', () {
    final r = Result.success(10);
    final mapped = r.map((v) => 'v=$v');
    expect(mapped.isSuccess, isTrue);
    expect(mapped.dataOrThrow, 'v=10');

    final flat = r.flatMap((v) => Result.success(v * 2));
    expect(flat.dataOrThrow, 20);

    final failure = Result<int>.failure('x');
    expect(failure.map((v) => v + 1).isFailure, isTrue);
    expect(failure.flatMap((v) => Result.success(v + 1)).isFailure, isTrue);
  });

  test('Result.toString 描述', () {
    expect(Result.success(1).toString(), contains('Result.success'));
    expect(Result.failure('err').toString(), contains('Result.failure'));
  });
}
