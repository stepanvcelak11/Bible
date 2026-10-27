import 'package:bible_reader/core/utils/fts_query.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('slova jako předpony v uvozovkách', () {
    expect(buildFtsQuery('láska Boží'), '"láska"* "Boží"*');
  });

  test('fráze v rovných i českých uvozovkách', () {
    expect(buildFtsQuery('"chléb života" víra'), '"chléb života" "víra"*');
    expect(buildFtsQuery('„dobrý pastýř“'), '"dobrý pastýř"');
  });

  test('operátory a speciální znaky se neinterpretují', () {
    expect(buildFtsQuery('a OR b*'), '"a"* "OR"* "b"*');
    expect(buildFtsQuery(r'^:(){}'), isNull);
    expect(buildFtsQuery(''), isNull);
  });
}
