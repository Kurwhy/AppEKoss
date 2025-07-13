part of 'register_bloc.dart';

sealed class RegisterEvent {}

final class RegisterRequested extends RegisterEvent {
  final RegisterRequestModel requestModel;

  RegisterRequested({required this.requestModel});
}