import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/repository/kosan_repository.dart';
import 'kosan/bloc/kosan_bloc.dart';
import 'kosan/bloc/kosan_state.dart';
import 'kosan/bloc/kosan_event.dart';


const dummyUserName = "Wahyu Firmansyah";

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  void _onNavTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  String formatImageUrl(String path) {
    if (path.startsWith("http")) return path;
    return "http://10.0.2.2:8000/storage/kosan_images/$path";
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          KosanBloc(context.read<KosanRepository>())..add(FetchKosans()),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.teal,
          elevation: 0,
          title: const Text(
            'eKost',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        body: Column(
          children: [
            Container(
              width: double.infinity,
              color: Colors.teal[100],
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.teal,
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Selamat datang,',
                        style: TextStyle(fontSize: 14),
                      ),
                      Text(
                        dummyUserName,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Expanded(
              child: _buildTabContent(),
            )
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onNavTapped,
          selectedItemColor: Colors.teal,
          unselectedItemColor: Colors.grey,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.receipt), label: 'Transaksi'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
        ),
      ),
    );
  }

  Widget _buildTabContent() {
    if (_selectedIndex == 0) {
      // Home (Daftar kosan)
      return Padding(
        padding: const EdgeInsets.all(12),
        child: BlocBuilder<KosanBloc, KosanState>(
          builder: (context, state) {
            if (state is KosanLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is KosanLoaded) {
              final kosans = state.kosans;
              if (kosans.isEmpty) {
                return const Center(child: Text('Belum ada kosan tersedia'));
              }
              return ListView.builder(
                itemCount: kosans.length,
                itemBuilder: (context, index) {
                  final kosan = kosans[index];
                  final imageUrl = kosan.images.isNotEmpty
                      ? formatImageUrl(kosan.images.first)
                      : null;

                  return Card(
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: InkWell(
                      onTap: () {
                        // Navigasi ke detail kosan
                        // Navigator.push(context, MaterialPageRoute(builder: (_) => KosanDetailScreen(kosan: kosan)));
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          imageUrl != null
                              ? Image.network(
                                  imageUrl,
                                  width: double.infinity,
                                  height: 180,
                                  fit: BoxFit.cover,
                                  errorBuilder:
                                      (context, error, stackTrace) =>
                                          const SizedBox(
                                            height: 180,
                                            child: Center(
                                              child: Icon(
                                                Icons.broken_image,
                                                size: 48,
                                              ),
                                            ),
                                          ),
                                )
                              : const SizedBox(
                                  height: 180,
                                  child: Center(
                                    child: Icon(Icons.image, size: 48),
                                  ),
                                ),
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  kosan.nama,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  kosan.alamat,
                                  style: const TextStyle(color: Colors.grey),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: const [
                                    Icon(
                                      Icons.location_on,
                                      size: 16,
                                      color: Colors.teal,
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      "Lihat di Peta",
                                      style: TextStyle(color: Colors.teal),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            } else if (state is KosanError) {
              return Center(child: Text(state.message));
            }
            return const SizedBox.shrink();
          },
        ),
      );
    } else if (_selectedIndex == 1) {
      // Transaksi tab
      return const Center(child: Text('Halaman Transaksi belum tersedia'));
    } else {
      // Profile tab
      return const Center(child: Text('Halaman Profil belum tersedia'));
    }
  }
}