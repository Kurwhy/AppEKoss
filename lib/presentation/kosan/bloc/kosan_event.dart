import 'package:equatable/equatable.dart';
import '../../../data/model/kosan/kosan_create_request.dart';

abstract class KosanEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchKosans extends KosanEvent {}

class CreateKosan extends KosanEvent {
  final KosanCreateRequest request;

  CreateKosan(this.request);

  @override
  List<Object?> get props => [request];
}

class UpdateKosan extends KosanEvent {
  final int id;
  final KosanCreateRequest request;

  UpdateKosan(this.id, this.request);

  @override
  List<Object?> get props => [id, request];
}

class DeleteKosan extends KosanEvent {
  final int id;

  DeleteKosan(this.id);

  @override
  List<Object?> get props => [id];
}
