import 'package:flutter/material.dart';
// Import halaman login kamu
import 'login_screen.dart';

// Dummy pages for menu
class FavouritesPage extends StatelessWidget {
  const FavouritesPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Favourites')),
    body: const Center(child: Text('Daftar Favorit Anda Kosong')),
  );
}

class DownloadsPage extends StatelessWidget {
  const DownloadsPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Downloads')),
    body: const Center(child: Text('Belum ada file terdownload')),
  );
}

class SubscriptionPage extends StatelessWidget {
  const SubscriptionPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Subscription')),
    body: const Center(child: Text('Belum ada subscription aktif')),
  );
}

// ================== PROFILE PAGE ===================
class ProfilePage extends StatefulWidget {
  final String userName;
  final String userEmail;
  final String userPhoto;
  final String userLocation;

  const ProfilePage({
    Key? key,
    required this.userName,
    required this.userEmail,
    required this.userPhoto,
    required this.userLocation,
  }) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late String _name;
  late String _email;
  late String _photo;
  late String _location;

  @override
  void initState() {
    super.initState();
    _name = widget.userName;
    _email = widget.userEmail;
    _photo = widget.userPhoto;
    _location = widget.userLocation;
  }

  void _updateProfile(String name, String email, String photo, String location) {
    setState(() {
      _name = name;
      _email = email;
      _photo = photo;
      _location = location;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Profile", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Fitur setting lain
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Fitur setting coming soon")));
            },
          )
        ],
      ),
      backgroundColor: Colors.grey[100],
      body: Column(
        children: [
          const SizedBox(height: 24),
          Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 44,
                  backgroundImage: AssetImage(_photo),
                ),
                const SizedBox(height: 12),
                Text(_name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 19)),
                Text("@${_email.split('@')[0]}", style: TextStyle(color: Colors.grey[600])),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EditProfilePage(
                          name: _name,
                          email: _email,
                          photo: _photo,
                          location: _location,
                        ),
                      ),
                    );
                    if (result != null && result is Map<String, String>) {
                      _updateProfile(
                        result['name'] ?? _name,
                        result['email'] ?? _email,
                        result['photo'] ?? _photo,
                        result['location'] ?? _location,
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[400],
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
                    padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 7),
                  ),
                  child: const Text("Edit Profile"),
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
              ),
              child: ListView(
                children: [
                  _buildMenuTile(Icons.favorite, "Favourites", onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const FavouritesPage()));
                  }),
                  _buildMenuTile(Icons.download, "Downloads", onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const DownloadsPage()));
                  }),
                  _buildMenuTile(Icons.language, "Language", onTap: () {
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text('Pilih Bahasa'),
                        content: const Text('Fitur ganti bahasa coming soon'),
                        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK'))],
                      ),
                    );
                  }),
                  _buildMenuTile(Icons.location_on, "Location", onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Fitur lokasi coming soon")),
                    );
                  }),
                  _buildMenuTile(Icons.subscriptions, "Subscription", onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const SubscriptionPage()));
                  }),
                  const Divider(),
                  _buildMenuTile(Icons.cached, "Clear cache", onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Cache dibersihkan!")),
                    );
                  }),
                  _buildMenuTile(Icons.history, "Clear history", onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("History dibersihkan!")),
                    );
                  }),
                  _buildMenuTile(
                    Icons.logout, "Log out",
                    color: Colors.red[400],
                    onTap: () {
                      // Balik ke LoginScreen & clear history
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => const LoginScreen()),
                            (route) => false,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuTile(IconData icon, String label, {Color? color, VoidCallback? onTap}) {
    return ListTile(
      leading: Icon(icon, color: color ?? Colors.black),
      title: Text(label, style: TextStyle(color: color ?? Colors.black)),
      onTap: onTap,
      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
    );
  }
}

// =============== EDIT PROFILE PAGE ===============
class EditProfilePage extends StatefulWidget {
  final String name, email, photo, location;
  const EditProfilePage({super.key, required this.name, required this.email, required this.photo, required this.location});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController locationController;
  late String photoPath;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.name);
    emailController = TextEditingController(text: widget.email);
    locationController = TextEditingController(text: widget.location);
    photoPath = widget.photo;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text("Edit Profile", style: TextStyle(color: Colors.black)),
        actions: [
          IconButton(
            icon: const Icon(Icons.check, color: Colors.green, size: 28),
            onPressed: () {
              Navigator.pop(context, {
                'name': nameController.text,
                'email': emailController.text,
                'photo': photoPath,
                'location': locationController.text,
              });
            },
          ),
        ],
      ),
      backgroundColor: Colors.grey[100],
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 22),
        children: [
          const SizedBox(height: 22),
          Center(
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 46,
                  backgroundImage: AssetImage(photoPath),
                ),
                Positioned(
                  bottom: 0,
                  right: 4,
                  child: GestureDetector(
                    onTap: () {
                      // TODO: Ganti profile picture dengan image picker
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Ganti foto belum diaktifkan")),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: Icon(Icons.edit, size: 23, color: Colors.grey[700]),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          _inputField("Name", controller: nameController),
          const SizedBox(height: 10),
          _inputField("E mail address", controller: emailController),
          const SizedBox(height: 10),
          _inputField("Location", controller: locationController),
        ],
      ),
    );
  }

  Widget _inputField(String label, {required TextEditingController controller, bool isPassword = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          obscureText: isPassword,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
          ),
        ),
      ],
    );
  }
}
