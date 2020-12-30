import 'package:Qtz/models/qtz_model.dart';
import 'package:Qtz/provider/response_data.dart';
import 'package:Qtz/provider/api_provider.dart';
import 'package:dio/dio.dart';
import 'dart:async';

class QtzRepository{
  ApiProvider _apiProvider = ApiProvider();

  Future<ResponseData> getQuotes(String filter, String type) async{
  	Response response = await _apiProvider.getQuotes(filter, type);
  	QtzModel responseJust = QtzModel.fromJson(response.data);
  	if (responseJust == null) {
      return ResponseData.connectivityError();
    }

    if (response.statusCode == 200) {
      return ResponseData.success(responseJust);
    } else {
      return ResponseData.error("Error");
    }
  }


}