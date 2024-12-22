import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _nameController = TextEditingController();
  final _locationController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _bioController = TextEditingController();
  bool _isEditing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.save : Icons.edit),
            onPressed: () async {
              if (_isEditing) {
                try {
                  await AuthService.updateProfile(
                    name: _nameController.text,
                    location: _locationController.text,
                    phone: _phoneController.text,
                    address: _addressController.text,
                    bio: _bioController.text,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Profile updated!')),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: $e')),
                  );
                }
              }
              setState(() {
                _isEditing = !_isEditing;
              });
            },
          ),
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                child: ListTile(
                  leading: const Icon(Icons.delete),
                  title: const Text('Delete Account'),
                  textColor: Colors.red,
                  iconColor: Colors.red,
                ),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Delete Account'),
                      content: const Text(
                        'Are you sure? This action cannot be undone.',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () async {
                            try {
                              await AuthService.deleteAccount();
                              if (mounted) {
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const LoginScreen(),
                                  ),
                                  (route) => false,
                                );
                              }
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Error: $e')),
                              );
                            }
                          },
                          child: const Text(
                            'Delete',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
      body: StreamBuilder(
        stream: AuthService.getUserProfile(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData) {
            return const Center(child: Text('No profile data'));
          }

          final userData = snapshot.data!.data() as Map<String, dynamic>;
          
          if (!_isEditing) {
            _nameController.text = userData['name'] ?? '';
            _locationController.text = userData['location'] ?? '';
            _phoneController.text = userData['phone'] ?? '';
            _addressController.text = userData['address'] ?? '';
            _bioController.text = userData['bio'] ?? '';
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const CircleAvatar(
                radius: 50,
                backgroundColor: Colors.green,
                child: Icon(Icons.person, size: 50, color: Colors.white),
              ),
              const SizedBox(height: 16),
              _buildEditableField(
                controller: _nameController,
                label: 'Name',
                icon: Icons.person,
                value: userData['name'],
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.email),
                title: const Text('Email'),
                subtitle: Text(userData['email'] ?? 'No Email'),
              ),
              const SizedBox(height: 16),
              _buildEditableField(
                controller: _locationController,
                label: 'Location',
                icon: Icons.location_on,
                value: userData['location'],
              ),
              const SizedBox(height: 16),
              _buildEditableField(
                controller: _phoneController,
                label: 'Phone',
                icon: Icons.phone,
                value: userData['phone'],
              ),
              const SizedBox(height: 16),
              _buildEditableField(
                controller: _addressController,
                label: 'Address',
                icon: Icons.home,
                value: userData['address'],
                maxLines: 2,
              ),
              const SizedBox(height: 16),
              _buildEditableField(
                controller: _bioController,
                label: 'Bio',
                icon: Icons.info,
                value: userData['bio'],
                maxLines: 3,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () async {
                  await AuthService.signOut();
                  if (mounted) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                child: const Text('Logout'),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildEditableField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String? value,
    int maxLines = 1,
  }) {
    return _isEditing
        ? TextField(
            controller: controller,
            decoration: InputDecoration(
              labelText: label,
              border: const OutlineInputBorder(),
              prefixIcon: Icon(icon),
            ),
            maxLines: maxLines,
          )
        : ListTile(
            leading: Icon(icon),
            title: Text(label),
            subtitle: Text(value ?? 'Not set'),
          );
  }
}