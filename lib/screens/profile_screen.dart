import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:worker_app/main.dart';
import 'dart:ui';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<void> _logout(BuildContext context) async {
    // Clear SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('worker_data');

    // Clear worker provider
    if (!context.mounted) return;
    context.read<WorkerProvider>().clearWorker();

    // Navigate to login screen
    if (!context.mounted) return;
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    final worker = context.watch<WorkerProvider>().worker;

    if (worker == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF2196F3), Color(0xFF1976D2)],
              ),
            ),
            height: 200,
          ),
          // Frosted glass effect
          ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                ),
              ),
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                // Profile header
                Container(
                  padding: const EdgeInsets.fromLTRB(16, 40, 16, 20),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.logout, color: Colors.white),
                            onPressed: () => _logout(context),
                          ),
                        ],
                      ),
                      const CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.white,
                        child: Icon(Icons.person,
                            size: 50, color: Color(0xFF1976D2)),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        worker.fullName,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                // Info cards
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoCard(
                        title: 'Worker ID',
                        value: worker.id.toString(),
                      ),
                      const SizedBox(height: 16),
                      _buildInfoCard(
                        title: 'Full Name',
                        value: worker.fullName,
                      ),
                      const SizedBox(height: 16),
                      _buildInfoCard(
                        title: 'Email',
                        value: worker.email,
                      ),
                      const SizedBox(height: 16),
                      _buildInfoCard(
                        title: 'Phone Number',
                        value: worker.phone,
                      ),
                      const SizedBox(height: 16),
                      _buildInfoCard(
                        title: 'Address',
                        value: worker.address,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({required String title, required String value}) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white,
              Colors.blue.shade50,
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    _getIconForTitle(title),
                    size: 20,
                    color: const Color(0xFF1976D2),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1976D2),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getIconForTitle(String title) {
    switch (title) {
      case 'Worker ID':
        return Icons.badge;
      case 'Full Name':
        return Icons.person;
      case 'Email':
        return Icons.email;
      case 'Phone Number':
        return Icons.phone;
      case 'Address':
        return Icons.location_on;
      default:
        return Icons.info;
    }
  }
}
