import 'package:flutter_test/flutter_test.dart';
import 'package:inkboard/domain/common/result.dart';

void main() {
  test('Result.map 在 data=null 时返回失败', () {
    final r = Result<Object?>.success(null);
    final mapped = r.map((v) => v.toString());
    expect(mapped.isSuccess, isFalse);
  });
}
