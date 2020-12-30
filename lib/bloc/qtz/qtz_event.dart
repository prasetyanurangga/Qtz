import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class QtzEvent extends Equatable {
  const QtzEvent();
  @override
  List<Object> get props => [];
}

class GetQuotes extends QtzEvent {
	final String filter;
	final String type;
  	GetQuotes({
  		@required this.filter, 
  		@required this.type
  	});
}

class GetTagQuotes extends QtzEvent {
	final String filter;
	final String type;
  	GetTagQuotes({
  		@required this.filter, 
  		@required this.type
  	});
}