import 'package:app_ekos/data/model/request/auth/login_request_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:app_ekos/data/model/response/auth_response_model.dart';
import 'package:app_ekos/data/repository/auth_repository.dart';
import 'package:bloc/bloc.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository authRepository;
  LoginBloc({required this.authRepository}) : super(LoginInitial()) {
    on<LoginRequested>(_onLoginRequested);
  }
  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginLoading());

    final result = await authRepository.login(event.requestModel);
    await result.fold(
      (l) async {
        emit(LoginFailure(error: l));
      },
      (r) async {
        final storage = FlutterSecureStorage();
        await storage.write(key: 'token', value: r.data!.token);
        await storage.write(key: 'role', value: r.data!.role);
        emit(LoginSuccess(responseModel: r));
      },
    );
  }
}
