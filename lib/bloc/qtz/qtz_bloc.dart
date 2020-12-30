import 'dart:async';

import 'package:Qtz/bloc/qtz/qtz_event.dart';
import 'package:Qtz/bloc/qtz/qtz_state.dart';
import 'package:Qtz/models/qtz_model.dart';
import 'package:Qtz/provider/response_data.dart';
import 'package:Qtz/repository/qtz_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

class QtzBloc extends Bloc<QtzEvent, QtzState> {
  QtzRepository qtzRepository = QtzRepository();

  QtzBloc() : super(QtzInitial());

  @override
  QtzState get initialState =>QtzInitial();

  @override
  Stream<QtzState> mapEventToState(QtzEvent event) async* {
    if (event is GetQuotes) { 
      yield QtzLoading();
      try {
        final ResponseData<dynamic> response = await qtzRepository.getQuotes(event.filter, event.type);
        if (response.status == Status.ConnectivityError) {
          yield const QtzFailure(error: "");
        }
        if (response.status == Status.Success) {
          yield QtzSuccess(qtzModel: response.data);
        } else {
          yield QtzFailure(error: response.message);
        }
      } catch (error) {
        // print(error);
        yield QtzFailure(error: error.toString());
      }
    }

    if (event is GetTagQuotes) { 
      yield QtzTagLoading();
      try {
        final ResponseData<dynamic> response = await qtzRepository.getQuotes(event.filter, event.type);
        if (response.status == Status.ConnectivityError) {
          yield const QtzTagFailure(error: "");
        }
        if (response.status == Status.Success) {
          yield QtzTagSuccess(qtzModel: response.data);
        } else {
          yield QtzTagFailure(error: response.message);
        }
      } catch (error) {
        yield QtzTagFailure(error: error.toString());
      }
    }
  }
}