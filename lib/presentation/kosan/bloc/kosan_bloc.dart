import 'package:flutter_bloc/flutter_bloc.dart';
import 'kosan_event.dart';
import 'kosan_state.dart';
import '../../../data/repository/kosan_repository.dart';

class KosanBloc extends Bloc<KosanEvent, KosanState> {
  final KosanRepository repository;

  KosanBloc(this.repository) : super(KosanInitial()) {
    // 🔁 Fetch Kosans
    on<FetchKosans>((event, emit) async {
      emit(KosanLoading());
      try {
        final kosans = await repository.fetchKosans();
        emit(KosanLoaded(kosans));
      } catch (e) {
        emit(KosanError(e.toString()));
      }
    });

    // ➕ Create Kosan
    on<CreateKosan>((event, emit) async {
      emit(KosanLoading());
      try {
        await repository.createKosan(event.request);
        emit(KosanSuccess());
        await Future.delayed(const Duration(milliseconds: 300)); // prevent emit-after-complete error
        add(FetchKosans());
      } catch (e) {
        emit(KosanError(e.toString()));
      }
    });

    // ✏️ Update Kosan
    on<UpdateKosan>((event, emit) async {
      emit(KosanLoading());
      try {
        await repository.updateKosan(event.id, event.request);
        emit(KosanSuccess());
        await Future.delayed(const Duration(milliseconds: 300));
        add(FetchKosans());
      } catch (e) {
        emit(KosanError(e.toString()));
      }
    });

    // ❌ Delete Kosan
    on<DeleteKosan>((event, emit) async {
      emit(KosanLoading());
      try {
        await repository.deleteKosan(event.id);
        emit(KosanSuccess());
        await Future.delayed(const Duration(milliseconds: 300));
        add(FetchKosans());
      } catch (e) {
        emit(KosanError(e.toString()));
      }
    });
  }
}