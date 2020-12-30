import 'package:Qtz/models/qtz_model.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class QtzState extends Equatable {
  const QtzState();

  @override
  List<Object> get props => [];
}

class QtzInitial extends QtzState {}

class QtzLoading extends QtzState {}

class QtzSuccess extends QtzState {
  final QtzModel qtzModel;

  QtzSuccess({@required this.qtzModel});
}
class QtzFailure extends QtzState {
  final String error;

  const QtzFailure({@required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'QtzFailure { error: $error }';
}


class QtzTagInitial extends QtzState {}

class QtzTagLoading extends QtzState {}

class QtzTagSuccess extends QtzState {
  final QtzModel qtzModel;

  QtzTagSuccess({@required this.qtzModel});
}
class QtzTagFailure extends QtzState {
  final String error;

  const QtzTagFailure({@required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'QtzFailure { error: $error }';
}
