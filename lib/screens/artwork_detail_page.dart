import 'package:flutter/material.dart';
import 'chat_page.dart'; // sesuaikan path!

class ArtworkDetailPage extends StatefulWidget {
  final Map<String, dynamic> artwork;
  final bool isFav;
  final ValueChanged<bool> onFavChanged;

  const ArtworkDetailPage({
    Key? key,
    required this.artwork,
    this.isFav = false,
    required this.onFavChanged,
  }) : super(key: key);

  @override
  State<ArtworkDetailPage> createState() => _ArtworkDetailPageState();
}

class _ArtworkDetailPageState extends State<ArtworkDetailPage> {
  int _currentImage = 0;
  late bool _isLoved;
  final List<Map<String, String>> _savedImages = [];

  @override
  void initState() {
    super.initState();
    _isLoved = widget.isFav;
  }

  @override
  Widget build(BuildContext context) {
    final List<String> images = List<String>.from(widget.artwork['images'] ?? []);
    final String title = widget.artwork['title'] ?? 'Artwork Title';
    final String creator = widget.artwork['creator'] ?? 'Creator';
    final String location = widget.artwork['location'] ?? 'Naperville, Illinois';
    final String description = widget.artwork['description'] ?? 'Description not available.';

    final stats = [
      {'label': '198', 'desc': 'kcal'},
      {'label': '25.2', 'desc': 'proteins'},
      {'label': '13.8', 'desc': 'fats'},
      {'label': '23.7', 'desc': 'carbo'},
    ];

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("Details", style: TextStyle(color: Colors.black)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(_isLoved ? Icons.favorite : Icons.favorite_border,
                color: _isLoved ? Colors.red : Colors.black),
            onPressed: () {
              setState(() {
                _isLoved = !_isLoved;
                widget.onFavChanged(_isLoved); // Panggil callback ke HomeContent
              });
            },
            tooltip: 'Favorite',
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: 260,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                PageView.builder(
                  itemCount: images.length,
                  onPageChanged: (i) => setState(() => _currentImage = i),
                  itemBuilder: (context, i) => GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (_) => Dialog(
                          backgroundColor: Colors.transparent,
                          child: InteractiveViewer(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(24),
                              child: Image.asset(
                                images[i],
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: Image.asset(
                          images[i],
                          height: 240,
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      ),
                    ),
                  ),
                ),
                if (images.length > 1)
                  Positioned(
                    bottom: 8,
                    child: Row(
                      children: List.generate(images.length, (i) {
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: _currentImage == i ? 10 : 7,
                          height: _currentImage == i ? 10 : 7,
                          decoration: BoxDecoration(
                            color: _currentImage == i ? Colors.blue : Colors.grey,
                            shape: BoxShape.circle,
                          ),
                        );
                      }),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(top: 8),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.location_on, color: Colors.grey, size: 16),
                        const SizedBox(width: 4),
                        Text(location, style: const TextStyle(color: Colors.grey, fontSize: 13)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(18),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                      margin: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: stats.map((stat) {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(stat['label']!, style: const TextStyle(fontWeight: FontWeight.bold)),
                              const SizedBox(height: 2),
                              Text(stat['desc']!, style: const TextStyle(fontSize: 13, color: Colors.black54)),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                    const Text('Description', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 2),
                    Text(description),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _savedImages.add({'title': title, 'image': images[_currentImage]});
                          });
                          showModalBottomSheet(
                            context: context,
                            builder: (_) => _SavedImagesSheet(savedImages: _savedImages),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                        child: const Text("Save", style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      height: 44,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const ChatPage()),
                          );
                        },
                        icon: const Icon(Icons.chat, color: Colors.blue),
                        label: const Text("Chat Now", style: TextStyle(color: Colors.blue)),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.blue, width: 1.4),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SavedImagesSheet extends StatelessWidget {
  final List<Map<String, String>> savedImages;
  const _SavedImagesSheet({required this.savedImages});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 280,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text("Gambar yang Disimpan", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          ),
          Expanded(
            child: savedImages.isEmpty
                ? const Center(child: Text("Belum ada gambar disimpan."))
                : ListView.builder(
              itemCount: savedImages.length,
              itemBuilder: (context, i) => ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(savedImages[i]['image']!, width: 48, height: 48, fit: BoxFit.cover),
                ),
                title: Text(savedImages[i]['title'] ?? ""),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
