import 'package:dio/dio.dart';

final dioLogin = Dio(
  BaseOptions(
    
    baseUrl: 'http://115.79.196.171:1801/',
  ),
);
final dioFarm = Dio(BaseOptions(baseUrl: 'http://115.79.196.171:6789/'));