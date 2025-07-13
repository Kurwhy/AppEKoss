part of 'login_bloc.dart';


sealed class LoginEvent {}

final class LoginRequested extends LoginEvent{
  final LoginRequestModel requestModel;
  LoginRequested({required this.requestModel});
}