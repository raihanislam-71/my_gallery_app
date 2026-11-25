import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

void main() {
  test('Test downloading photo from DigitalOcean spaces', () async {
    const url = 'https://na8ure.sfo3.digitaloceanspaces.com/images/220552';
    print('Fetching $url ...');

    final response = await http.get(Uri.parse(url));
    print('Status code: ${response.statusCode}');
    print('Content length: ${response.bodyBytes.length}');
    print('Headers: ${response.headers}');

    final client = HttpClient();
    final request = await client.getUrl(Uri.parse(url));
    final res = await request.close();
    print('HttpClient status code: ${res.statusCode}');
    print('HttpClient content length: ${res.contentLength}');
  });
}
