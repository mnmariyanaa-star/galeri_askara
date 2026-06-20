import 'dart:async';
import 'package:flutter/material.dart';
import 'artwork_detail_page.dart';
import 'add_product_page.dart';
import 'profile_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      HomeContent(),
      const AddProductPage(),
      const ProfilePage(
        userName: 'Kairi',
        userEmail: 'kairi@example.com',
        userPhoto: 'img/assets/kairi.png',
        userLocation: 'Jakarta',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      floatingActionButton: FloatingActionButton(
        backgroundColor: _currentIndex == 1 ? Colors.blue.shade800 : Colors.blue,
        onPressed: () {
          setState(() {
            _currentIndex = 1;
          });
        },
        child: const Icon(Icons.add, size: 32),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        color: Colors.blue,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: Icon(
                Icons.home,
                color: _currentIndex == 0 ? Colors.white : Colors.white54,
              ),
              onPressed: () {
                setState(() {
                  _currentIndex = 0;
                });
              },
            ),
            const SizedBox(width: 40), // Spacer for FAB
            IconButton(
              icon: Icon(
                Icons.person,
                color: _currentIndex == 2 ? Colors.white : Colors.white54,
              ),
              onPressed: () {
                setState(() {
                  _currentIndex = 2;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}

class HomeContent extends StatefulWidget {
  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  int _selectedTopMenu = 0; // 0: none, 1: Favorites, 2: History, 3: Following
  String _searchText = '';
  String? _selectedCategory;

  // Tambahan state baru
  List<String> favoriteTitles = [];
  List<String> viewedTitles = [];
  List<String> followingCreators = ['Vincent van Gogh', 'Leonardo da Vinci']; // Contoh, bisa diubah

  int _currentBannerIndex = 0;
  late Timer _timer;
  final PageController _pageController = PageController(viewportFraction: 0.9);

  final List<String> bannerImages = [
    'img/assets/baner1.jpg',
    'img/assets/baner2.jpg',
    'img/assets/baner3.jpg',
    'img/assets/baner4.jpg',
    'img/assets/baner5.jpg',
    'img/assets/baner6.jpg',
  ];

  final List<Map<String, String>> categories = [
    {'name': 'Impresionisme', 'image': 'img/assets/impresionisme.png'},
    {'name': 'Realisme', 'image': 'img/assets/realisme.png'},
    {'name': 'Surealisme', 'image': 'img/assets/surealisme.png'},
    {'name': 'Ekspresionisme', 'image': 'img/assets/ekspresionisme.png'},
  ];

  final List<Map<String, dynamic>> artworks = [
    {
      'title': 'Mona Lisa',
      'creator': 'Leonardo da Vinci',
      'category': 'Realisme',
      'images': [
        'img/assets/monalisa1.jpg',
        'img/assets/monalisa2.jpg',
        'img/assets/monalisa3.jpg',
      ],
      'description': 'Mona Lisa adalah lukisan karya Leonardo da Vinci. Merupakan salah satu karya seni paling terkenal di dunia.',
    },
    {
      'title': 'Starry Night',
      'creator': 'Vincent van Gogh',
      'category': 'Impresionisme',
      'images': [
        'img/assets/starrynight1.jpg',
        'img/assets/starrynight2.jpg',
        'img/assets/starrynight3.jpg',
      ],
      'description': 'Starry Night dilukis tahun 1889 oleh Vincent van Gogh. Salah satu mahakarya impresionis.',
    },
    {
      'title': 'The Persistence of Memory',
      'creator': 'Salvador Dalí',
      'category': 'Surealisme',
      'images': [
        'img/assets/dali1.jpg',
        'img/assets/dali2.jpg',
        'img/assets/dali3.jpg',
      ],
      'description': 'Jam meleleh karya Salvador Dalí, surealisme.',
    },
    {
      'title': 'The Scream',
      'creator': 'Edvard Munch',
      'category': 'Ekspresionisme',
      'images': [
        'img/assets/scream1.jpg',
        'img/assets/scream2.jpg',
        'img/assets/scream3.jpg',
      ],
      'description': 'Ekspresionisme dari Edvard Munch.',
    },
    {
      'title': 'Girl with a Pearl Earring',
      'creator': 'Johannes Vermeer',
      'category': 'Realisme',
      'images': [
        'img/assets/pearl1.jpg',
        'img/assets/pearl2.jpg',
        'img/assets/pearl3.jpg',
      ],
      'description': 'Mona Lisa dari Utara, karya Vermeer.',
    },
    {
      'title': 'Guernica',
      'creator': 'Pablo Picasso',
      'category': 'Ekspresionisme',
      'images': [
        'img/assets/guernica1.jpg',
        'img/assets/guernica2.jpg',
        'img/assets/guernica3.jpg',
      ],
      'description': 'Mural monumental oleh Picasso.',
    },
  ];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (_currentBannerIndex < bannerImages.length - 1) {
        _currentBannerIndex++;
      } else {
        _currentBannerIndex = 0;
      }
      _pageController.animateToPage(
        _currentBannerIndex,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  // Setter untuk Favorite
  void setFavorite(String title, bool isFav) {
    setState(() {
      if (isFav && !favoriteTitles.contains(title)) {
        favoriteTitles.add(title);
      } else if (!isFav && favoriteTitles.contains(title)) {
        favoriteTitles.remove(title);
      }
    });
  }

  // Setter untuk History
  void addToHistory(String title) {
    setState(() {
      if (!viewedTitles.contains(title)) viewedTitles.add(title);
    });
  }

  // Getter untuk filter
  List<Map<String, dynamic>> get _filteredArtworks {
    List<Map<String, dynamic>> filtered = artworks;

    // Filter menu
    if (_selectedTopMenu == 1) {
      filtered = filtered.where((art) => favoriteTitles.contains(art['title'])).toList();
    } else if (_selectedTopMenu == 2) {
      filtered = filtered.where((art) => viewedTitles.contains(art['title'])).toList();
    } else if (_selectedTopMenu == 3) {
      filtered = filtered.where((art) => followingCreators.contains(art['creator'])).toList();
    }

    // Filter kategori
    if (_selectedCategory != null) {
      filtered = filtered.where((art) =>
      (art['category']?.toLowerCase() ?? '') == _selectedCategory!.toLowerCase()
      ).toList();
    }
    // Filter search
    if (_searchText.isNotEmpty) {
      filtered = filtered.where((art) =>
          (art['title'] as String).toLowerCase().contains(_searchText.toLowerCase())
      ).toList();
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search
              Padding(
                padding: const EdgeInsets.all(8),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onChanged: (val) {
                    setState(() {
                      _searchText = val;
                    });
                  },
                ),
              ),
              // Top menu
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildTopButton(Icons.favorite, 'Favorites', 1),
                  _buildTopButton(Icons.history, 'History', 2),
                  _buildTopButton(Icons.person_add, 'Following', 3),
                ],
              ),
              const SizedBox(height: 8),
              // Banner + dot indicator
              SizedBox(
                height: 200,
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    PageView.builder(
                      controller: _pageController,
                      itemCount: bannerImages.length,
                      onPageChanged: (index) {
                        setState(() {
                          _currentBannerIndex = index;
                        });
                      },
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset(
                              bannerImages[index],
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                    ),
                    Positioned(
                      bottom: 10,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          bannerImages.length,
                              (index) => Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: _currentBannerIndex == index ? 10 : 6,
                            height: _currentBannerIndex == index ? 10 : 6,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _currentBannerIndex == index ? Colors.blue : Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: const [
                    Text(
                      'Cari berdasarkan',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Spacer(),
                    Icon(Icons.arrow_forward_ios, size: 14),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    final isSelected = _selectedCategory == category['name'];
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedCategory =
                          isSelected ? null : category['name'];
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 30,
                              backgroundColor: isSelected ? Colors.blue[50] : Colors.grey[100],
                              backgroundImage: AssetImage(category['image']!),
                            ),
                            const SizedBox(height: 4),
                            SizedBox(
                              width: 80,
                              child: Text(
                                category['name']!,
                                maxLines: 2,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                  color: isSelected ? Colors.blue : Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  'Untuk Anda',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.all(12),
                itemCount: _filteredArtworks.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.7,
                ),
                itemBuilder: (context, index) {
                  final art = _filteredArtworks[index];
                  return GestureDetector(
                    onTap: () async {
                      // Mark as viewed (History)
                      addToHistory(art['title']);

                      // Buka detail, kirim favorit, callback onFavChanged
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ArtworkDetailPage(
                            artwork: art,
                            isFav: favoriteTitles.contains(art['title']),
                            onFavChanged: (isFav) => setFavorite(art['title'], isFav),
                          ),
                        ),
                      );
                    },
                    child: Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                            child: Image.asset(
                              art['images'][0],
                              fit: BoxFit.cover,
                              height: 140,
                              width: double.infinity,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Text(
                              art['title'],
                              style: const TextStyle(fontWeight: FontWeight.bold),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Text(
                              art['creator'],
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopButton(IconData icon, String label, int id) {
    final isSelected = _selectedTopMenu == id;
    return InkWell(
      onTap: () {
        setState(() {
          _selectedTopMenu = id;
        });
      },
      child: Column(
        children: [
          Icon(icon, color: isSelected ? Colors.blue : Colors.grey),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.blue : Colors.grey,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
