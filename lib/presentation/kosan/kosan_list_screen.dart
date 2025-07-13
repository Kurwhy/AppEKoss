import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repository/kosan_repository.dart';
import 'bloc/kosan_bloc.dart';
import 'bloc/kosan_event.dart';
import 'bloc/kosan_state.dart';

class KosanListScreen extends StatelessWidget {
  final KosanRepository repository;

  const KosanListScreen({super.key, required this.repository});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => KosanBloc(repository)..add(FetchKosans()),
      child: Scaffold(
        appBar: AppBar(title: const Text('Daftar Kosan')),
        body: BlocBuilder<KosanBloc, KosanState>(
          builder: (context, state) {
            if (state is KosanLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is KosanLoaded) {
              return ListView.builder(
                itemCount: state.kosans.length,
                itemBuilder: (context, index) {
                  final kosan = state.kosans[index];
                  return ListTile(
                    title: Text(kosan.nama),
                    subtitle: Text(kosan.alamat),
                    leading: kosan.images.isNotEmpty
                        ? Image.network(kosan.images.first, width: 60, fit: BoxFit.cover)
                        : const Icon(Icons.image),
                  );
                },
              );
            } else if (state is KosanError) {
              return Center(child: Text(state.message));
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}
