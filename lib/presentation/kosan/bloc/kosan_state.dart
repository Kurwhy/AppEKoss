import 'package:equatable/equatable.dart';
import '../../../data/model/kosan/kosan_model.dart';

abstract class KosanState extends Equatable {
  @override
  List<Object?> get props => [];
}

class KosanInitial extends KosanState {}

class KosanLoading extends KosanState {}

class KosanLoaded extends KosanState {
  final List<KosanModel> kosans;

  KosanLoaded(this.kosans);

  @override
  List<Object?> get props => [kosans];
}

class KosanSuccess extends KosanState {}

class KosanError extends KosanState {
  final String message;

  KosanError(this.message);

  @override
  List<Object?> get props => [message];
}
