import 'dart:convert';

String daffServerUrl = 'https://daff:deff@daff.dev';
// String daffServerUrl = 'https://daff.co.il';
String basicAuth = 'Basic ' + base64Encode(utf8.encode('daff:deff'));