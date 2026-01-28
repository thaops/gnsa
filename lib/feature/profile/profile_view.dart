import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gnsa/core/services/services.dart';
import 'package:gnsa/common/widgets/app_bar_widget.dart';
import 'package:gnsa/router/app_router.dart';
import 'package:go_router/go_router.dart';

class ProfileApp extends StatelessWidget {
  const ProfileApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: const ProfileScreen(),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: 'Profile',
        isTitleCenter: false,
        iconRightFirst: Icons.logout,
        onPressedFirst: () async{
          final services = await Services.create();
          await services.deleteAccessToken();
          GoRouter.of(context).push(AppRouter.login);
        },
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 4),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 48,
                        child: CachedNetworkImage(
                          imageUrl: 'https://sdmntprpolandcentral.oaiusercontent.com/files/00000000-b468-620a-ba2f-a6e41d3cfda8/raw?se=2025-06-17T10%3A58%3A42Z&sp=r&sv=2024-08-04&sr=b&scid=4b3062b3-f42e-506a-808e-08b26536fb8b&skoid=b0fd38cc-3d33-418f-920e-4798de4acdd1&sktid=a48cca56-e6da-484e-a814-9c849652bcb3&skt=2025-06-17T06%3A07%3A06Z&ske=2025-06-18T06%3A07%3A06Z&sks=b&skv=2024-08-04&sig=iltlc4A/rdh9WKcZoqKf7gJfV1XgqdcsGKPbQX6oPvE%3D',
                          placeholder: (context, url) => const CircularProgressIndicator(),
                          errorWidget: (context, url, error) => const Text(
                            'JD',
                            style: TextStyle(fontSize: 24),
                          ),
                          imageBuilder: (context, imageProvider) => CircleAvatar(
                            radius: 48,
                            backgroundImage: imageProvider,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: -4,
                      right: -4,
                      child: FloatingActionButton(
                        mini: true,
                        backgroundColor: Colors.white,
                        child: const Icon(Icons.camera_alt, size: 20, color: Colors.black87),
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Card(
                color: Colors.white,
                elevation: 1,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Contact Information',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 16),
                      _buildContactItem(Icons.email, 'john.doe@example.com', 'Email'),
                      _buildContactItem(Icons.phone, '+1 (555) 123-4567', 'Phone'),
                      _buildContactItem(Icons.location_on, 'San Francisco, CA', 'Location'),
                      _buildContactItem(Icons.language, 'johndoe.design', 'Website'),
                      _buildContactItem(Icons.calendar_today, 'Joined March 2022', 'Member since'),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildContactItem(IconData icon, String value, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              Text(
                label,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }
}