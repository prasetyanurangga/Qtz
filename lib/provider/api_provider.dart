import 'package:Qtz/constant.dart';
import 'package:dio/dio.dart';
import 'custom_exception.dart';
import 'response_data.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';


class ApiProvider{
  final Dio _dio = Dio();

  Future<Response> getQuotes(String filter, String type) async {
    String _endpoint = "https://favqs.com/api/quotes$filter$type";
    Response response;
    try {
      response = await _dio.get(_endpoint, options: 
        Options(headers: {
          "Authorization": "Token token=$apiKey",
        })
      );
    } on Error catch (e) {
      throw Exception('Failed to load post ' + e.toString());
    }
    return response;
  }
}